module Shared.Entities.User exposing (User, decoder, encoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode


type alias User =
    { id : String
    , username : String
    , color : String
    }


decoder : Decode.Decoder User
decoder =
    Decode.decode User
        |> Decode.required "id" Decode.string
        |> Decode.required "username" Decode.string
        |> Decode.required "color" Decode.string


encoder : User -> Encode.Value
encoder user =
    Encode.object
        [ ( "id", Encode.string user.id )
        , ( "username", Encode.string user.username )
        , ( "color", Encode.string user.color )
        ]
