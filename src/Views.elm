module Views exposing (..)

import Html exposing (Html, text, ul, li, p)
import Types exposing (WeeklyReport, MetricsValue, interestingMetrics)
import Messages exposing (..)


metricValues : List WeeklyReport -> Html Msg
metricValues reports =
    ul [] (List.map viewReport reports)


viewReport : WeeklyReport -> Html Msg
viewReport report =
    li []
        [ p [] [ text report.groupName ]
        , p [] [ text report.date ]
        , ul [] (List.map viewMetricsValue report.metricsValues)
        ]


viewMetricsValue : MetricsValue -> Html Msg
viewMetricsValue metricsValue =
    li []
        [ text ((metricsValue.displayName ++ ": ") ++ toString metricsValue.value)
        ]
