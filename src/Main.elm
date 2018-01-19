module Main exposing (..)

import Html exposing (Html, text, div, h1, p)
import Http
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (int, string, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)


---- MODEL ----


type alias MetricValue =
    { id : String
    , displayName : String
    , value : Int
    }


type alias WeeklyReport =
    { groupName : String
    , date : String
    , metricsValues : List MetricValue
    }


type alias WeeklyReports =
    { weeklyReports : List WeeklyReport
    }


type alias Model =
    { weeklyReports : WeeklyReports
    }


initialModel =
    { weeklyReports = { weeklyReports = [] }
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, getWeeklyReports )



---- UPDATE ----


type Msg
    = ReceiveWeeklyReports (Result Http.Error WeeklyReports)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveWeeklyReports (Ok weeklyReports) ->
            ( { model | weeklyReports = weeklyReports }, Cmd.none )

        ReceiveWeeklyReports (Err _) ->
            ( model, Cmd.none )


getWeeklyReports : Cmd Msg
getWeeklyReports =
    let
        url =
            "https://app.officevibe.com/api/v2/engagement"

        body =
            Http.jsonBody <|
                Encode.object
                    [ ( "groupNames", Encode.string "Tammerforce" )
                    , ( "dates", Encode.list (List.map Encode.string [ "2017-12-01", "2018-01-01" ]) )
                    ]

        headers =
            [ Http.header "Authorization" "Bearer TOKEN" ]

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = url
                , body = body
                , expect = Http.expectJson decodeWeeklyReports
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ReceiveWeeklyReports request


decodeWeeklyReports : Decoder WeeklyReports
decodeWeeklyReports =
    decode
        WeeklyReports
        |> requiredAt [ "data", "weeklyReports" ] (Decode.list decodeWeeklyReport)


decodeWeeklyReport : Decoder WeeklyReport
decodeWeeklyReport =
    decode
        WeeklyReport
        |> required "groupName" Decode.string
        |> required "date" Decode.string
        |> required "metricsValues" (Decode.list decodeMetricsValue)


decodeMetricsValue : Decoder MetricValue
decodeMetricsValue =
    decode
        MetricValue
        |> required "id" Decode.string
        |> required "displayName" Decode.string
        |> required "value" Decode.int



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Tribevibe" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
