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
    }


type Msg
    = UrlChange Url.Url
    | UrlRequest Browser.UrlRequest
    | FirstForm FirstFormMsg
    | SecondForm SecondFormMsg


type FirstFormMsg
    = Blur
    | Input String


type SecondFormMsg
    = Noop


init : Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key
      , form = First
      , url = url
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

        FirstForm Blur ->
            ( model, Cmd.none )

        FirstForm (Input string) ->
            -- This simulates a real life scenario when authentication expires
            -- and you redirect to login
            ( model, Browser.Navigation.pushUrl model.key (Url.toString model.url) )

        SecondForm Noop ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Page title"
    , body =
        [ case model.form of
            First ->
                formView model
                    |> Html.map FirstForm

            Second ->
                anotherFormView model
                    |> Html.map SecondForm
        ]
    }


formView : Model -> Html FirstFormMsg
formView model =
    div []
        [ h1 [] [ text "First form" ]
        , input
            [ Html.Events.onBlur Blur
            , Html.Events.onInput Input
            ]
            []
        ]


anotherFormView : Model -> Html msg
anotherFormView model =
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
