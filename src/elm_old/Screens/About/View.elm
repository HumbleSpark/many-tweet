module Screens.About.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers
import Screens.About.Classes exposing (..)


view : Html msg
view =
    div [ class [ ContentContainer ] ]
        [ h2 [] [ text "About ManyTweet" ]
        , p [ class [ AboutText ] ]
            [ span [] [ text "ManyTweet was produced by " ]
            , a
                [ href "https://twitter.com/luke_dot_js"
                , target "_blank"
                ]
                [ text "Luke Westby" ]
            , span [] [ text " at " ]
            , a
                [ href "https://humblespark.com"
                , target "_blank"
                ]
                [ text "HumbleSpark" ]
            , span [] [ text " for the benefit of the Twitter community. It is entirely open source and all source code can be found " ]
            , a
                [ href "https://github.com/humblespark/many-tweet"
                , target "_blank"
                ]
                [ text "here." ]
            ]
        , h2 [] [ text "Found a Bug?" ]
        , p [ class [ AboutText ] ]
            [ a
                [ href "https://github.com/humblespark/many-tweet/issues/new"
                , target "_blank"
                ]
                [ text "Report it here!" ]
            ]
        ]


{ class, classList } =
    Html.CssHelpers.withNamespace cssNamespace
