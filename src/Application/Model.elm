module Application.Model
    exposing
        ( Model
        , model
        )

import Shared.Pages as Pages exposing (Page)
import Shared.Routing as Routing
import Application.Messaging as Messaging exposing (AppContext, User)


type alias Model =
    { pageModel : Routing.PageModel
    , currentPage : Page
    , appContext : AppContext
    }


model : Maybe User -> Page -> Model
model user page =
    { pageModel = Routing.model page
    , currentPage = page
    , appContext = Messaging.appContext user
    }
