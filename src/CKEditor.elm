module CKEditor exposing (ckeditor, defaultConfig)

import Html exposing (Html, node)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode exposing (Value, encode)


ckeditor : Value -> String -> (String -> msg) -> Html msg
ckeditor config content msg =
    let
        eventDecoder =
            Decode.field "detail" Decode.string
    in
        node "x-ckeditor"
            [ property "config" config
            , property "content" (Encode.string content)
            , on "ckeditorchange" (Decode.map msg eventDecoder)
            ]
            []


defaultConfig : Value
defaultConfig =
    Encode.object []
