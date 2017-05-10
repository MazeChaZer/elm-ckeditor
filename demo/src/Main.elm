module Main exposing (main)

import Color exposing (Color)
import Html exposing (button, div, pre, text, textarea)
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode exposing (Value)
import Random
import Random.Color
import Color.Convert exposing (colorToHex)
import CKEditor exposing (ckeditor, config, content, onCKEditorChange, defaultConfig)
import Html.Attributes exposing (value)


main : Platform.Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { config : Value
    , content : String
    , testContent : String
    }


init : ( Model, Cmd Msg )
init =
    ( { config = defaultConfig
      , content = ""
      , testContent = "<p>Hello CKEditor!</p>\n"
      }
    , Cmd.none
    )


type Msg
    = CKEditorChanged String
    | ChangeConfig
    | NewColor Color
    | ChangeContent
    | TestContentChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CKEditorChanged content ->
            ( { model | content = content }, Cmd.none )

        ChangeConfig ->
            ( model, Random.generate NewColor Random.Color.rgb )

        NewColor color ->
            let
                config =
                    Encode.object
                        [ ( "uiColor", Encode.string (colorToHex color) ) ]
            in
                ( { model | config = config }, Cmd.none )

        ChangeContent ->
            ( { model | content = model.testContent }, Cmd.none )

        TestContentChanged testContent ->
            ( { model | testContent = testContent }, Cmd.none )


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
        , textarea [ onInput TestContentChanged, value model.testContent ] []
        , button [ onClick ChangeContent ] [ text "Change Content" ]
        ]
