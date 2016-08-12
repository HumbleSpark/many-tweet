module Shared.Json.EncodeExts exposing (..)

import Json.Encode as Encode


maybeNull : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybeNull encoder maybeValue =
    maybeValue
        |> Maybe.map encoder
        |> Maybe.withDefault Encode.null


msg : String -> List Encode.Value -> Encode.Value
msg ctor args =
    Encode.object
        [ ( "type", Encode.string ctor )
        , ( "args", Encode.list args )
        ]
