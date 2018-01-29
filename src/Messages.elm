module Messages exposing (..)

import Http
import Types exposing (Dashboard)
import Time exposing (Time)
import Navigation exposing (Location)


type Msg
    = ReceiveDashboard (Result Http.Error Dashboard)
    | Tick Time
    | LocationChange Location
