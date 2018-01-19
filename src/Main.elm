module Main exposing (..)

import Html exposing (Html, text, div, h1, p)
import Types exposing (..)
import Commands exposing (getWeeklyReports)
import Messages exposing (..)


initialModel =
    { weeklyReports = { weeklyReports = [] }
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, getWeeklyReports )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveWeeklyReports (Ok weeklyReports) ->
            ( { model | weeklyReports = weeklyReports }, Cmd.none )

        ReceiveWeeklyReports (Err _) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Tribevibe" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
