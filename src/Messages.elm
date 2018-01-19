module Messages exposing (..)

import Http
import Types exposing (WeeklyReports)


type Msg
    = ReceiveWeeklyReports (Result Http.Error WeeklyReports)
