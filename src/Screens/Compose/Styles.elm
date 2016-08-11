module Screens.Compose.Styles exposing (styles)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Screens.Compose.Classes exposing (Classes(..), cssNamespace)


styles : List Snippet
styles =
    namespace cssNamespace
        [ (.) UserBanner
            [ padding2 (px 16) (px 16)
            , displayFlex
            , property "align-items" "center"
            , property "justify-content" "center"
            , fontSize (px 20)
            , lineHeight (px 20)
            ]
        , (.) UserImageContainer
            [ paddingRight (px 16)
            , height (px 48)
            ]
        , (.) UserImage
            [ borderRadius (pct 50)
            , border2 (px 1) solid
            , height (px 48)
            , width (px 48)
            , backgroundColor (hex "#F6F6F6")
            ]
        , (.) TextInput
            [ width (pct 100)
            , border zero
            , borderTop2 (px 1) solid
            , borderBottom2 (px 1) solid
            , height (vh 50)
            , property "resize" "none"
            , backgroundColor (hex "#F6F6F6")
            , padding (px 16)
            , fontSize (px 18)
            , color (hex "#272727")
            , property "outline" "0"
            , property "-webkit-appearance" "none"
            , borderRadius zero
            , fontFamily inherit
            ]
        , (.) PostButtonContainer
            [ padding2 (px 24) (px 16)
            , displayFlex
            , property "justify-content" "center"
            , property "align-items" "center"
            ]
        , (.) PostButton
            [ color (hex "#fff")
            , borderRadius (px 56)
            , padding2 (px 16) (px 24)
            , border zero
            , fontSize (px 20)
            , fontFamily inherit
            , textTransform uppercase
            , width (pct 80)
            , cursor pointer
            , property "outline" "0"
            , hover
                [ property "box-shadow" "0px 0px 6px 0px rgba(0,0,0,0.5)"
                ]
            ]
        , (.) PostButtonDisabled
            [ color (hex "#272727")
            , border3 (px 1) solid (hex "#272727")
            , important <| backgroundColor (hex "#F6F6F6")
            , hover [ property "box-shadow" "none" ]
            ]
        , (.) ContentContainer
            [ displayFlex
            , property "flex-direction" "column"
            , property "align-items" "center"
            ]
        , (.) ResultIconContainer
            [ width (px 120)
            , height (px 120)
            ]
        , (.) ResultInfo
            [ padding2 (px 40) zero
            ]
        , (.) ResultText
            [ textAlign center
            , textTransform uppercase
            , fontSize (px 20)
            , paddingTop (px 16)
            ]
        , (.) ResultButtonsContainer
            [ width (pct 100)
            , displayFlex
            , property "flex-direction" "column"
            , property "align-items" "center"
            ]
        , (.) ResultButton
            [ color (hex "#fff")
            , borderRadius (px 56)
            , padding2 (px 16) (px 24)
            , border zero
            , fontSize (px 20)
            , fontFamily inherit
            , textTransform uppercase
            , width (pct 80)
            , display block
            , margin2 (px 16) zero
            , textDecoration none
            , textAlign center
            , cursor pointer
            , property "outline" "0"
            ]
        , (.) LoadingContainer
            [ padding2 (px 64) zero
            , displayFlex
            , property "flex-direction" "column"
            , property "align-items" "center"
            ]
        , (.) LoadingIcon
            [ width (px 160)
            , height (px 160)
            ]
        ]
