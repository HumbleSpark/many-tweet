module Shared.Routing
    exposing
        ( PageModel
        , PageMsg
        , update
        , initialize
        , model
        , view
        , subscriptions
        , redirects
        )

import Html exposing (Html)
import Html.App as Html
import Shared.Pages as Pages exposing (Page(..))
import Application.Messaging as Messaging exposing (AppContext, AppMsg(..))
import Screens.Login.Model as Login
import Screens.Login.Update as Login
import Screens.Login.View as Login
import Screens.Compose.Model as Compose
import Screens.Compose.Update as Compose
import Screens.Compose.View as Compose
import Screens.About.View as About


type PageModel
    = LoginModel Login.Model
    | ComposeModel Compose.Model
    | AboutModel
    | NoneModel


type PageMsg
    = LoginMsg Login.Msg
    | ComposeMsg Compose.Msg
    | NoneMsg


redirects : AppContext -> Page -> Page
redirects appContext page =
    case page of
        NotFoundPage ->
            LoginPage

        AboutPage ->
            page

        _ ->
            case appContext.user of
                Nothing ->
                    LoginPage

                _ ->
                    ComposePage


update : AppContext -> PageMsg -> PageModel -> ( PageModel, Cmd PageMsg, AppMsg )
update appContext pageMsg pageModel =
    case ( pageMsg, pageModel ) of
        ( LoginMsg msg, LoginModel model ) ->
            let
                ( nextModel, nextCmd, nextAppMsg ) =
                    Login.update appContext msg model
            in
                ( LoginModel nextModel
                , Cmd.map LoginMsg nextCmd
                , nextAppMsg
                )

        ( ComposeMsg msg, ComposeModel model ) ->
            let
                ( nextModel, nextCmd, nextAppMsg ) =
                    Compose.update appContext msg model
            in
                ( ComposeModel nextModel
                , Cmd.map ComposeMsg nextCmd
                , nextAppMsg
                )

        ( _, _ ) ->
            ( pageModel, Cmd.none, NoneAppMsg )


initialize : AppContext -> Page -> Cmd PageMsg
initialize context page =
    case page of
        LoginPage ->
            Login.initialize context
                |> Cmd.map LoginMsg

        ComposePage ->
            Compose.initialize context
                |> Cmd.map ComposeMsg

        _ ->
            Cmd.none


model : Page -> PageModel
model page =
    case page of
        LoginPage ->
            LoginModel Login.model

        ComposePage ->
            ComposeModel Compose.model

        AboutPage ->
            AboutModel

        _ ->
            NoneModel


view : AppContext -> PageModel -> Html PageMsg
view context pageModel =
    case pageModel of
        LoginModel model ->
            Html.map LoginMsg <| Login.view context model

        ComposeModel model ->
            Html.map ComposeMsg <| Compose.view context model

        AboutModel ->
            About.view

        _ ->
            Html.text ""


subscriptions : AppContext -> PageModel -> Sub PageMsg
subscriptions context pageModel =
    case pageModel of
        LoginModel model ->
            Login.subscriptions context model
                |> Sub.map LoginMsg

        _ ->
            Sub.none
