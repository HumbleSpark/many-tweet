module Application.View exposing (view)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.CssHelpers
import Application.Messaging exposing (User)
import Application.Model as Model exposing (Model)
import Application.Update exposing (Msg(..))
import Application.Classes exposing (..)
import Shared.Pages as Pages exposing (Page(..))
import Shared.Routing as Routing
import Shared.Icons as Icons


view : Model -> Html Msg
view model =
    div [ class [ AppContainer ] ]
        [ viewHeader (extractUserColor model.appContext.user)
        , viewScreen model
        ]


extractUserColor : Maybe User -> String
extractUserColor user =
    user
        |> Maybe.map .color
        |> Maybe.withDefault "#9C00FF"


viewHeader : String -> Html Msg
viewHeader color =
    header
        [ class [ Header ]
        , style [ ( "background-color", color ) ]
        ]
        [ a
            [ class [ Logo ]
            , href <| Pages.url ComposePage
            ]
            [ viewLogoIcon color
            , span [ class [ LogoText ] ]
                [ text "ManyTweet" ]
            ]
        , div [ class [ AboutLink ] ]
            [ a [ href <| Pages.url AboutPage ] [ Icons.questionMark ]
            ]
        ]


viewLogoIcon : String -> Html Msg
viewLogoIcon color =
    span [ class [ LogoIcon ] ]
        [ Icons.logo color
        ]


viewScreen : Model -> Html Msg
viewScreen model =
    main' [ class [ PageContainer ] ]
        [ Html.map (PageMsg model.currentPage) <| Routing.view model.appContext model.pageModel
        ]


{ class } =
    Html.CssHelpers.withNamespace cssNamespace
