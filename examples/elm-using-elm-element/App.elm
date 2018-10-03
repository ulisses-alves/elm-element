module App exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    {}


type alias Model =
    { message : String
    }


type Msg
    = TooltipShown
    | TooltipHidden


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { message = "Mouse over me..." }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TooltipShown ->
            ( { model | message = "Hi there user..." }
            , Cmd.none
            )

        TooltipHidden ->
            ( { model | message = "Mouse over me..." }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div
        []
        [ h4
            []
            [ text "App"
            ]
        , node "my-tooltip"
            [ attribute "text" "... I'm a tooltip component!"
            , on "show" (Decode.succeed TooltipShown)
            , on "hide" (Decode.succeed TooltipHidden)
            ]
            [ text model.message
            ]
        ]
