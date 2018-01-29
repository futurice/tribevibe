module Commands exposing (..)

import Http
import Decoders exposing (decodeDashboard)
import Messages exposing (..)


getDashboard : String -> Cmd Msg
getDashboard tribe =
    let
        url =
            "http://localhost:4000/api/dashboard/" ++ tribe

        request =
            Http.get url decodeDashboard
    in
        Http.send ReceiveDashboard request
