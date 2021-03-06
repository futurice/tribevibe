module Decoders exposing (..)

import Json.Decode as Decode exposing (int, string, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, hardcoded)
import Types exposing (..)


-- Dashboard decoders


decodeDashboard : Decoder TempDashboard
decodeDashboard =
    decode
        TempDashboard
        |> required "engagement" (decodeMetricValue)
        |> required "engagements" (Decode.list decodeEngagement)
        |> required "metrics" (Decode.list decodeMetricValue)
        |> required "feedbacks" (decodeFeedbacks)


decodeEngagement : Decoder Engagement
decodeEngagement =
    decode
        Engagement
        |> required "name" Decode.string
        |> required "value" Decode.float


decodeMetricDataPoint : Decoder MetricDataPoint
decodeMetricDataPoint =
    decode
        MetricDataPoint
        |> required "date" Decode.string
        |> required "value" Decode.float


decodeMetricValue : Decoder Metric
decodeMetricValue =
    decode
        Metric
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "values" (Decode.list decodeMetricDataPoint)


decodeFeedbacks : Decoder TypedFeedbacks
decodeFeedbacks =
    decode
        TypedFeedbacks
        |> required "positive" (Decode.list decodeFeedback)
        |> required "constructive" (Decode.list decodeFeedback)


decodeFeedback : Decoder Feedback
decodeFeedback =
    decode
        Feedback
        |> required "dateCreated" Decode.string
        |> required "question" Decode.string
        |> required "answer" Decode.string
        |> required "tags" (Decode.list Decode.string)
        |> required "replies" (Decode.list decodeReply)


decodeReply : Decoder Reply
decodeReply =
    decode
        Reply
        |> required "dateCreated" Decode.string
        |> required "message" Decode.string
