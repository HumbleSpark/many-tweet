module Shared.TweetRenderer exposing (render)

{-| This file is scary. Don't look at it.
-}

import String
import Regex exposing (Regex)


urlRegex : Regex
urlRegex =
    Regex.regex "^(?:(?:https?|ftp)://)?(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))(\\.?)(?:[/?#]\\S*)?$"


usernameRegex : Regex
usernameRegex =
    Regex.regex "^@(\\w){1,15}$"


type Token
    = Url String
    | UserName String
    | Ordinary String
    | HyphenOpen String
    | HyphenClose String


hyphenateToken : Int -> Token -> List Token
hyphenateToken splitPoint token =
    case token of
        Url value ->
            [ Url value ]

        UserName value ->
            [ UserName value ]

        Ordinary value ->
            [ HyphenOpen <| String.left splitPoint value
            , HyphenClose <| String.right ((String.length value) - splitPoint) value
            ]

        HyphenOpen value ->
            [ HyphenOpen <| String.left splitPoint value
            , HyphenOpen <| String.right ((String.length value) - splitPoint) value
            ]

        HyphenClose value ->
            [ HyphenClose <| String.left splitPoint value
            , HyphenClose <| String.right ((String.length value) - splitPoint) value
            ]


parseToken : String -> Token
parseToken value =
    if Regex.contains urlRegex value then
        Url value
    else if Regex.contains usernameRegex value then
        UserName value
    else
        Ordinary value


tokenLength : Token -> Int
tokenLength token =
    case token of
        Url value ->
            23

        UserName value ->
            String.length value

        Ordinary value ->
            String.length value

        HyphenOpen value ->
            String.length value

        HyphenClose value ->
            String.length value


renderTokenList : List Token -> String
renderTokenList tokens =
    let
        fold nextToken { index, output, previousToken } =
            { index = index + 1
            , previousToken = nextToken
            , output =
                if index == 0 then
                    case nextToken of
                        Url value ->
                            value

                        UserName value ->
                            value

                        Ordinary value ->
                            value

                        HyphenOpen value ->
                            value

                        HyphenClose value ->
                            value
                else
                    output
                        ++ case nextToken of
                            Url value ->
                                " " ++ value

                            UserName value ->
                                " " ++ value

                            Ordinary value ->
                                " " ++ value

                            HyphenOpen value ->
                                case previousToken of
                                    HyphenOpen _ ->
                                        value

                                    _ ->
                                        " " ++ value

                            HyphenClose value ->
                                case previousToken of
                                    HyphenOpen _ ->
                                        value

                                    HyphenClose _ ->
                                        value

                                    _ ->
                                        " " ++ value
            }
    in
        tokens
            |> List.foldl fold { index = 0, output = "", previousToken = Ordinary "" }
            |> .output


tokenListLength : List Token -> Int
tokenListLength tokens =
    let
        fold nextToken { index, sum, previousToken } =
            { index = index + 1
            , previousToken = nextToken
            , sum =
                if index == 0 then
                    tokenLength nextToken
                else
                    sum
                        + case nextToken of
                            Url _ ->
                                1 + tokenLength nextToken

                            UserName _ ->
                                1 + tokenLength nextToken

                            Ordinary _ ->
                                1 + tokenLength nextToken

                            HyphenOpen _ ->
                                case previousToken of
                                    HyphenOpen _ ->
                                        tokenLength nextToken

                                    _ ->
                                        1 + tokenLength nextToken

                            HyphenClose value ->
                                case previousToken of
                                    HyphenOpen _ ->
                                        tokenLength nextToken

                                    HyphenClose _ ->
                                        tokenLength nextToken

                                    _ ->
                                        1 + tokenLength nextToken
            }
    in
        tokens
            |> List.foldl fold { index = 0, sum = 0, previousToken = Ordinary "" }
            |> .sum


parseText : String -> List Token
parseText text =
    text
        |> String.words
        |> List.map parseToken


type alias Intermediate =
    { username : String
    , content : List Token
    , paging : String
    }


intermediateLength : Intermediate -> Int
intermediateLength i =
    case ( String.isEmpty i.username, String.isEmpty i.paging ) of
        ( True, True ) ->
            tokenListLength i.content

        ( False, True ) ->
            (String.length i.username) + 1 + (tokenListLength i.content)

        ( True, False ) ->
            (String.length i.paging) + 1 + (tokenListLength i.content)

        ( False, False ) ->
            (String.length i.paging) + (String.length i.username) + (tokenListLength i.content) + 2


