module Types exposing (..)


type alias MetricValue =
    { id : String
    , displayName : String
    , value : Float
    }


type alias WeeklyReport =
    { groupName : String
    , date : String
    , metricsValues : List MetricValue
    }


type alias WeeklyReports =
    { weeklyReports : List WeeklyReport
    }


type alias Model =
    { weeklyReports : WeeklyReports
    }
