module Shared.Pages
    exposing
        ( Page(..)
        , url
        , navigateTo
        , redirectTo
        , parser
        )

import String
import Navigation
import UrlParser exposing (..)


type Page
    = LoginPage
    | ComposePage
    | AboutPage
    | NotFoundPage


url : Page -> String
url page =
    "#/"
        ++ case page of
            LoginPage ->
                "login"

            ComposePage ->
                "compose"

            AboutPage ->
                "about"

            NotFoundPage ->
                "not-found"


navigateTo : Page -> Cmd msg
navigateTo page =
    Navigation.newUrl (url page)


redirectTo : Page -> Cmd msg
redirectTo page =
    Navigation.modifyUrl (url page)


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format LoginPage (s "login")
        , format ComposePage (s "compose")
        , format AboutPage (s "about")
        ]


parser : Navigation.Parser Page
parser =
    Navigation.makeParser
        <| .hash
        >> String.dropLeft 2
        >> UrlParser.parse identity pageParser
        >> Result.withDefault NotFoundPage
