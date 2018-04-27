module Tests exposing (all)

import ElmTest.Extra exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag)

import Application

all : Test
all =
    describe "Elm template tests"
        [ test "title is displayed into the view" <|
            \() ->
                Application.view { title = "Test title" }
                    |> Query.fromHtml
                    |> Query.find [tag "span"]
                    |> Query.has [ text "Test title" ]
        ]
