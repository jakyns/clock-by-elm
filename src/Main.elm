module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, div, h1, text)
import Task exposing (Task)
import Time exposing (utc)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { time = Nothing }
    , Task.perform Tick Time.now
    )


type alias Model =
    { time : Maybe Time.Posix
    }


type Msg
    = Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = Just newTime }
            , Cmd.none
            )


view : Model -> Document Msg
view model =
    { title = "Clock"
    , body =
        let
            ( hour, minute, second ) =
                case model.time of
                    Just time ->
                        ( Time.toHour utc time
                            |> String.fromInt
                            |> String.padLeft 2 '0'
                        , Time.toMinute utc time
                            |> String.fromInt
                            |> String.padLeft 2 '0'
                        , Time.toSecond utc time
                            |> String.fromInt
                            |> String.padLeft 2 '0'
                        )

                    Nothing ->
                        ( "", "", "" )
        in
        [ h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ] ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
