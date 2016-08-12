module Shared.Utils exposing (..)

import Task exposing (Task)
import Json.Decode as Decode exposing (Decoder)


never : Never -> a
never a =
    never a


performSafely : (Result x a -> msg) -> Task x a -> Cmd msg
performSafely tagger task =
    task
        |> Task.toResult
        |> Task.perform never tagger


decodeNullOr : Decoder a -> Decoder (Maybe a)
decodeNullOr valueDecoder =
    Decode.oneOf
        [ Decode.map Just valueDecoder
        , Decode.null Nothing
        ]


flatten : List (Maybe a) -> List a
flatten =
    List.filterMap identity
