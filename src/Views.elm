module Views exposing (..)

import Html exposing (Html, text, ul, ol, li, h2, h3, p, div, span)
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
            div [ class "dashboard" ]
                [ div [ class "dashboard__top" ]
                    [ div [ class "card card--big card--graph" ] [ viewGraph (List.head (List.filter onlyEngagement dashboard.metrics)) ]
                    , div [ class "card card--big card--engagement" ] [ viewEngagements dashboard.engagements ]
                    , div [ class "card card--big card--feedback" ] [ viewFeedback (List.head dashboard.feedbacks) ]
                    ]
                , ul [ class "dashboard__bottom" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


viewMetric : Metric -> Html Msg
viewMetric metric =
    li [ class "card" ]
        [ div [ class "card__header" ] [ text metric.name ]
        , div [ class "card__body" ] [ text (lastWithEmoji metric.values) ]
        ]


viewFeedback : Maybe Feedback -> Html Msg
viewFeedback feedback =
    case feedback of
        Nothing ->
            text ""

        Just feedback ->
            div []
                [ h3 [ class "card__title" ] [ text feedback.question ]
                , p [ class "feedback__answer" ] [ text feedback.answer ]
                , h3 [ class "feedback__replies-title" ] [ text "Replies" ]
                , ul [ class "feedback__replies" ] (List.map viewReply feedback.replies)
                ]


viewReply : Reply -> Html Msg
viewReply reply =
    li [ class "feedback__reply" ] [ text reply.message ]


viewEngagements : Engagements -> Html Msg
viewEngagements engagements =
    div []
        [ h3 [ class "card__title" ] [ text "Top Engagement" ]
        , ul [ class "engagements" ] (List.indexedMap viewEngagement engagements)
        ]


viewEngagement : Int -> Engagement -> Html Msg
viewEngagement index engagement =
    li [ class "engagements-item" ]
        [ div []
            [ span [ class "engagements-item__index" ] [ text ((toString (index + 1)) ++ ".") ]
            , span [] [ text engagement.name ]
            ]
        , div [] [ text (toString engagement.value) ]
        ]


viewError : Maybe String -> Html Msg
viewError error =
    case error of
        Nothing ->
            text ""

        Just err ->
            p [] [ text err ]
