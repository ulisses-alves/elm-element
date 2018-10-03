port module Tooltip exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    { attributes :
        { text : Maybe String
        }
    }


type alias Model =
    { text : String
    , visible : Bool
    }


type Msg
    = SetText (Maybe String)
    | Show
    | Hide


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { text =
            flags.attributes.text
                |> Maybe.withDefault ""
      , visible = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetText maybeText ->
            ( { model | text = Maybe.withDefault "" maybeText }
            , Cmd.none
            )

        Show ->
            ( { model | visible = True }
            , tooltipShown ()
            )

        Hide ->
            ( { model | visible = False }
            , tooltipHidden ()
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    onTextChange SetText


view : Model -> Html Msg
view model =
    div
        [ style "position" "relative"
        , style "display" "inline-block"
        , style "cursor" "default"
        ]
        [ div
            [ style "display"
                (if model.visible then
                    "block"

                 else
                    "none"
                )
            , style "border" "1px solid #ddd"
            , style "border-radius" "5px"
            , style "background-color" "#e8e8e8"
            , style "padding" "0.5rem"
            , style "white-space" "nowrap"
            , style "position" "absolute"
            , style "right" "0"
            , style "transform" "translate(100%, -100%)"
            ]
            [ text model.text
            ]
        , node "slot"
            [ onMouseEnter Show
            , onMouseLeave Hide
            ]
            []
        ]


port tooltipShown : () -> Cmd msg


port tooltipHidden : () -> Cmd msg


port onTextChange : (Maybe String -> msg) -> Sub msg
