module Workers.App.Model exposing (Model, model, encoder, decoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode
import Shared.Entities.AppContext as AppContext exposing (AppContext)


type alias Model =
    { context : AppContext
    }


model : Model
model =
    { context = AppContext.appContext
    }


decoder : Decode.Decoder Model
decoder =
    Decode.decode Model
        |> Decode.required "context" AppContext.decoder


encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "context", AppContext.encoder model.context )
        ]
