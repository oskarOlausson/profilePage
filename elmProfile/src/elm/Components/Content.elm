module Components.Content exposing (faces, sportswik, voice, hiki, profileText)

import Components.Project exposing (..)
import Components.MainText exposing (..)


faces : Project
faces =
    projectPicture
        "Neural Network"
        "faces"
        "emotions43"
        [ Text facesText
        , ImageWithText "michevious" "They were (to make it harder) rotated randomly. (This one is michevious.)"
        , Text facesText2
        ]


sportswik : Project
sportswik =
    projectPicture
        "Sportswik"
        "sportswik"
        "main"
        [ Text sportswikText
        , ImageWithText "plan" "Early planning work"
        , Text sportswikText2
        , ImageWithText "workshop" "Workshop with Sportswiks VD"
        , Text sportswikText3
        ]


voice : Project
voice =
    projectPicture
        "Siri vs Google"
        "voice"
        "siri_google"
        [ Text voiceText
        ]


hiki : Project
hiki =
    projectPicture
        "The Social Game"
        "hiki"
        "paper"
        [ Text hikiText
        , Text ""
        , ImageWithText "mat" "One of the games where four players controlled the red mat together to get it to the gift."
        , Text "It was important for us that the game made the players communicate with eachother, so we made controllers with LED-displays so we could give individual players information. And when only one player has information that all need it makes it easier for that player to speak out."
        , ImageWithText "controller" "The custom controllers."
        , Text "One of these games that used the LED-displays was the club line game."
        , ImageWithText "club" "Club line game, one of the games we created."
        , Text "This game asks the player to order themselves in the club line, to help them do this they each get a clue on their controller."
        , Text """We decided to call the game <span style="color:#cc3579">**GROW**</span>. This project was very stressful but we won two prices at the exhibition at the end so that somewhat makes up for the stressed holidays we had."""
        ]


profileText : String
profileText =
    """Hi, I study Interaction & Design at Umeå University in Sweden.<br/>
I currently study in my fourth year.<br/><br/>
    I really enjoy rapid prototyping and algorithm work.
    If you want to get in touch, my email is at the top of the page.
        Sincerly, Oskar Olausson.
"""
