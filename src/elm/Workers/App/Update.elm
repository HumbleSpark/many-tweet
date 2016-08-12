module Workers.App.Update exposing (Msg, update, encoder, decoder)

import Json.Decode as Decode
import Shared.Json.DecodeExts as Decode
import Json.Encode as Encode
import Shared.Json.EncodeExts as Encode
import Workers.App.Model as Model exposing (Model)


type Msg
    = NoOp
    | Hello Int String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Hello _ _ ->
            ( model, Cmd.none )


encoder : Msg -> Encode.Value
encoder msg =
    case msg of
        NoOp ->
            Encode.msg "NoOp" []

        Hello a b ->
            Encode.msg "Hello"
                [ Encode.int a
                , Encode.string b
                ]


decoder : Decode.Decoder Msg
decoder =
    Decode.msg
        <| \ctor ->
            case ctor of
                "Hello" ->
                    Decode.tuple2 Hello
                        Decode.int
                        Decode.string

                _ ->
                    Decode.succeed NoOp
