module Commands exposing (..)

import Http
import Json.Encode as Encode exposing (..)
import Decoders exposing (decodeWeeklyReports)
import Messages exposing (..)


getWeeklyReports : Cmd Msg
getWeeklyReports =
    let
        -- "https://app.officevibe.com/api/v2/engagement"
        url =
            "http://localhost:3001/engagement"

        body =
            Http.jsonBody <|
                Encode.object
                    [ ( "groupNames", Encode.string "Tammerforce" )
                    , ( "dates", Encode.list (List.map Encode.string [ "2017-12-01", "2018-01-01" ]) )
                    ]

        headers =
            [ Http.header "Authorization" "Bearer TOKEN" ]

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = url
                , body = body
                , expect = Http.expectJson decodeWeeklyReports
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ReceiveWeeklyReports request
