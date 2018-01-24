module Graph exposing (viewGraph)

import Svg.Attributes exposing (..)
import Plot exposing (..)
import Html exposing (Html, text, ul, li, h2, h3, p, div)
import Types exposing (..)
import Messages exposing (..)


horizontalAxis : Axis
horizontalAxis =
    customAxis <|
        \summary ->
            { position = Basics.min
            , axisLine = Just (dataLine summary)
            , ticks = List.map simpleTick [ 0, 90, 180, 270, 360 ]
            , labels = List.map simpleLabel [ 0, 90, 180, 270, 360 ]
            , flipAnchor = False
            }


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
                    | attributes = [ Svg.Attributes.width "100%", Svg.Attributes.height "100%" ]
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
    { axis = normalAxis
    , interpolation = Monotone Nothing [ stroke pinkStroke ]
    , toDataPoints = List.map (\( x, y ) -> clear x y)
    }
