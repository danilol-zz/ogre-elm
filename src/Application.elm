module Application exposing (..)

import Css
    exposing
        ( auto
        , backgroundColor
        , backgroundImage
        , backgroundSize
        , border
        , border3
        , borderCollapse
        , borderColor
        , center
        , children
        , class
        , collapse
        , display
        , displayFlex
        , height
        , hex
        , inlineBlock
        , margin
        , padding
        , pct
        , px
        , solid
        , textAlign
        , url
        , width
        )
import Html exposing (..)
import Html.Attributes exposing (disabled, src, value)
import Html.Events exposing (onClick, onInput)
import List exposing (member)
import List.Extra exposing (remove)
import Navigation
import Regex
import Update.Extra
import Utils.Css exposing (colors)
import Utils.Html
import Utils.Style exposing (style)


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Model =
    { chars : List Char
    , teams : List Team
    , result : Maybe String
    , location : Navigation.Location
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initialModel location, Cmd.none )


initialModel : Navigation.Location -> Model
initialModel location =
    Model [] [ createTeam Team1, createTeam Team2 ] Nothing location


type Msg
    = Fight
    | Restart
    | SelectMage TeamSide
    | SelectArcher TeamSide
    | SelectKnight TeamSide
    | RemoveChar Char
    | AddChar Char
    | SelectPosition
    | UrlChange Navigation.Location


type CharClass
    = Mage
    | Knight
    | Archer


type TeamSide
    = Team1
    | Team2


type alias Char =
    { hp : Int, attack : Int, name : String, charClass : CharClass, pic : String, position : Int, side : TeamSide }


type alias Team =
    { side : TeamSide, count : Int, max : Int }


initTeams : List Team
initTeams =
    [ Team Team1 0 5
    , Team Team2 0 5
    ]


createTeam : TeamSide -> Team
createTeam side =
    Team side 0 5


createKnight : TeamSide -> Char
createKnight side =
    Char 200 20 "Cavaleiro das sombras" Knight "assets/knight.jpg" 0 side


createMage : TeamSide -> Char
createMage side =
    Char 100 30 "Dark Mage" Mage "assets/archmage.jpg" 0 side


createArcher : TeamSide -> Char
createArcher side =
    Char 150 25 "Forest Hurricane" Archer "assets/archer.jpg" 0 side



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fight ->
            ( model, Cmd.none )

        SelectMage side ->
            ( { model | chars = createMage side :: model.chars }, Cmd.none )

        SelectArcher side ->
            ( { model | chars = createArcher side :: model.chars }, Cmd.none )

        SelectKnight side ->
            ( { model | chars = createKnight side :: model.chars }, Cmd.none )

        SelectPosition ->
            ( model, Cmd.none )

        AddChar char ->
            let
                charTeam =
                    List.head (List.filter (\t -> t.side == char.side) model.teams)

                updatedTeam =
                    case charTeam of
                        Just t ->
                            { t | count = t.count + 1 }

                        Nothing ->
                            createTeam char.side

                updatedTeamList =
                    List.Extra.replaceIf (\t -> t.side == updatedTeam.side) updatedTeam model.teams
            in
            ( { model | chars = char :: model.chars, teams = updatedTeamList }, Cmd.none )

        RemoveChar char ->
            let
                charTeam =
                    List.head (List.filter (\t -> t.side == char.side) model.teams)

                updatedTeam =
                    case charTeam of
                        Just t ->
                            { t | count = t.count - 1 }

                        Nothing ->
                            createTeam char.side

                updatedTeamList =
                    List.Extra.replaceIf (\t -> t.side == updatedTeam.side) updatedTeam model.teams
            in
            ( { model | chars = remove char model.chars, teams = updatedTeamList }, Cmd.none )

        UrlChange location ->
            ( { model | location = location }, Cmd.none )

        Restart ->
            ( { model | chars = [], result = Nothing, teams = initTeams }, Cmd.none )


fight : Char -> Char -> ( Char, Char )
fight mage knight =
    let
        newKnight =
            { knight | hp = knight.hp - mage.attack }

        newMage =
            { mage | hp = mage.hp - knight.attack }
    in
    ( newMage, newKnight )



-- STYLE


type CssClass
    = CharStyle
    | CharSelection
    | CharSelectionContainer
    | TeamBoard
    | TeamBoardCell1
    | TeamBoardCell2
    | Container
    | TeamComposition


