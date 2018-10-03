port module BasicPropertyBinding exposing (main)

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



-- Observed attributes are passed as flags by default


type alias Flags =
    { properties :
        { value : Maybe Int
        }
    }


type alias Model =
    { counter : Int
    }


type Msg
    = Increment
    | SetCounter (Maybe Int)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { counter =
            flags.properties.value
                |> Maybe.withDefault 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                counter =
                    model.counter + 1
            in
            ( { model | counter = counter }
            , Cmd.none
            )

        SetCounter maybeCounter ->
            ( { model
                | counter =
                    maybeCounter
                        |> Maybe.withDefault 0
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    onValue SetCounter


view : Model -> Html Msg
view model =
    div
        []
        [ Html.text "Counter: "
        , Html.text (String.fromInt model.counter)
        , div
            []
            [ button
                [ type_ "button"
                , onClick Increment
                ]
                [ text "Increment"
                ]
            ]
        ]



-- Listens to element's "value" property changes


port onValue : (Maybe Int -> msg) -> Sub msg
