module Decoders exposing (..)

import Json.Decode as Decode exposing (int, string, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Types exposing (..)


decodeWeeklyReports : Decoder WeeklyReports
decodeWeeklyReports =
    decode
        WeeklyReports
        |> requiredAt [ "data", "weeklyReports" ] (Decode.list decodeWeeklyReport)


decodeWeeklyReport : Decoder WeeklyReport
decodeWeeklyReport =
    decode
        WeeklyReport
        |> required "groupName" Decode.string
        |> required "date" Decode.string
        |> required "metricsValues" (Decode.list decodeMetricsValue)


decodeMetricsValue : Decoder MetricValue
decodeMetricsValue =
    decode
        MetricValue
        |> required "id" Decode.string
        |> required "displayName" Decode.string
        |> required "value" Decode.float
