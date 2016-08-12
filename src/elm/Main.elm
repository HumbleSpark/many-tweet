module Main exposing (main)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode
import Navigation
import Shared.Pages as Pages exposing (parser)
import Shared.Utils exposing (..)
import Application.Messaging exposing (User, userDecoder)
import Application.Update as Application exposing (Flags)
import Application.View as Application
import Application.Model as Application


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.decode Flags
        |> Decode.required "user" (decodeNullOr userDecoder)


decodeFlags : Value -> Flags
decodeFlags value =
    case Decode.decodeValue flagsDecoder value of
        Ok result ->
            result

        Err _ ->
            Debug.crash "flags were wrong :("


update : Application.Msg -> Application.Model -> ( Application.Model, Cmd Application.Msg )
update msg model =
    let
        ( nextModel, nextCmd ) =
            Application.update (msg) model
    in
        ( nextModel
        , nextCmd
        )


init : Value -> Pages.Page -> ( Application.Model, Cmd Application.Msg )
init flags page =
    let
        ( nextModel, nextCmd ) =
            Application.init (decodeFlags flags) (page)
    in
        ( nextModel
        , nextCmd
        )


urlUpdate : Pages.Page -> Application.Model -> ( Application.Model, Cmd Application.Msg )
urlUpdate page model =
    let
        ( nextModel, nextCmd ) =
            Application.urlUpdate (page) model
    in
        ( nextModel
        , nextCmd
        )


main : Program Value
main =
    Navigation.programWithFlags parser
        { view = Application.view
        , update = update
        , init = init
        , urlUpdate = urlUpdate
        , subscriptions = Application.subscriptions
        }
