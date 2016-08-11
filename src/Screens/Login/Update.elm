port module Screens.Login.Update
    exposing
        ( Msg(..)
        , initialize
        , subscriptions
        , update
        )

import Json.Decode as Decode exposing (Decoder, Value)
import Application.Messaging exposing (AppContext, AppMsg(..), User, userDecoder)
import Shared.Pages as Pages exposing (Page(..))
import Screens.Login.Model as Model exposing (Model)


type Msg
    = NoOp
    | LoginStart
    | LoginComplete (Maybe User)


initialize : AppContext -> Cmd Msg
initialize context =
    if context.user /= Nothing then
        Pages.redirectTo ComposePage
    else
        Cmd.none


subscriptions : AppContext -> Model -> Sub Msg
subscriptions context model =
    if context.user /= Nothing then
        Sub.none
    else
        loginComplete


update : AppContext -> Msg -> Model -> ( Model, Cmd Msg, AppMsg )
update context msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            , NoneAppMsg
            )

        LoginStart ->
            if context.user /= Nothing then
                ( model
                , Pages.redirectTo ComposePage
                , NoneAppMsg
                )
            else
                ( model
                , loginStart ()
                , NoneAppMsg
                )

        LoginComplete userMaybe ->
            case userMaybe of
                Just user ->
                    ( model
                    , Pages.redirectTo ComposePage
                    , LoginAppMsg user
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    , LogoutAppMsg
                    )


port loginCompleteRaw : (Value -> msg) -> Sub msg


loginComplete : Sub Msg
loginComplete =
    loginCompleteRaw
        <| (Decode.decodeValue userDecoder)
        >> Result.toMaybe
        >> LoginComplete


port loginStart : () -> Cmd msg
