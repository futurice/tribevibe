module FeedbacksView exposing (viewFeedbacks)

import Html exposing (Html, text, div, header, span, h1, ul, h3, p)
import Html.Attributes exposing (class)
import ElmEscapeHtml exposing (unescape)
import Messages exposing (Msg)
import Types exposing (Model, Feedback, TypedFeedbacks)
import Views exposing (viewError, viewTag, viewReplies)


viewFeedbacks : Model -> String -> Html Msg
viewFeedbacks model tribe =
    div []
        [ header [ class "header" ]
            [ span [] [ text "Tribevibe Feedback browser" ]
            , span [ class "header__tribe" ] [ text tribe ]
            ]
        , div [ class "container" ]
            [ viewError model.error
            , viewFeedbackList model.feedbacks
            ]
        ]


viewFeedbackList : Maybe TypedFeedbacks -> Html Msg
viewFeedbackList feedbacks =
    case feedbacks of
        Nothing ->
            p [ class "dashboard__loading" ] [ text "No feedbacks found!" ]

        Just feedbacks ->
            div [ class "feedbacks" ]
                [ h1 [ class "feedbacks__title" ] [ text "Positive" ]
                , ul [] (List.map viewFeedback feedbacks.positive)
                , h1 [ class "feedbacks__title" ] [ text "Constructive" ]
                , ul [] (List.map viewFeedback feedbacks.constructive)
                ]


viewFeedback : Feedback -> Html Msg
viewFeedback feedback =
    div [ class "single-feedback card card--big" ]
        [ h3 [ class "single-feedback__title" ] [ text (unescape feedback.question) ]
        , p [ class "single-feedback__message" ] [ text (unescape feedback.answer) ]
        , viewReplies feedback.replies
        , div [ class "single-feedback__tags" ] (List.map viewTag feedback.tags)
        ]
