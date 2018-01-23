module Messages exposing (..)

import Http
import Types exposing (Dashboard)


type Msg
    = ReceiveDashboard (Result Http.Error Dashboard)
