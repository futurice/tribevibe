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


type alias Feedbacks =
    List Feedback


type alias Feedback =
    { dateCreated : String
    , question : String
    , answer : String
    , tags : List String
    , replies : List Reply
    }


type alias Dashboard =
    { engagements : Engagements
    , metrics : List Metric
    , feedbacks : List Feedback
    }


type alias Engagements =
    List Engagement


type alias Engagement =
    { name : String
    , value : Float
    }
