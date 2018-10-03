port module BasicEventBinding exposing (main)

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
    {}


type alias Model =
    { counter : Int
    }


type Msg
    = Increment


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { counter = 0 }
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
            , valueChanged counter
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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



-- Triggers element's "change" event


port valueChanged : Int -> Cmd msg
