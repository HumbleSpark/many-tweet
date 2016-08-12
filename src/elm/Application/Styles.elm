module Application.Styles exposing (styles)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Application.Classes exposing (Classes(..), cssNamespace)


styles : List Snippet
styles =
    namespace cssNamespace
        [ everything
            [ boxSizing borderBox
            ]
        , html
            [ margin zero
            , height (pct 100)
            ]
        , body
            [ margin zero
            , property "font-family" "Source Sans Pro"
            , height (pct 100)
            ]
        , (.) Header
            [ height (px 56)
            , displayFlex
            , property "align-items" "center"
            , property "justify-content" "space-between"
            , backgroundColor (hex "#BD56FF")
            , property "box-shadow" "0px 0px 6px 0px rgba(0,0,0,0.5)"
            , property "transition" "background-color 1.5s"
            , position fixed
            , left zero
            , right zero
            , top zero
            , property "z-index" "2"
            , padding2 (px 0) (px 16)
            ]
        , (.) AppContainer
            [ height (pct 100)
            ]
        , (.) LogoIcon
            [ width (px 64)
            , height (px 56)
            , position relative
            , property "transition" "stroke 1.5s"
            ]
        , (.) LogoText
            [ color (hex "#fff")
            , fontSize (px 20)
            , paddingLeft (px 8)
            ]
        , (.) Logo
            [ displayFlex
            , property "align-items" "center"
            , property "justify-content" "center"
            , textDecoration none
            ]
        , (.) AboutLink
            [ width (px 24)
            , height (px 24)
            ]
        , (.) PageContainer
            [ margin2 zero auto
            , maxWidth (px 768)
            , paddingTop (px 56)
            , property "min-height" "calc(100% - 56px)"
            , position relative
            ]
        ]
