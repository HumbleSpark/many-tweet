module Application.Update exposing (Msg(..), Flags, init, subscriptions, update, urlUpdate)

import Application.Messaging as Messaging exposing (User)
import Application.Model as Model exposing (Model)
import Shared.Pages as Pages exposing (Page)
import Shared.Routing as Routing


type Msg
    = PageMsg Page Routing.PageMsg


type alias Flags =
    { user : Maybe User
    }


init : Flags -> Page -> ( Model, Cmd Msg )
init flags page =
    let
        initialModel =
            Model.model flags.user page
    in
        urlUpdate page initialModel


subscriptions : Model -> Sub Msg
subscriptions model =
    Routing.subscriptions model.appContext model.pageModel
        |> Sub.map (PageMsg model.currentPage)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PageMsg intendedPage pageMsg ->
            if intendedPage /= model.currentPage then
                ( model, Cmd.none )
            else
                let
                    ( nextPageModel, nextPageCmd, nextAppMsg ) =
                        Routing.update model.appContext pageMsg model.pageModel
                in
                    ( { model
                        | pageModel = nextPageModel
                        , appContext = Messaging.contextUpdate nextAppMsg model.appContext
                      }
                    , Cmd.map (PageMsg model.currentPage) nextPageCmd
                    )


urlUpdate : Page -> Model -> ( Model, Cmd Msg )
urlUpdate page model =
    let
        redirectPage =
            Routing.redirects model.appContext page
    in
        if redirectPage /= page then
            ( model, Pages.redirectTo redirectPage )
        else
            let
                nextPageModel =
                    Routing.model page

                nextPageCmd =
                    Routing.initialize model.appContext page
            in
                ( { model | pageModel = nextPageModel, currentPage = page }
                , Cmd.map (PageMsg page) nextPageCmd
                )
