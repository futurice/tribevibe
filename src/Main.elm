module Main exposing (..)

import Http
import Html exposing (Html, text, div)
import Navigation exposing (Location)
import Routes exposing (parseLocation)
import Time exposing (Time, second)
import Types exposing (..)
import Commands exposing (getDashboard)
import Messages exposing (..)
import Views exposing (viewTribe, viewError)
import Ports exposing (drawGraph)


initialModel : Route -> Model
initialModel route =
    { dashboard = Nothing
    , error = Nothing
    , route = route
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location

        tribeParam =
            case currentRoute of
                TribeDashboard tribe ->
                    tribe

                _ ->
                    ""
    in
        ( initialModel currentRoute, getDashboard tribeParam )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveDashboard (Ok dashboard) ->
            case dashboard.feedbacks of
                [] ->
                    ( { model | dashboard = Just dashboard }, Cmd.none )

                feedbacks ->
                    let
                        dash =
                            { dashboard | feedbacks = feedbacks }
                    in
                        ( { model | dashboard = Just dash }, drawGraph dashboard.engagement )

        ReceiveDashboard (Err error) ->
            case error of
                Http.BadUrl error ->
                    ( { model | error = Just error }, Cmd.none )

                Http.Timeout ->
                    ( { model | error = Just "HTTP Timeout" }, Cmd.none )

                Http.NetworkError ->
                    ( { model | error = Just "Network Error" }, Cmd.none )

                Http.BadStatus _ ->
                    ( { model | error = Just "Bad Status" }, Cmd.none )

                Http.BadPayload error _ ->
                    ( { model | error = Just error }, Cmd.none )

        -- Show next feedback
        Tick newTime ->
            case model.dashboard of
                Just dashboard ->
                    case dashboard.feedbacks of
                        [] ->
                            ( { model | dashboard = Just dashboard }, Cmd.none )

                        head :: rest ->
                            -- Get the first feedback and move it to the end of the feedbacks list
                            let
                                dash =
                                    { dashboard | feedbacks = (List.append rest [ head ]) }
                            in
                                ( { model | dashboard = Just dash }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        LocationChange location ->
            let
                newRoute =
                    parseLocation location

                tribeParam =
                    case newRoute of
                        TribeDashboard tribe ->
                            tribe

                        _ ->
                            ""
            in
                ( { model | route = newRoute }, getDashboard tribeParam )


view : Model -> Html Msg
view model =
    case model.route of
        FutuDashboard ->
            viewTribe model ""

        TribeDashboard tribe ->
            viewTribe model tribe

        NotFound ->
            viewTribe model ""


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * second) Tick


main : Program Never Model Msg
main =
    Navigation.program LocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
