module Views exposing (..)

import Html exposing (Html, text, header, ul, ol, li, h2, h3, p, div, span, a)
import Html.Attributes exposing (class, href)
import ElmEscapeHtml exposing (unescape)
import Types exposing (..)
import Messages exposing (..)
import Utils exposing (getEmojiForValue, getClassNamesForValue)


lastFromListTransformed : (Float -> String) -> List Float -> String
lastFromListTransformed transformer values =
    let
        reversed =
            List.reverse values

        first =
            List.head reversed
    in
        case first of
            Just value ->
                transformer value

            Nothing ->
                ""


lastWithEmoji : List Float -> String
lastWithEmoji =
    lastFromListTransformed getEmojiForValue


classNamesForLast : List Float -> String
classNamesForLast =
    lastFromListTransformed getClassNamesForValue


allButEngagement : Metric -> Bool
allButEngagement metric =
    metric.id /= "Engagement"


onlyEngagement : Metric -> Bool
onlyEngagement metric =
    metric.id == "Engagement"


pickValue : MetricDataPoint -> Float
pickValue metricDataPoint =
    metricDataPoint.value


viewTribe : Model -> String -> Html Msg
viewTribe model tribe =
    div []
        [ header [ class "header" ]
            [ span [] [ text "Tribevibe" ]
            , span [ class "header__tribe" ] [ text tribe ]
            ]
        , div [ class "container" ]
            [ viewError model.error
            , viewDashboard model.dashboard
            ]
        ]


viewDashboard : Maybe Dashboard -> Html Msg
viewDashboard dashboard =
    case dashboard of
        Nothing ->
            p [ class "dashboard__loading" ] [ text "Damn, Officevibe API can be slow..." ]

        Just dashboard ->
            div [ class "dashboard" ]
                [ div [ class "dashboard__top" ]
                    [ div [ class "card card--big card--graph graph__wrapper" ]
                        [ div [ Html.Attributes.id "graph-container" ] [] ]
                    , div [ class "card card--big card--engagement" ] [ viewEngagements dashboard.engagements ]
                    , div [ class "card card--big card--feedback" ]
                        [ viewFeedback (List.head dashboard.feedbacks)
                        , div [ class "feedback__timer" ] []
                        ]
                    ]
                , ul [ class "dashboard__bottom" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


viewMetric : Metric -> Html Msg
viewMetric metric =
    let
        onlyValues =
            List.map pickValue metric.values
    in
        li [ class (classNamesForLast onlyValues) ]
            [ div [ class "card__header" ] [ text metric.name ]
            , div [ class "card__body" ] [ text (lastWithEmoji onlyValues) ]
            ]


viewFeedback : Maybe Feedback -> Html Msg
viewFeedback feedback =
    case feedback of
        Nothing ->
            text ""

        Just feedback ->
            div []
                [ h3 [ class "card__title" ] [ text (unescape feedback.question) ]
                , p [ class "feedback__answer" ] [ text (unescape feedback.answer) ]
                , div [ class "feedback__tags" ] (List.map viewTag feedback.tags)
                , viewReplies feedback.replies
                ]


viewTag : String -> Html Msg
viewTag tag =
    div [ class "feedback__tag" ] [ text tag ]


viewReplies : List Reply -> Html Msg
viewReplies replies =
    if List.length replies == 0 then
        text ""
    else
        div []
            [ ul [ class "feedback__replies" ] (List.map viewReply replies)
            ]


viewReply : Reply -> Html Msg
viewReply reply =
    li [ class "feedback__reply" ] [ text (unescape reply.message) ]


viewEngagements : Engagements -> Html Msg
viewEngagements engagements =
    div []
        [ h3 [ class "card__title" ] [ text "Top Engagement" ]
        , ul [ class "engagements" ] (List.indexedMap viewEngagement (List.reverse (List.sortBy .value engagements)))
        ]


viewEngagement : Int -> Engagement -> Html Msg
viewEngagement index engagement =
    li [ class "engagements-item" ]
        [ div []
            [ span [ class "engagements-item__index" ] [ text ((toString (index + 1)) ++ ".") ]
            , span [] [ a [ class "engagements-item__link", href ("#/" ++ engagement.name) ] [ text engagement.name ] ]
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
