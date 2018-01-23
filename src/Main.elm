module Main exposing (..)

import Http
import Html exposing (Html, text, header, div)
import Html.Attributes exposing (class)
import Types exposing (..)
import Commands exposing (getDashboard)
import Messages exposing (..)
import Views exposing (viewDashboard, viewError)


initialModel : Model
initialModel =
    { dashboard = Nothing
    , error = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, getDashboard )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveDashboard (Ok dashboard) ->
            ( { model | dashboard = Just dashboard }, Cmd.none )

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


view : Model -> Html Msg
view model =
    div []
        [ header [ class "header" ] [ text "Tribevibe" ]
        , div [ class "container" ]
            [ viewError model.error
            , viewDashboard model.dashboard
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