styles : Html msg
styles =
    style
        [ class Container
            [ padding (20 |> px)
            ]
        , class CharStyle
            [ width (100 |> px)
            , height (120 |> px)
            ]
        , class CharSelection
            [ width (pct 100)
            ]
        , class CharSelectionContainer
            [ displayFlex
            ]
        , class TeamBoard
            [ border3 (px 1) solid colors.black
            , width (100 |> px)
            , borderCollapse collapse
            , textAlign center
            ]
        , class TeamBoardCell1
            [ border3 (px 1) solid colors.black
            , backgroundColor colors.persianGreen
            ]
        , class TeamBoardCell2
            [ border3 (px 1) solid colors.black
            , backgroundColor colors.ghostWithe
            ]
        , class TeamComposition
            [ display inlineBlock
            ]
        ]



-- VIEW


displayTeam : Model -> TeamSide -> Html Msg
displayTeam model side =
    let
        sideTeam =
            List.filter (\char -> char.side == side) model.chars
    in
    div [] (List.map (\char -> displayChar char) sideTeam)


displayChar : Char -> Html Msg
displayChar char =
    div [ Utils.Html.class TeamComposition ]
        [ img [ src char.pic, Utils.Html.class CharStyle ] []
        , select [ onClick SelectPosition ] (List.range 0 9 |> List.map intToOption)
        ]


intToOption : Int -> Html Msg
intToOption v =
    option [ value (toString v) ] [ text (toString v) ]


fightButton : Model -> Html Msg
fightButton model =
    let
        finished =
            case model.result of
                Just r ->
                    True

                Nothing ->
                    False

        disableButton =
            preConditions model == finished
    in
    button [ disabled disableButton, onClick Fight ] [ text "Fight!!!" ]


charSelect : Model -> Char -> Html Msg
charSelect model char =
    let
        disablePlus =
            teamLimit model char.side

        disableMinus =
            emptyTeam model char.side == member char model.chars
    in
    div []
        [ div []
            [ button [ disabled disableMinus, onClick (RemoveChar char) ] [ text "-" ]
            , button [ disabled disablePlus, onClick (AddChar char) ] [ text "+" ]
            ]
        , div [] [ img [ src char.pic, Utils.Html.class CharStyle ] [] ]
        ]


teamChars : Model -> Team -> List Char
teamChars model team =
    []


teamLimit : Model -> TeamSide -> Bool
teamLimit model side =
    let
        team =
            getTeam model side
    in
    if team.count < team.max then
        False
    else
        True


emptyTeam : Model -> TeamSide -> Bool
emptyTeam model side =
    let
        team =
            getTeam model side
    in
    if team.count > 0 then
        False
    else
        True


preConditions : Model -> Bool
preConditions model =
    True


getTeam : Model -> TeamSide -> Team
getTeam model side =
    let
        team =
            List.Extra.find (\team -> team.side == side) model.teams
    in
    case team of
        Just t ->
            t

        Nothing ->
            createTeam side


boardView : Html Msg
boardView =
    div []
        [ table [ Utils.Html.class TeamBoard ]
            [ tr []
                [ td [ Utils.Html.class TeamBoardCell1 ] [ text "7" ]
                , td [ Utils.Html.class TeamBoardCell2 ] [ text "4" ]
                , td [ Utils.Html.class TeamBoardCell1 ] [ text "1" ]
                ]
            , tr []
                [ td [ Utils.Html.class TeamBoardCell2 ] [ text "8" ]
                , td [ Utils.Html.class TeamBoardCell1 ] [ text "5" ]
                , td [ Utils.Html.class TeamBoardCell2 ] [ text "2" ]
                ]
            , tr []
                [ td [ Utils.Html.class TeamBoardCell1 ] [ text "9" ]
                , td [ Utils.Html.class TeamBoardCell2 ] [ text "6" ]
                , td [ Utils.Html.class TeamBoardCell1 ] [ text "3" ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ Utils.Html.class Container ]
        [ styles
        , div [] [ text "Elm Ogre Battle" ]
        , hr [] []
        , div [] [ text "Choose your character, Team 1" ]
        , hr [] []
        , div [ Utils.Html.class CharSelectionContainer ]
            [ charSelect model (createKnight Team1)
            , charSelect model (createMage Team1)
            , charSelect model (createArcher Team1)
            , text " => "
            , div [] [ displayTeam model Team1 ]
            ]
        , hr [] []
        , div [] [ text "Choose your character, Team 2" ]
        , div [ Utils.Html.class CharSelectionContainer ]
            [ charSelect model (createKnight Team2)
            , charSelect model (createMage Team2)
            , charSelect model (createArcher Team2)
            , div [] [ displayTeam model Team2 ]
            ]
        , hr [] []
        , fightButton model
        , table []
            [ tr []
                [ td [] [ text (toString model.result) ]
                ]
            ]
        , hr [] []
        , button [ onClick Restart ] [ text "Restart" ]
        , hr [] []
        , div [] [ text "Teams Position:" ]
        , boardView
        ]
