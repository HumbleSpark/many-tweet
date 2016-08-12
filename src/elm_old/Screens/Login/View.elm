module Screens.Login.View exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers
import Application.Messaging exposing (AppContext)
import Screens.Login.Model as Model exposing (Model, LoggingInState(..))
import Screens.Login.Update exposing (Msg(..))
import Screens.Login.Classes exposing (..)


view : AppContext -> Model -> Html Msg
view appContext model =
    div [ class [ ContentContainer ] ]
        [ button
            [ disabled <| not <| canLogIn model.loggingInState
            , onClick LoginStart
            , classList
                [ ( Button, True )
                , ( ButtonDisabled, not <| canLogIn model.loggingInState )
                ]
            ]
            [ text <| buttonText model.loggingInState
            ]
        ]


canLogIn : LoggingInState -> Bool
canLogIn state =
    case state of
        NotTried ->
            True

        Failure ->
            True

        _ ->
            False


buttonText : LoggingInState -> String
buttonText state =
    case state of
        NotTried ->
            "Log in to Twitter"

        Waiting ->
            "Logging in ..."

        Success ->
            "Logged in!"

        Failure ->
            "Login failed. Try again?"


{ class, classList } =
    Html.CssHelpers.withNamespace cssNamespace
