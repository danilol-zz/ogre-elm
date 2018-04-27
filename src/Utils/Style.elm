module Utils.Style
    exposing
        ( style
        , styleTxt
        )

import Css exposing (Snippet, compile, stylesheet)
import Html exposing (Html, node, text)


-- Render a style tag node.


style : List Snippet -> Html msg
style styles =
    styleTxt <| .css <| compile [ stylesheet styles ]


styleTxt : String -> Html msg
styleTxt styles =
    node "style" [] [ text styles ]
