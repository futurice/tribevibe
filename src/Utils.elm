module Utils exposing (..)


getEmojiForValue : Float -> String
getEmojiForValue value =
    if value > 9.5 then
        "😅"
    else if value > 9 then
        "😄"
    else if value > 8.5 then
        "😃"
    else if value > 8 then
        "😀"
    else if value > 7.5 then
        "😊"
    else if value > 7 then
        "🙂"
    else if value > 6.5 then
        "😏"
    else if value > 6 then
        "😒"
    else if value > 5.5 then
        "😕"
    else if value > 5 then
        "😟"
    else if value > 4.5 then
        "😔"
    else if value > 4 then
        "😣"
    else if value > 3.5 then
        "😖"
    else if value > 3 then
        "😤"
    else if value > 2.5 then
        "😠"
    else if value > 2 then
        "😡"
    else if value > 1.5 then
        "\x1F92C"
    else
        "💩"
