module Screens.Compose.Update
    exposing
        ( Msg(..)
        , initialize
        , subscriptions
        , update
        )

import Application.Messaging exposing (AppContext, AppMsg(..))
import Shared.Api as Api exposing (ApiError(..))
import Shared.LoadState as LoadState exposing (LoadState(..))
import Shared.Utils exposing (..)
import Screens.Compose.Model as Model exposing (Model)


type Msg
    = NoOp
    | TextChanged String
    | PostButtonClick
    | PostTweetsComplete (Result ApiError String)
    | ResetButtonClick


initialize : AppContext -> Cmd Msg
initialize context =
    Cmd.none


subscriptions : AppContext -> Model -> Sub Msg
subscriptions context model =
    Sub.none


update : AppContext -> Msg -> Model -> ( Model, Cmd Msg, AppMsg )
update context msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            , NoneAppMsg
            )

        TextChanged value ->
            case context.user of
                Just user ->
                    ( model |> Model.updateTextAndParsed user.username value
                    , Cmd.none
                    , NoneAppMsg
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    , NoneAppMsg
                    )

        PostButtonClick ->
            ( { model | postTweetsState = Loading }
            , Api.postTweets model.parsed |> performSafely PostTweetsComplete
            , NoneAppMsg
            )

        PostTweetsComplete result ->
            ( { model | postTweetsState = LoadState.fromResult result }
            , Cmd.none
            , NoneAppMsg
            )

        ResetButtonClick ->
            ( model |> Model.reset
            , Cmd.none
            , NoneAppMsg
            )
