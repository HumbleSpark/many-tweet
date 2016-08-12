module Screens.Compose.Model
    exposing
        ( Model
        , model
        , updateTextAndParsed
        , reset
        )

import Shared.Api as Api exposing (ApiError)
import Shared.LoadState as LoadState exposing (LoadState(..))
import Shared.TweetRenderer as TweetRenderer


type alias Model =
    { postTweetsState : LoadState ApiError String
    , text : String
    , parsed : List String
    }


model : Model
model =
    { postTweetsState = Initial
    , text = ""
    , parsed = []
    }


updateTextAndParsed : String -> String -> Model -> Model
updateTextAndParsed username value model =
    { model
        | text = value
        , parsed = TweetRenderer.render username value
    }


reset : Model -> Model
reset model =
    { model
        | text = ""
        , parsed = []
        , postTweetsState = Initial
    }
