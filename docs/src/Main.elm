module Main exposing (..)

import Html exposing (a, Html, br, div, text, li, ul, img, h1, b, span, h2)
import Html.Attributes exposing (classList, src, placeholder, alt, id, class, href)
import Html.Events exposing (..)
import List exposing (map, head, tail)
import Components.Project exposing (..)
import Components.Content as Content exposing (..)
import Animation exposing (rem, interrupt, subscription)
import Animation.Messenger exposing (..)
import Components.UpdateMessages exposing (..)
import Markdown exposing (..)


--my file where I put all animation states

import AnimationHelper exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { state : ViewState
    , list : List ProjectCell
    , textStyle : Animation.Messenger.State Msg
    , closeButtonStyle : Animation.Messenger.State Msg
    , profilePic : ProfilePic
    }



--Start model of my application


initPP : ProfilePic
initPP =
    { style = profilePicStartStyle
    , mode = Off
    , textStyle = profileTextStart
    }


init : ( Model, Cmd Msg )
init =
    ( Model ProjectView (List.map convertToCell startList) textStartStyle closeButtonStartStyle initPP, Cmd.none )


convertToCell : Project -> ProjectCell
convertToCell project =
    ProjectCell project startStyle



{--the two states the application can be in, either project view or
detailed view (and if its detailed view we have a current project as well--}


type ViewState
    = ProjectView
    | DetailedView ProjectCell



--what we start our application with


startList : List Project
startList =
    [ hiki, sportswik, faces ]



-- UPDATE, handles all changes that come in


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleDetailed project ->
            case model.state of
                DetailedView _ ->
                    ( toProjectView model
                    , Cmd.none
                    )

                ProjectView ->
                    ( toDetailedView model project
                    , Cmd.none
                    )

        BringOutText ->
            ( { model | textStyle = textToVisible model.textStyle, closeButtonStyle = closeButtonNormal model.closeButtonStyle }, Cmd.none )

        Animate animMsg ->
            let
                listAndCmd =
                    List.map
                        (onStyle animMsg)
                        model.list

                newStyles =
                    List.map
                        (\( style, cmd ) -> style)
                        listAndCmd

                newCmds =
                    List.map
                        (\( style, cmd ) -> cmd)
                        listAndCmd

                ( newTextStyle, textMsg ) =
                    Animation.Messenger.update animMsg model.textStyle

                ( newCloseStyle, closeMsg ) =
                    Animation.Messenger.update animMsg
                        model.closeButtonStyle

                ( ppStyle, ppMsg ) =
                    Animation.Messenger.update animMsg
                        model.profilePic.style

                ( pptStyle, pptMsg ) =
                    Animation.Messenger.update
                        animMsg
                        model.profilePic.textStyle

                profilePic =
                    model.profilePic
            in
                ( { model
                    | list =
                        newStyles
                    , textStyle =
                        newTextStyle
                    , closeButtonStyle =
                        newCloseStyle
                    , profilePic =
                        { profilePic | style = ppStyle, textStyle = pptStyle }
                  }
                , Cmd.batch <| newCmds ++ [ textMsg, closeMsg, ppMsg, pptMsg ]
                )

        HoverOn who ->
            case who of
                ProjectHover ->
                    ( { model | closeButtonStyle = closeButtonHover model.closeButtonStyle }, Cmd.none )

                ProfileHover ->
                    let
                        profilePic =
                            model.profilePic
                    in
                        ( { model | profilePic = { profilePic | style = profilePicHover profilePic.style } }, Cmd.none )

        HoverOff who ->
            case who of
                ProjectHover ->
                    ( { model | closeButtonStyle = closeButtonNormal model.closeButtonStyle }, Cmd.none )

                ProfileHover ->
                    let
                        profilePic =
                            model.profilePic
                    in
                        ( { model | profilePic = { profilePic | style = profilePicNoHover profilePic.style } }, Cmd.none )

        ProfileClick ->
            case model.profilePic.mode of
                Off ->
                    startProfileAnimation model

                Animating ->
                    ( model, Cmd.none )

                Done ->
                    ( { model | profilePic = deExpandProfile model.profilePic }, Cmd.none )

        ProfileAnimationDone toMode ->
            let
                profilePic =
                    model.profilePic
            in
                ( { model | profilePic = { profilePic | mode = toMode } }, Cmd.none )


startProfileAnimation : Model -> ( Model, Cmd Msg )
startProfileAnimation model =
    ( { model | profilePic = expandProfile model.profilePic }, Cmd.none )


delay : Float
delay =
    120


expandProfile : ProfilePic -> ProfilePic
expandProfile pp =
    { pp | style = (profilePicExpanded pp.style), mode = Animating, textStyle = (profileTextAppear delay pp.textStyle) }


deExpandProfile : ProfilePic -> ProfilePic
deExpandProfile pp =
    { pp | mode = Animating, style = profilePicNormal delay pp.style, textStyle = (profileTextDisappear pp.textStyle) }


onStyle : Animation.Msg -> ProjectCell -> ( ProjectCell, Cmd Msg )
onStyle animMsg cell =
    let
        ( style, cmd ) =
            Animation.Messenger.update animMsg cell.style
    in
        ( { cell | style = style }, cmd )


toDetailedView : Model -> ProjectCell -> Model
toDetailedView model cell =
    let
        profilePic =
            model.profilePic
    in
        { model
            | state = DetailedView cell
            , list = List.map (animateToDetailed cell.project) model.list
            , profilePic =
                { profilePic | style = profilePicHidden profilePic.style, textStyle = profileTextFastGone profilePic.textStyle, mode = Off }
        }


animateToDetailed : Project -> ProjectCell -> ProjectCell
animateToDetailed targetProject cell =
    if cell.project == targetProject then
        { cell | style = projectBigSize cell.style }
    else
        { cell | style = projectNothingSize cell.style }


animateToProject : ProjectCell -> ProjectCell
animateToProject cell =
    { cell | style = projectNormalSize cell.style }


toProjectView : Model -> Model
toProjectView model =
    let
        profilePic =
            model.profilePic
    in
        { model
            | state = ProjectView
            , list = map animateToProject model.list
            , textStyle = textToHidden model.textStyle
            , closeButtonStyle = closeButtonHidden model.closeButtonStyle
            , profilePic = { profilePic | style = profilePicNormal 0 profilePic.style }
        }



-- SUBSCRIPTIONS this is only for animation for now


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate <| (map getAnimation model.list) ++ [ model.textStyle, model.closeButtonStyle, model.profilePic.style, model.profilePic.textStyle ]


getAnimation : ProjectCell -> Animation.Messenger.State Msg
getAnimation cell =
    cell.style


getAnimations : List ProjectCell -> List (Animation.Messenger.State Msg)
getAnimations cell =
    List.map getAnimation cell



-- VIEW -- this is everything we draw onto the screen ------------------------


view : Model -> Html Msg
view model =
    div [ class "all" ]
        [ div [ id "myText" ]
            [ div [ id "myName" ] [ text "Oskar Olausson" ]
            , div [ id "myMail" ] [ text "oskar.erik.olausson@gmail.com" ]
            ]
        , profileRoute model
        , projectRoute model
        ]


background : Html Msg
background =
    div []
        [ img
            [ id "background"
            , src "static/img/background.jpg"
            ]
            []
        , div [ id "backgroundSlate" ] []
        ]


profileRoute : Model -> Html Msg
profileRoute model =
    div [ id "profileRoute" ]
        [ img
            ([ id "profilePic"
             , src "static/img/meSquare.jpg"
             , onClick ProfileClick
             ]
                ++ (Animation.render model.profilePic.style)
                ++ (getProfileHoverInteraction model.profilePic.mode)
            )
            []
        , div ((Animation.render model.profilePic.textStyle) ++ [ id "whatIDo" ]) [ Markdown.toHtml [] Content.profileText ]
        ]


getProfileHoverInteraction : ProfilePicMode -> List (Html.Attribute Msg)
getProfileHoverInteraction mode =
    case mode of
        Off ->
            [ onMouseEnter (HoverOn ProfileHover), onMouseOut (HoverOff ProfileHover) ]

        _ ->
            []


isInDetailedMode : Model -> Bool
isInDetailedMode model =
    case model.state of
        DetailedView _ ->
            True

        ProjectView ->
            False


projectRoute : Model -> Html Msg
projectRoute model =
    div [ class "projectView" ]
        [ div [ class "projectsTitle" ] [ text <| getText model.state ]
        , div [ class "projects" ]
            (List.map
                (drawProject model)
                model.list
            )
        ]


getText : ViewState -> String
getText state =
    case state of
        ProjectView ->
            "My Projects"

        DetailedView cell ->
            cell.project.title


projectText : Model -> Html Msg
projectText model =
    case model.state of
        DetailedView cell ->
            div
                ([ class "projectTextBox" ] ++ (Animation.render model.textStyle))
                [ div [ class "projectMainText" ]
                    [ h1 []
                        [ text cell.project.title
                        ]
                    , renderContents cell.project.contents
                    ]
                ]

        ProjectView ->
            --no div--
            div [ class "projectTextBox" ]
                [ div
                    ((Animation.render model.textStyle)
                        ++ [ class "projectMainText" ]
                    )
                    [ h1 [] [ text "" ]
                    , b [] [ text "" ]
                    ]
                ]


renderContents : List Content -> Html Msg
renderContents contents =
    div [ id "contentList" ]
        (map (renderAContent) contents)


renderAContent : Content -> Html Msg
renderAContent content =
    case content of
        Image im ->
            div [ class "contentImageWrapper" ]
                [ img [ class "contentImage", src im ] [] ]

        ImageWithText im txt ->
            div [ class "contentImageWrapper" ]
                [ img [ class "contentImage", src im ] []
                , Markdown.toHtml [ class "smallText" ] txt
                ]

        Text txt ->
            div []
                [ Markdown.toHtml [] txt ]



--This creates list elements from the project elements, it takes the position of the element because that is how we find it in the update


drawProject : Model -> ProjectCell -> Html Msg
drawProject model cell =
    let
        project =
            cell.project

        style =
            Animation.render cell.style

        closeButtonStyle =
            (Animation.render model.closeButtonStyle)

        start =
            style ++ [ classList [ ( "project", True ), ( "projectInList", not (isInDetailedMode model) ) ], onClick (ToggleDetailed cell) ]

        textDiv =
            projectText model

        hovering =
            [ onMouseEnter (HoverOn ProjectHover), onMouseOut (HoverOff ProjectHover) ]

        closeButton =
            img
                (closeButtonStyle
                    ++ [ class "closeButton"
                       , src "static/img/closeButton.svg"
                       ]
                    ++ hovering
                )
                []
    in
        case model.state of
            ProjectView ->
                div start [ div [ class "projectTitle" ] [], getImage (project.imagePath) ]

            DetailedView chosen ->
                if (chosen.project == cell.project) then
                    div ([ class "chosenProject" ] ++ start) [ closeButton, getImage (project.imagePath), textDiv ]
                else
                    div start [ getImage (project.imagePath) ]



--returns a clickable image, when you click it it runs Toggle which switches the image


getImage : String -> Html Msg
getImage image =
    img [ class "projectImage", src image, alt "error" ] []
