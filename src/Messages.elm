module Messages exposing (..)

import Http
import Types exposing (TempDashboard)
import Time exposing (Time)
import Navigation exposing (Location)
import Types exposing (Feedback)


type Msg
    = ReceiveDashboard (Result Http.Error TempDashboard)
    | Tick Time
    | LocationChange Location
    | FeedbacksShuffled (List Feedback)
