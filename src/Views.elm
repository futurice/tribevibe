module Views exposing (..)

import Html exposing (Html, text, ul, li, h2, h3, p, div)
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
                    [ div [ class "card card--big card--graph" ] [ text "Here lives the graph!" ]
                    , div [ class "card card--big card--feedback" ] [ viewFeedback dashboard.feedback ]
                    ]
                , ul [ class "dashboard__bottom" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


viewMetric : Metric -> Html Msg
viewMetric metric =
    li [ class "card" ]
        [ div [ class "card__header" ] [ text metric.name ]
        , div [ class "card__body" ] [ text (lastWithEmoji metric.values) ]
        ]


viewFeedback : Feedback -> Html Msg
viewFeedback feedback =
    div [ class "feedback" ]
        [ h3 [ class "feedback__question" ] [ text feedback.question ]
        , p [ class "feedback__answer" ] [ text feedback.answer ]
        , h3 [ class "feedback__replies-title" ] [ text "Replies" ]
        , ul [ class "feedback__replies" ] (List.map viewReply feedback.replies)
        ]


viewReply : Reply -> Html Msg
viewReply reply =
    li [ class "feedback__reply" ] [ text reply.message ]


viewError : Maybe String -> Html Msg
viewError error =
    case error of
        Nothing ->
            text ""

        Just err ->
            p [] [ text err ]
