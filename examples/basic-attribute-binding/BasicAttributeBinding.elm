port module BasicAttributeBinding exposing (main)

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
    { attributes :
        { value : String
        }
    }


type alias Model =
    { counter : Int
    }


type Msg
    = Increment
    | SetCounter String


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { counter =
            String.toInt flags.attributes.value
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

        SetCounter counter ->
            ( { model
                | counter =
                    String.toInt counter
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



-- Listens to element's "value" attribute changes


port onValue : (String -> msg) -> Sub msg
