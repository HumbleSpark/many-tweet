module Shared.LoadState exposing (..)


type LoadState x a
    = Initial
    | Loading
    | Success a
    | Failure x


fromResult : Result x a -> LoadState x a
fromResult result =
    case result of
        Ok a ->
            Success a

        Err x ->
            Failure x