intermediateRemaining : Intermediate -> Int
intermediateRemaining i =
    140 - (intermediateLength i) + (tokenListLength i.content)


hyphenate : Int -> List Token -> List Token
hyphenate maxLength tokens =
    let
        fold nextToken outTokens =
            if tokenLength nextToken > maxLength then
                (List.reverse (hyphenateToken maxLength nextToken)) ++ outTokens
            else
                nextToken :: outTokens
    in
        tokens
            |> List.foldl fold []
            |> List.reverse


naiveGroup : List Token -> List Intermediate
naiveGroup tokens =
    let
        fold nextToken state =
            let
                newContent =
                    state.currentContent ++ [ nextToken ]
            in
                if tokenListLength newContent > 140 then
                    { state
                        | groups = state.currentContent :: state.groups
                        , currentContent = [ nextToken ]
                    }
                else
                    { state
                        | currentContent = newContent
                    }

        folded =
            tokens
                |> hyphenate 140
                |> List.foldl fold { groups = [], currentContent = [] }

        contentLists =
            folded.currentContent :: folded.groups
    in
        contentLists
            |> List.reverse
            |> List.map (\c -> { username = "", paging = "", content = c })


injectUsername : String -> List Intermediate -> List Intermediate
injectUsername username is =
    let
        inject index i =
            if index == 0 then
                i
            else
                { i | username = username }
    in
        List.indexedMap inject is


createPaging : Int -> Int -> String
createPaging page total =
    "(" ++ (toString (page + 1)) ++ "/" ++ (toString total) ++ ")"


injectPaging : List Intermediate -> List Intermediate
injectPaging is =
    let
        length =
            List.length is

        inject index i =
            { i | paging = createPaging index length }
    in
        List.indexedMap inject is


splitTokensAt : Int -> List Token -> ( List Token, List Token )
splitTokensAt max tokens =
    let
        fold token state =
            let
                newKept =
                    state.kept ++ [ token ]
            in
                if state.overflow || (tokenListLength newKept > max) then
                    { state
                        | overflow = True
                        , overflowedTokens = token :: state.overflowedTokens
                    }
                else
                    { state | kept = newKept }
    in
        tokens
            |> List.foldl fold { overflow = False, kept = [], overflowedTokens = [] }
            |> (\{ kept, overflowedTokens } -> ( kept, List.reverse overflowedTokens ))


hyphenateIntermediate : Intermediate -> Intermediate
hyphenateIntermediate i =
    let
        remaining =
            intermediateRemaining i
    in
        { i | content = hyphenate remaining i.content }


reflow : List Intermediate -> ( List Intermediate, List Token )
reflow is =
    let
        fold i state =
            let
                remaining =
                    intermediateRemaining i

                pushed =
                    { i | content = state.overflow ++ i.content }
            in
                if tokenListLength pushed.content > remaining then
                    let
                        ( kept, overflowed ) =
                            splitTokensAt remaining pushed.content
                    in
                        { intermediates = ({ pushed | content = kept }) :: state.intermediates
                        , overflow = overflowed
                        }
                else
                    { intermediates = pushed :: state.intermediates
                    , overflow = []
                    }
    in
        is
            |> List.foldl fold { overflow = [], intermediates = [] }
            |> (\{ overflow, intermediates } -> ( List.reverse intermediates, overflow ))


run : String -> List Intermediate -> List Intermediate
run username is =
    let
        ( processed, overflow ) =
            is
                |> injectUsername username
                |> injectPaging
                |> List.map hyphenateIntermediate
                |> reflow
    in
        if List.isEmpty overflow then
            processed
        else
            run username (processed ++ (naiveGroup overflow))


renderIntermediate : Intermediate -> String
renderIntermediate i =
    [ i.username, renderTokenList i.content, i.paging ]
        |> List.filter (String.isEmpty >> not)
        |> String.join " "


render : String -> String -> List String
render username text =
    if String.isEmpty text then
        []
    else
        text
            |> parseText
            |> naiveGroup
            |> run ("@" ++ username)
            |> List.map renderIntermediate
