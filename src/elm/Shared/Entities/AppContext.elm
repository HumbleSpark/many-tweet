module Shared.Entities.AppContext exposing (AppContext, appContext, encoder, decoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode
import Shared.Json.EncodeExts as Encode
import Shared.Entities.User as User exposing (User)


type alias AppContext =
    { currentUser : Maybe User
    }


appContext : AppContext
appContext =
    { currentUser = Nothing
    }


decoder : Decode.Decoder AppContext
decoder =
    Decode.decode AppContext
        |> Decode.optional "currentUser" (Decode.map Just User.decoder) Nothing


encoder : AppContext -> Encode.Value
encoder context =
    Encode.object
        [ ( "currentUser", Encode.maybeNull User.encoder context.currentUser )
        ]
