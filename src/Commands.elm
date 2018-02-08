module Commands exposing (..)

import Http
import Decoders exposing (decodeDashboard, decodeFeedbacks)
import Messages exposing (..)


getDashboard : String -> Cmd Msg
getDashboard tribe =
    let
        url =
            "/api/dashboard/" ++ tribe

        request =
            Http.get url decodeDashboard
    in
        Http.send ReceiveDashboard request


getFeedbacks : String -> Cmd Msg
getFeedbacks tribe =
    let
        url =
            "/api/feedback/" ++ tribe

        request =
            Http.get url decodeFeedbacks
    in
        Http.send ReceiveFeedbacks request
