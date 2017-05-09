module Main exposing (main)

import Color exposing (Color)
import Html exposing (div, pre, text, button)
import Html.Events exposing (onClick)
import Json.Encode as Encode exposing (Value)
import Random
import Random.Color
import Color.Convert exposing (colorToHex)
import CKEditor exposing (ckeditor, config, content, onCKEditorChange, defaultConfig)


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
    }


init : ( Model, Cmd Msg )
init =
    ( { config = defaultConfig
      , content = ""
      }
    , Cmd.none
    )


type Msg
    = CKEditorChanged String
    | ChangeConfig
    | NewColor Color


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
