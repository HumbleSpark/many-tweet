module Screens.Compose.View exposing (view)

import String
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers
import Shared.Utils exposing (..)
import Shared.Icons as Icons
import Shared.LoadState as LoadState exposing (LoadState(..))
import Application.Messaging exposing (AppContext, User)
import Screens.Compose.Model as Model exposing (Model)
import Screens.Compose.Update exposing (Msg(..))
import Screens.Compose.Classes exposing (..)


extractUserColor : Maybe User -> String
extractUserColor user =
    user
        |> Maybe.map .color
        |> Maybe.withDefault "#9C00FF"


extractUserUsername : Maybe User -> String
extractUserUsername user =
    user
        |> Maybe.map .username
        |> Maybe.withDefault ""


view : AppContext -> Model -> Html Msg
view context model =
    div []
        [ viewUserBanner context.user
        , viewPage context model
        ]


viewUserBanner : Maybe User -> Html Msg
viewUserBanner maybeUser =
    case maybeUser of
        Just user ->
            div [ class [ UserBanner ] ]
                [ div [ class [ UserImageContainer ] ]
                    [ img
                        [ src user.image
                        , class [ UserImage ]
                        , style [ ( "border-color", user.color ) ]
                        ]
                        []
                    ]
                , div
                    [ style [ ( "color", user.color ) ]
                    ]
                    [ Html.text ("@" ++ user.username) ]
                ]

        Nothing ->
            text ""


viewPage : AppContext -> Model -> Html Msg
viewPage context model =
    case model.postTweetsState of
        Initial ->
            viewComposer context model

        Loading ->
            viewLoading (extractUserColor context.user)

        Success tweetId ->
            viewSuccess (extractUserColor context.user) (extractUserUsername context.user) tweetId

        Failure _ ->
            viewError (extractUserColor context.user)


viewTextBox : String -> String -> (String -> Msg) -> Html Msg
viewTextBox color currentValue onInputMsg =
    div []
        [ textarea
            [ class [ TextInput ]
            , onInput onInputMsg
            , value currentValue
            , placeholder "Compose a long tweet here"
            , style [ ( "border-color", color ) ]
            ]
            []
        ]


viewComposer : AppContext -> Model -> Html Msg
viewComposer context model =
    div []
        [ viewTextBox (extractUserColor context.user) model.text TextChanged
        , viewPostButton (List.length model.parsed) (extractUserColor context.user) model.text
        ]


viewPostButton : Int -> String -> String -> Html Msg
viewPostButton count color currentText =
    let
        buttonText =
            if count == 0 then
                "Type Something"
            else
                "Post " ++ (toString count) ++ " Tweets"
    in
        div [ class [ PostButtonContainer ] ]
            [ button
                [ disabled <| (count == 0)
                , onClick PostButtonClick
                , classList [ ( PostButton, True ), ( PostButtonDisabled, String.isEmpty currentText ) ]
                , style [ ( "background-color", color ) ]
                ]
                [ text buttonText ]
            ]


viewLoading : String -> Html Msg
viewLoading color =
    div [ class [ LoadingContainer ] ]
        [ div [ class [ LoadingIcon ] ]
            [ Icons.loading color ]
        ]


viewSuccess : String -> String -> String -> Html Msg
viewSuccess color username tweetId =
    div [ class [ ContentContainer ] ]
        [ div [ class [ ResultInfo ] ]
            [ div [ class [ ResultIconContainer ] ]
                [ Icons.success
                ]
            , div [ class [ ResultText ] ]
                [ text "Success!" ]
            ]
        , div [ class [ ResultButtonsContainer ] ]
            [ a
                [ href <| "https://twitter.com/" ++ username ++ "/status/" ++ tweetId
                , target "_blank"
                , class [ ResultButton ]
                , style [ ( "background-color", color ) ]
                ]
                [ text "View on Twitter" ]
            , button
                [ onClick ResetButtonClick
                , class [ ResultButton ]
                , style [ ( "background-color", color ) ]
                ]
                [ text "Write Another" ]
            ]
        ]


viewError : String -> Html Msg
viewError color =
    div [ class [ ContentContainer ] ]
        [ div [ class [ ResultInfo ] ]
            [ div [ class [ ResultIconContainer ] ]
                [ Icons.error
                ]
            , div [ class [ ResultText ] ]
                [ text "Error!" ]
            ]
        , div [ class [ ResultButtonsContainer ] ]
            [ button
                [ onClick PostButtonClick
                , class [ ResultButton ]
                , style [ ( "background-color", color ) ]
                ]
                [ text "Try Again" ]
            , button
                [ onClick ResetButtonClick
                , class [ ResultButton ]
                , style [ ( "background-color", color ) ]
                ]
                [ text "Start Over" ]
            ]
        ]


{ class, classList } =
    Html.CssHelpers.withNamespace cssNamespace
