module Commands exposing (..)

import Http
import Decoders exposing (decodeWeeklyReports)
import Messages exposing (..)


getWeeklyReports : Cmd Msg
getWeeklyReports =
    let
        url =
            "http://localhost:3001/engagement?groupNames=Tammerforce&dates=2017-12-01,2018-01-01"

        request =
            Http.get url decodeWeeklyReports
    in
        Http.send ReceiveWeeklyReports request
