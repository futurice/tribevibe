module Views exposing (..)

import Html exposing (Html, text, ul, li, h2, h3, p, div)
import Html.Attributes exposing (class)
import Types exposing (..)
import Messages exposing (..)
import Utils exposing (getEmojiForValue)
import Graph exposing (viewGraph)


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
                (getEmojiForValue value) ++ " " ++ toString value

            Nothing ->
                ""


allButEngagement : Metric -> Bool
allButEngagement metric =
    metric.id /= "Engagement"


onlyEngagement : Metric -> Bool
onlyEngagement metric =
    metric.id == "Engagement"


viewDashboard : Maybe Dashboard -> Html Msg
viewDashboard dashboard =
    case dashboard of
        Nothing ->
            p [] [ text "Loading..." ]

        Just dashboard ->
            div [ Html.Attributes.class "dashboard" ]
                [ div [ Html.Attributes.class "dashboard__top" ]
                    [ div [ Html.Attributes.class "card card--big card--graph" ] [ viewGraph (List.head (List.filter onlyEngagement dashboard.metrics)) ]
                    , div [ Html.Attributes.class "card card--big card--feedback" ] [ viewFeedback dashboard.feedback ]
                    ]
                , ul [ Html.Attributes.class "dashboard__bottom" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


viewMetric : Metric -> Html Msg
viewMetric metric =
    li [ Html.Attributes.class "card" ]
        [ div [ Html.Attributes.class "card__header" ] [ text metric.name ]
        , div [ Html.Attributes.class "card__body" ] [ text (lastWithEmoji metric.values) ]
        ]


viewFeedback : Feedback -> Html Msg
viewFeedback feedback =
    div [ Html.Attributes.class "feedback" ]
        [ h3 [ Html.Attributes.class "feedback__question" ] [ text feedback.question ]
        , p [ Html.Attributes.class "feedback__answer" ] [ text feedback.answer ]
        , h3 [ Html.Attributes.class "feedback__replies-title" ] [ text "Replies" ]
        , ul [ Html.Attributes.class "feedback__replies" ] (List.map viewReply feedback.replies)
        ]


viewReply : Reply -> Html Msg
viewReply reply =
    li [ Html.Attributes.class "feedback__reply" ] [ text reply.message ]


viewError : Maybe String -> Html Msg
viewError error =
    case error of
        Nothing ->
            text ""

        Just err ->
            p [] [ text err ]
