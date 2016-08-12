module Workers.App.Update exposing (update)

import Workers.App.Model as Model exposing (Model)
import Workers.App.Msg as Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Hello _ _ ->
            ( model, Cmd.none )
