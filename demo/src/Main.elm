module Main exposing (main)

import Html exposing (div, pre, text, button)
import Html.Events exposing (onClick)
import Json.Encode as Encode exposing (Value)
import CKEditor exposing (ckeditor, config, content, onCKEditorChange, defaultConfig)


main : Platform.Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    { config : Value
    , content : String
    }


init : Model
init =
    { config = defaultConfig
    , content = ""
    }


type Msg
    = CKEditorChanged String
    | ChangeConfig


update : Msg -> Model -> Model
update msg model =
    case msg of
        CKEditorChanged content ->
            { model | content = content }

        ChangeConfig ->
            { model | config = Encode.object [ ( "uiColor", Encode.string "#AADC6E" ) ] }


view : Model -> Html.Html Msg
view model =
    div
        []
        [ ckeditor
            [ config model.config
            , content model.content
            , onCKEditorChange CKEditorChanged
            ]
            []
        , pre [] [ text model.content ]
        , button [ onClick ChangeConfig ] [ text "Change Config" ]
        ]
