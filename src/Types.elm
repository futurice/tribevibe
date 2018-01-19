module Types exposing (..)


type alias MetricsValue =
    { id : String
    , displayName : String
    , value : Float
    }


type alias WeeklyReport =
    { groupName : String
    , date : String
    , metricsValues : List MetricsValue
    }


type alias WeeklyReports =
    { weeklyReports : List WeeklyReport
    }


type alias Model =
    { weeklyReports : WeeklyReports
    }


interestingMetrics : List String
interestingMetrics =
    [ "MG-2", "MG-7", "MG-1" ]
