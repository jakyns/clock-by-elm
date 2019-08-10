module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, div, h1, text)
import Task exposing (Task)
import Time exposing (utc)


type alias Model =
    { time : Maybe Time.Posix
    , zone : Time.Zone
    }


type Msg
    = Tick Time.Posix
    | AdjustTimezone Time.Zone


init : () -> ( Model, Cmd Msg )
init _ =
    ( { time = Nothing, zone = Time.utc }
    , Task.perform AdjustTimezone Time.here
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = Just newTime }
            , Cmd.none
            )

        AdjustTimezone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )


view : Model -> Document Msg
view model =
    { title = "Clock"
    , body =
        let
            ( hour, minute, second ) =
                currentTime model.time model.zone
        in
        [ h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ] ]
    }


currentTime : Maybe Time.Posix -> Time.Zone -> ( String, String, String )
currentTime time zone =
    let
        ( hour, minute, second ) =
            case time of
                Just now ->
                    ( Time.toHour zone now
                        |> String.fromInt
                        |> String.padLeft 2 '0'
                    , Time.toMinute zone now
                        |> String.fromInt
                        |> String.padLeft 2 '0'
                    , Time.toSecond zone now
                        |> String.fromInt
                        |> String.padLeft 2 '0'
                    )

                Nothing ->
                    ( "", "", "" )
    in
    ( hour, minute, second )


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
