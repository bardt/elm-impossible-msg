module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Events
import Url


type Form
    = First
    | Second


type alias Model =
    { key : Browser.Navigation.Key
    , form : Form
    , url : Url.Url
    , inputLength : Int
    }


type Msg
    = UrlChange Url.Url
    | UrlRequest Browser.UrlRequest
    | FirstForm FirstFormMsg
    | SecondForm SecondFormMsg


type FirstFormMsg
    = FirstFormChange { firstInput : String }


type SecondFormMsg
    = SecondFormChange { secondInput : String }


init : Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key
      , form = First
      , url = url
      , inputLength = 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        UrlChange _ ->
            -- For demo purposes we switch to second form on any change
            ( { model | form = Second }, Cmd.none )

        UrlRequest urlRequestBrowser ->
            case urlRequestBrowser of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External urlString ->
                    ( model
                    , Browser.Navigation.load urlString
                    )

        FirstForm (FirstFormChange { firstInput }) ->
            {- This simulates a real life scenario when authentication expires
               and you redirect to login
            -}
            ( { model | inputLength = String.length firstInput }, Browser.Navigation.pushUrl model.key (Url.toString model.url) )

        SecondForm (SecondFormChange { secondInput }) ->
            {- `String.length` call is required to demonstrate how runtime
               exception can occure. At this point we receive
               `SecondForm (FormChange { firstInput = "" })`, but trying to
               use `secondInput` field.
            -}
            ( { model | inputLength = String.length secondInput }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Page title"
    , body =
        [ case model.form of
            First ->
                firstFormView model
                    |> Html.map FirstForm

            Second ->
                secondFormView model
                    |> Html.map SecondForm
        ]
    }


firstFormView : Model -> Html FirstFormMsg
firstFormView model =
    div []
        [ h1 [] [ text "First form" ]
        , input
            [ Html.Events.onBlur (FirstFormChange { firstInput = "" })
            , Html.Events.onInput (\input -> FirstFormChange { firstInput = input })
            ]
            []
        ]


secondFormView : Model -> Html SecondFormMsg
secondFormView model =
    div []
        [ h1 [] [ text "Second form" ]
        , button [] [ text "Button" ]
        ]


main : Program () Model Msg
main =
    Browser.application
        { init = always init
        , view = view
        , update = update
        , onUrlChange = UrlChange
        , onUrlRequest = UrlRequest
        , subscriptions = always Sub.none
        }
