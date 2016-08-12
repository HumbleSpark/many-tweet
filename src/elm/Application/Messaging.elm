module Application.Messaging exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode


type alias User =
    { username : String
    , image : String
    , color : String
    }


userDecoder : Decoder User
userDecoder =
    Decode.decode User
        |> Decode.required "username" Decode.string
        |> Decode.required "image" Decode.string
        |> Decode.required "color" Decode.string


type AppMsg
    = LoginAppMsg User
    | LogoutAppMsg
    | NoneAppMsg


type alias AppContext =
    { user : Maybe User
    }


appContext : Maybe User -> AppContext
appContext =
    AppContext


contextUpdate : AppMsg -> AppContext -> AppContext
contextUpdate msg context =
    case msg of
        LoginAppMsg user ->
            { context | user = Just user }

        LogoutAppMsg ->
            { context | user = Nothing }

        NoneAppMsg ->
            context
