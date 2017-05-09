module CKEditor
    exposing
        ( ckeditor
        , config
        , content
        , onCKEditorChange
        , defaultConfig
        )

import Html exposing (node, Html, Attribute)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode exposing (encode, Value)


ckeditor : List (Attribute msg) -> List (Html msg) -> Html msg
ckeditor =
    node "x-ckeditor"


config : Value -> Attribute msg
config =
    property "config"


content : String -> Attribute msg
content value =
    property "content" (Encode.string value)


onCKEditorChange : (String -> msg) -> Attribute msg
onCKEditorChange msg =
    on "ckeditorchange" (Decode.map msg (Decode.field "detail" Decode.string))


defaultConfig : Value
defaultConfig =
    Encode.object []
