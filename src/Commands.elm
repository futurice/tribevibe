module Commands exposing (..)

import Http
import Decoders exposing (decodeDashboard)
import Messages exposing (..)


getDashboard : Cmd Msg
getDashboard =
    let
        url =
            "http://localhost:3001/dashboard"

        request =
            Http.get url decodeDashboard
    in
        Http.send ReceiveDashboard request
