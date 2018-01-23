module Types exposing (..)


type alias Model =
    { dashboard : Maybe Dashboard
    , error : Maybe String
    }


type alias Metric =
    { id : String
    , name : String
    , values : List Float
    }


type alias Reply =
    { dateCreated : String
    , message : String
    }


type alias Feedback =
    { dateCreated : String
    , question : String
    , answer : String
    , tags : List String
    , replies : List Reply
    }


type alias Dashboard =
    { metrics : List Metric
    , feedback : Feedback
    }
