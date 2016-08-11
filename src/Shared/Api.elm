module Shared.Api
    exposing
        ( ApiError(..)
        , postTweets
        )

import Task exposing (Task)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline as Decode exposing (..)
import Json.Encode as Encode


type ApiError
    = NotAuthorized
    | NetworkIssue
    | ServerFailure String


type alias User =
    { username : String
    , imageUrl : String
    }


unitReader : BodyReader ()
unitReader =
    always (Ok ())


parseError : String -> HttpBuilder.Error x -> ApiError
parseError message httpError =
    case httpError of
        BadResponse response ->
            if response.status == 403 then
                NotAuthorized
            else
                ServerFailure message

        _ ->
            NetworkIssue


processTask : String -> Task (Error x) (Response a) -> Task ApiError a
processTask message task =
    task
        |> Task.map .data
        |> Task.mapError (parseError message)


tweetIdDecoder : Decoder String
tweetIdDecoder =
    decode identity
        |> required "tweetId" string


tweetsEncoder : List String -> Encode.Value
tweetsEncoder tweets =
    Encode.object
        [ ( "tweets", Encode.list (List.map Encode.string tweets) )
        ]


postTweets : List String -> Task ApiError String
postTweets tweets =
    post "/post_tweets"
        |> withHeader "Content-Type" "application/json"
        |> withJsonBody (tweetsEncoder tweets)
        |> send (jsonReader tweetIdDecoder) unitReader
        |> processTask "Could not process tweets"
