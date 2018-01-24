module Views exposing (..)

import Html exposing (Html, text, ul, ol, li, h2, h3, p, div, span)
import Html.Attributes exposing (class)
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Plot exposing (..)
import Types exposing (..)
import Messages exposing (..)
import Utils exposing (getEmojiForValue)


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
                    , div [ Html.Attributes.class "card card--big card--engagement" ] [ viewEngagements dashboard.engagements ]
                    , div [ Html.Attributes.class "card card--big card--feedback" ] [ viewFeedback dashboard.feedback ]
                    ]
                , ul [ Html.Attributes.class "dashboard__bottom" ] (List.map viewMetric (List.filter allButEngagement dashboard.metrics))
                ]


horizontalAxis : Metric -> Axis
horizontalAxis metric =
    normalAxis


axisColor : String
axisColor =
    "#afafaf"


viewGraph : Maybe Metric -> Html Msg
viewGraph metric =
    case metric of
        Nothing ->
            text "Nothing here"

        Just metric ->
            viewSeriesCustom
                { defaultSeriesPlotCustomizations
                    | toDomainLowest = \y -> y - 0.25
                }
                [ customLine ]
                (List.indexedMap
                    (\i x -> ( toFloat i, x ))
                    metric.values
                )


pinkStroke : String
pinkStroke =
    "#BADA55"


verticalAxis : Axis
verticalAxis =
    customAxis <|
        \summary ->
            { position = Basics.min
            , axisLine = Just (dataLine summary)
            , ticks = List.map simpleTick (interval 0 0.5 summary)
            , labels = List.map simpleLabel (interval 0 0.5 summary)
            , flipAnchor = False
            }


dataLine : AxisSummary -> LineCustomizations
dataLine summary =
    { attributes = [ stroke "grey" ]
    , start = summary.dataMin
    , end = summary.dataMax
    }


customLine : Series (List ( Float, Float )) msg
customLine =
    { axis = verticalAxis
    , interpolation = Monotone Nothing [ stroke pinkStroke ]
    , toDataPoints = List.map (\( x, y ) -> clear x y)
    }


viewMetric : Metric -> Html Msg
viewMetric metric =
    li [ Html.Attributes.class "card" ]
        [ div [ Html.Attributes.class "card__header" ] [ text metric.name ]
        , div [ Html.Attributes.class "card__body" ] [ text (lastWithEmoji metric.values) ]
        ]


viewFeedback : Feedback -> Html Msg
viewFeedback feedback =
    div []
        [ h3 [ Html.Attributes.class "card__title" ] [ text feedback.question ]
        , p [ Html.Attributes.class "feedback__answer" ] [ text feedback.answer ]
        , h3 [ Html.Attributes.class "feedback__replies-title" ] [ text "Replies" ]
        , ul [ Html.Attributes.class "feedback__replies" ] (List.map viewReply feedback.replies)
        ]


viewReply : Reply -> Html Msg
viewReply reply =
    li [ Html.Attributes.class "feedback__reply" ] [ text reply.message ]


viewEngagements : Engagements -> Html Msg
viewEngagements engagements =
    div []
        [ h3 [ Html.Attributes.class "card__title" ] [ text "Top Engagement" ]
        , ul [ Html.Attributes.class "engagements" ] (List.indexedMap viewEngagement engagements)
        ]


viewEngagement : Int -> Engagement -> Html Msg
viewEngagement index engagement =
    li [ Html.Attributes.class "engagements-item" ]
        [ div []
            [ span [ Html.Attributes.class "engagements-item__index" ] [ text ((toString (index + 1)) ++ ".") ]
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
