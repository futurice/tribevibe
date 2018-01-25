module Main exposing (..)

import Http
import Html exposing (Html, text, header, div)
import Html.Attributes exposing (class)
import Time exposing (Time, second)
import Types exposing (..)
import Commands exposing (getDashboard)
import Messages exposing (..)
import Views exposing (viewDashboard, viewError)


initialModel : Model
initialModel =
    { dashboard = Nothing
    , error = Nothing
    , secondsPassed = 0
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, getDashboard )


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
                        ( { model | dashboard = Just dash }, Cmd.none )

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
            if model.secondsPassed == 5 then
                case model.dashboard of
                    Just dashboard ->
                        case dashboard.feedbacks of
                            [] ->
                                ( { model | dashboard = Just dashboard }, Cmd.none )

                            feedbackItems ->
                                -- Get the first feedback and move it to the end of the feedbacks list
                                let
                                    headFeedback =
                                        List.head feedbackItems

                                    feedbacks =
                                        case headFeedback of
                                            Just feedback ->
                                                case (List.tail feedbackItems) of
                                                    Just feedbackItems ->
                                                        List.append feedbackItems [ feedback ]

                                                    Nothing ->
                                                        feedbackItems

                                            Nothing ->
                                                feedbackItems

                                    dash =
                                        { dashboard | feedbacks = feedbacks }
                                in
                                    ( { model | dashboard = Just dash, secondsPassed = 0 }, Cmd.none )

                    Nothing ->
                        ( model, Cmd.none )
            else
                ( { model | secondsPassed = model.secondsPassed + 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ header [ class "header" ] [ text "Tribevibe" ]
        , div [ class "container" ]
            [ viewError model.error
            , viewDashboard model.dashboard
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
