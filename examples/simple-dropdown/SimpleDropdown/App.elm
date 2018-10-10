port module SimpleDropdown.App exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Random
import Random.Char as RandomChar
import Random.String as RandomString


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port notifyOpenned : () -> Cmd msg


port notifyClosed : () -> Cmd msg


type alias Flags =
    { seed : Int
    }


type alias Model =
    { internalId : String
    , isOpen : Bool
    }


initialModel : Int -> Model
initialModel seed =
    let
        ( internalId, _ ) =
            Random.step
                (RandomString.string 32 RandomChar.lowerCaseLatin)
                (Random.initialSeed seed)
    in
    { internalId = internalId
    , isOpen = False
    }


type Msg
    = Open
    | Close


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags.seed
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open ->
            ( { model | isOpen = True }
            , notifyOpenned ()
            )

        Close ->
            ( { model | isOpen = False }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div
        [ style "position" "relative"
        ]
        [ button
            [ id model.internalId
            , type_ "button"
            , attribute "aria-haspopup" "true"
            , attribute "aria-expanded"
                (if model.isOpen then
                    "true"

                 else
                    "false"
                )
            , onClick
                (if model.isOpen then
                    Close

                 else
                    Open
                )
            ]
            [ node "slot"
                [ name "action"
                ]
                []
            ]
        , div
            [ attribute "aria-labelledby" model.internalId
            , style "display"
                (if model.isOpen then
                    "block"

                 else
                    "none"
                )
            , style "position" "absolute"
            , style "border" "1px solid #ddd"
            , style "border-radius" "0 5px 5px 5px"
            , style "padding" "0.5rem"
            , style "box-shadow" "1px 1px 3px 0 rgba(0, 0, 0, 0.8)"
            ]
            [ node "slot"
                [ name "content"
                ]
                []
            ]
        ]
