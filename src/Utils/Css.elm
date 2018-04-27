module Utils.Css exposing (..)

import Css exposing (FontWeight, bold)
import Css.Media as Media exposing (minWidth, only, screen, withMedia)
import Regex
import String


-- COLORS


{-| We select the color names based on the tool
<http://www.color-blindness.com/color-name-hue/>
-}
type alias Colors =
    { robinEggBlue : Css.Color
    , midnightBlue : Css.Color
    , blue : Css.Color
    , cadetBlue : Css.Color
    , lavender : Css.Color
    , persianGreen : Css.Color
    , puertoRico : Css.Color
    , radicalRed : Css.Color
    , heather : Css.Color
    , zircon : Css.Color
    , dustyGray : Css.Color
    , slateGray : Css.Color
    , carouselPink : Css.Color
    , white : Css.Color
    , ghostWithe : Css.Color
    , shark : Css.Color
    , slateGray : Css.Color
    , black : Css.Color
    , shadow : Css.Color
    }


colors : Colors
colors =
    -- Blue colors
    { midnightBlue = Css.rgb 20 15 70
    , robinEggBlue = Css.rgb 0 221 190
    , blue = Css.rgb 64 1 247
    , cadetBlue = Css.rgb 166 181 195
    , lavender = Css.rgb 216 231 246

    -- Green colors
    , persianGreen = Css.rgb 0 175 159
    , puertoRico = Css.rgb 79 177 159

    -- Red colors
    , radicalRed = Css.rgb 255 62 85

    -- Grey colors
    , heather = Css.rgb 166 181 196
    , zircon = Css.rgb 227 229 232
    , dustyGray = Css.rgb 155 155 155
    , slateGray = Css.rgb 119 133 147

    -- Pink colors
    , carouselPink = Css.rgb 250 229 233

    -- White colors
    , white = Css.rgb 255 255 255
    , ghostWithe = Css.rgb 250 250 255

    -- Black colors
    , black = Css.rgb 0 0 0
    , shadow = Css.rgba 0 0 0 0.1
    , shark = Css.rgb 48 49 51
    }



-- Helpers
-- FIXME Let's hope Elm gets typeclasses one day and we can get rid of this thing.


cls : class -> String
cls thing =
    toString thing


toClassName : class -> String
toClassName classType =
    classType
        |> toString
        |> String.trim
        |> Regex.replace Regex.All (Regex.regex "\\s+") (\_ -> "-")
        |> Regex.replace Regex.All (Regex.regex "[^a-zA-Z0-9_-]") (\_ -> "")


classList : List class -> String
classList classTypes =
    String.join "" <| List.map toClassName classTypes


class : class -> List Css.Style -> Css.Snippet
class classType styles =
    Css.class (toClassName classType) styles


classWrapper : class -> List Css.Style -> List Css.Style
classWrapper classType styles =
    [ Css.withClass (toClassName classType) styles ]


classes : List class -> List Css.Style -> Css.Snippet
classes classTypes styles =
    Css.selector "*" <| List.foldr classWrapper styles classTypes


notVeryBold : FontWeight {}
notVeryBold =
    { bold | value = "300" }


semiBold : FontWeight {}
semiBold =
    { bold | value = "500" }


inlineMixing : Css.Style
inlineMixing =
    Css.batch
        [ Css.display Css.inlineBlock
        , Css.verticalAlign Css.top
        , Css.marginRight (-4 |> Css.px)
        ]


buttonMixing : Css.Style
buttonMixing =
    Css.batch
        [ Css.borderRadius (26 |> Css.px)
        , Css.fontSize (12 |> Css.px)
        , Css.fontWeight Css.bold
        , Css.margin Css.zero
        , Css.textAlign Css.center
        , Css.textTransform Css.uppercase
        , Css.borderWidth Css.zero
        , Css.cursor Css.pointer
        , transition2 "background" (0.5 |> sec)
        , Css.focus
            [ Css.outline Css.zero
            ]
        ]


desktopViewPort : Float
desktopViewPort =
    768.0


desktop : List Css.Style -> Css.Style
desktop styles =
    withMedia [ only screen [ minWidth (desktopViewPort |> Css.px) ] ] styles


print : List Css.Style -> Css.Style
print styles =
    withMedia [ only Media.print [] ] styles


containerMixing : Css.Style
containerMixing =
    Css.batch
        [ Css.padding2 Css.zero (32 |> Css.px)
        ]


appearance : Css.Style
appearance =
    Css.batch
        [ Css.property "-webkit-appearance" <| "none"
        , Css.property "-moz-appearance" <| "none"
        , Css.property "appearance" <| "none"
        ]


textLikeAppearance : Css.Style
textLikeAppearance =
    Css.batch
        [ Css.property "-webkit-appearance" <| "none"
        , Css.property "-moz-appearance" <| "textfield"
        , Css.property "appearance" <| "none"
        ]



-- Custom properties


type alias Seconds =
    String


sec : a -> Seconds
sec units =
    Basics.toString units ++ "s"


animation : String -> Seconds -> Css.Style
animation name time =
    Css.property "animation" <| String.join " " [ name, time, "forwards" ]


animationInf : String -> Seconds -> Css.Style
animationInf name time =
    Css.property "animation" <| String.join " " [ name, time, "infinite" ]


animationDelay : Seconds -> Css.Style
animationDelay time =
    Css.property "animation-delay" <| String.join " " [ time ]


placeholder : List Css.Style -> Css.Style
placeholder styles =
    Css.pseudoElement "placeholder" styles


transition2 : String -> Seconds -> Css.Style
transition2 property duration =
    Css.property "transition" <| String.join " " [ property, duration ]


applicationGradient : Css.Style
applicationGradient =
    {- This is a workaround due to a bug on the
       Css.linearGradient2 https://github.com/rtfeldman/elm-css/issues/335

       Css.backgroundImage (Css.linearGradient2 (29 |> Css.deg) stop1 stop2 [])
    -}
    Css.property
        "background-image"
        "linear-gradient(29deg, rgba(134, 68, 255, 1), rgba(0, 0, 194, 1))"

narrowWrapper : Css.Style
narrowWrapper =
    Css.batch
        [ Css.property "max-width" <| "680px"
        , Css.property "margin" <| "0 auto"
        ]
