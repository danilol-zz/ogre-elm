module Utils.Html exposing (..)

{-| This module contains extra helpers not provided by the default Html module
-}

import Html exposing (Html)
import Html.Attributes
import Utils.Css exposing (toClassName)


-- Helpers


class : class -> Html.Attribute msg
class classType =
    Html.Attributes.class <| toClassName <| classType


classes : List class -> Html.Attribute msg
classes classTypes =
    Html.Attributes.class
        (String.join " " (List.map (toClassName) classTypes))


classList : List ( classType, Bool ) -> Html.Attribute msg
classList list =
    Html.Attributes.classList
        (List.map
            (\element -> Tuple.mapFirst toClassName element)
            list
        )


empty : Html msg
empty =
    Html.text ""
