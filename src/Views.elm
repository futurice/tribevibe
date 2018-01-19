module Views exposing (..)

import Html exposing (Html, text, ul, li, p, div)
import Html.Attributes exposing (class)
import Types exposing (WeeklyReport, MetricsValue, interestingMetrics)
import Messages exposing (..)


isInteresting : MetricsValue -> Bool
isInteresting value =
    List.member value.id interestingMetrics


withEmoji : Float -> String
withEmoji value =
    "😄 " ++ toString value


metricValues : List WeeklyReport -> Html Msg
metricValues reports =
    ul [ class "weekly-reports" ] (List.map viewReport reports)


viewReport : WeeklyReport -> Html Msg
viewReport report =
    li [ class "weekly-report" ]
        [ p [] [ text report.groupName ]
        , p [] [ text report.date ]
        , ul [ class "cards" ] (List.map viewMetricsValue (List.filter isInteresting report.metricsValues))
        ]


viewMetricsValue : MetricsValue -> Html Msg
viewMetricsValue metricsValue =
    li [ class "card" ]
        [ div [ class "card__header" ] [ text metricsValue.displayName ]
        , div [ class "card__body" ] [ text (withEmoji metricsValue.value) ]
        ]
