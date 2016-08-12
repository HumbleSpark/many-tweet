port module Workers.App.Main exposing (..)

import Json.Decode as Decode
import Shared.Json.DecodeExts as Decode
import Worker
import Workers.App.Model as Model
import Workers.App.Update as Update


port messages : (Decode.Value -> msg) -> Sub msg


port model : Decode.Value -> Cmd msg


main : Program Never
main =
    Worker.program (Model.encoder >> model)
        { update = Update.update
        , init = ( Model.model, Cmd.none )
        , subscriptions = \_ -> messages (Decode.decodeUnsafe Update.decoder)
        }
