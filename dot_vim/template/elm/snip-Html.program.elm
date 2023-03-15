main =
    Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

init : String -> (Model, Cmd Msg)
init =
    ( Model )

-- UPDATE

type Msg
    = None

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
    div [] []

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

