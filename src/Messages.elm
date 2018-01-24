module Messages exposing (..)

import Http
import Types exposing (Dashboard)
import Time exposing (Time)


type Msg
    = ReceiveDashboard (Result Http.Error Dashboard)
    | Tick Time
