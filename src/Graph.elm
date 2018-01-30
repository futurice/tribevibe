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
            , axisLine = Nothing
            , ticks = List.map simpleTick [ 0, 1, 2 ]
            , labels = List.map simpleLabel [ 0, 1, 2 ]
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
                    | attributes = [ width "100%" ]
                    , height = 450
                    , width = 720
                    , horizontalAxis = horizontalAxis
                    , toDomainLowest = \y -> Basics.max 0 (y - 1)
                    , toDomainHighest = \y -> Basics.min 10 (toFloat (Basics.ceiling (y + 1)))
                    , grid =
                        { horizontal = decentGrid
                        , vertical = decentGrid
                        }
                }
                [ customLine ]
                (List.indexedMap
                    (\i x -> ( toFloat i, x ))
                    metric.values
                )


lineColor : String
lineColor =
    "#BADA55"


verticalAxis : Axis
verticalAxis =
    customAxis <|
        \summary ->
            { position = Basics.min
            , axisLine = Just (simpleLine summary)
            , ticks = List.map simpleTick (decentPositions summary |> remove 0)
            , labels = List.map simpleLabel (decentPositions summary |> remove 0)
            , flipAnchor = False
            }


dataLine : AxisSummary -> LineCustomizations
dataLine summary =
    { attributes = [ stroke "grey", strokeWidth "0" ]
    , start = summary.min
    , end = summary.max
    }


pointColor : String
pointColor =
    "#00AAAA"


blueCircle : ( Float, Float ) -> DataPoint msg
blueCircle ( x, y ) =
    dot (viewCircle 5 pointColor) x y


customLine : Series (List ( Float, Float )) msg
customLine =
    { axis = verticalAxis
    , interpolation = Monotone Nothing [ stroke lineColor ]
    , toDataPoints = List.map blueCircle
    }
