module Views exposing (..)

import Html exposing (Html, text, ul, li, p, div)
import Html.Attributes exposing (class)
import Types exposing (..)
import Messages exposing (..)


lastWithEmoji : List Float -> String
lastWithEmoji values =
    let
        reversed =
            List.reverse values

        first =
            List.head reversed
    in
        case first of
            Just value ->
                "😄 " ++ toString value

            Nothing ->
                ""


allButEngagement : Metric -> Bool
allButEngagement metric =
    metric.id /= "Engagement"


viewDashboard : Maybe Dashboard -> Html Msg
viewDashboard dashboard =
    case dashboard of
        Nothing ->
            p [] [ text "Loading..." ]

        Just dashboard ->
            div [ class "dashboard" ]
                [ div [ class "dashboard__top" ]
                    [ div [ class "plot card card--big" ] [ text "Here lives the graph!" ]
                    , div [ class "feedback card card--big" ] [ text "Here lives the feedback!" ]
                    ]
                , ul [ class "dashboard__bottom metrics" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


viewMetric : Metric -> Html Msg
viewMetric metric =
    li [ class "card" ]
        [ div [ class "card__header" ] [ text metric.name ]
        , div [ class "card__body" ] [ text (lastWithEmoji metric.values) ]
        ]


viewError : Maybe String -> Html Msg
viewError error =
    case error of
        Nothing ->
            text ""

        Just err ->
            p [] [ text err ]
