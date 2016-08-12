module Screens.About.Styles exposing (styles)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Screens.About.Classes exposing (Classes(..), cssNamespace)


styles : List Snippet
styles =
    namespace cssNamespace
        [ (.) ContentContainer
            [ position relative
            , padding (px 32)
            ]
        , (.) AboutText
            [ lineHeight (em 1.6)
            ]
        ]
