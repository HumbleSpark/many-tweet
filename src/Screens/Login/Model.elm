module Screens.Login.Model
    exposing
        ( Model
        , model
        , LoggingInState(..)
        )


type alias Model =
    { loggingInState : LoggingInState
    }


type LoggingInState
    = NotTried
    | Waiting
    | Success
    | Failure


model : Model
model =
    { loggingInState = NotTried
    }
