module Screens.Login.Styles exposing (styles)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Screens.Login.Classes exposing (Classes(..), cssNamespace)


styles : List Snippet
styles =
    namespace cssNamespace
        [ (.) ContentContainer
            [ position relative
            , displayFlex
            , property "align-items" "center"
            , property "justify-content" "center"
            , paddingTop (px 128)
            ]
        , (.) Button
            [ color (hex "#fff")
            , borderRadius (px 56)
            , padding2 (px 16) (px 24)
            , border zero
            , fontSize (px 20)
            , fontFamily inherit
            , textTransform uppercase
            , width (pct 80)
            , backgroundColor (hex "#9C00FF")
            , cursor pointer
            , property "outline" "0"
            ]
        , (.) ButtonDisabled
            [ opacity (float 0.5)
            ]
        ]
