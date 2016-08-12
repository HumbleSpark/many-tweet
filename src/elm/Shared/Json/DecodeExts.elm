module Shared.Json.DecodeExts exposing (..)

import Json.Decode as Decode


msg : (String -> Decode.Decoder a) -> Decode.Decoder a
msg innerParser =
    Decode.at [ "ctor" ] Decode.string
        |> (flip Decode.andThen) (innerParser >> Decode.at [ "args" ])


decodeUnsafe : Decode.Decoder a -> Decode.Value -> a
decodeUnsafe decoder value =
    case Decode.decodeValue decoder value of
        Ok result ->
            result

        Err _ ->
            Debug.crash "Unsafe decoding crashed with " value
