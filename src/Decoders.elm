module Decoders exposing (..)

import Json.Decode as Decode exposing (int, string, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Types exposing (..)


-- Dashboard decoders


decodeDashboard : Decoder Dashboard
decodeDashboard =
    decode
        Dashboard
        |> required "metrics" (Decode.list decodeMetricValue)
        |> required "feedback" decodeFeedback


decodeMetricValue : Decoder Metric
decodeMetricValue =
    decode
        Metric
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "values" (Decode.list Decode.float)


decodeFeedback : Decoder Feedback
decodeFeedback =
    decode
        Feedback
        |> required "dateCreated" Decode.string
        |> required "question" Decode.string
        |> required "tags" (Decode.list Decode.string)
        |> required "replies" (Decode.list decodeReply)


decodeReply : Decoder Reply
decodeReply =
    decode
        Reply
        |> required "dateCreated" Decode.string
        |> required "message" Decode.string
