module AnimationHelper exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (..)
import Components.UpdateMessages as Update exposing (..)
import Color exposing (..)
import Time exposing (..)


zIndex : Float -> Animation.Property
zIndex depth =
    Animation.custom "z-index" depth ""


type alias SpringProps =
    { stiffness : Float
    , damping : Float
    }


spring : SpringProps
spring =
    { stiffness = 600
    , damping = 85
    }


emptyStyle : Animation.Messenger.State Update.Msg
emptyStyle =
    styleWith (Animation.spring spring) initStyleProperties


startStyle : Animation.Messenger.State Update.Msg
startStyle =
    styleWith (Animation.spring spring) initStyleProperties



--profile pic --


profileBorderThickness : Float
profileBorderThickness =
    0.2


profileMarginBottom : Float
profileMarginBottom =
    0


profileNormalScale : Float
profileNormalScale =
    0.975


profilePicStartStyle : Animation.Messenger.State Update.Msg
profilePicStartStyle =
    styleWith (Animation.spring spring)
        [ width (percent 100)
        , borderTopLeftRadius (percent 60)
        , borderTopRightRadius (percent 60)
        , borderBottomLeftRadius (percent 60)
        , borderBottomRightRadius (percent 60)
        , borderWidth (Animation.rem profileBorderThickness)
        , exactly "border-style" "none"
        , borderColor (rgba 255 255 255 1)
        , scale profileNormalScale
        ]


profilePicNormal : Float -> Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profilePicNormal delay =
    Animation.interrupt
        [ Animation.wait (millisecond * delay)
        , Animation.to
            [ width (percent 100)
            , borderTopLeftRadius (percent 60)
            , borderTopRightRadius (percent 60)
            , borderBottomLeftRadius (percent 60)
            , borderBottomRightRadius (percent 60)
            , scale profileNormalScale
            ]
        , Animation.Messenger.send <| ProfileAnimationDone Off
        ]


profilePicHover : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profilePicHover =
    Animation.interrupt
        [ Animation.to
            [ scale 1
            ]
        ]


profilePicNoHover : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profilePicNoHover =
    Animation.interrupt
        [ Animation.to
            [ scale profileNormalScale
            ]
        ]


profilePicHidden : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profilePicHidden =
    Animation.interrupt
        [ Animation.to
            [ width (percent 0)
            , borderTopLeftRadius (percent 50)
            , borderTopRightRadius (percent 50)
            , borderBottomLeftRadius (percent 50)
            , borderBottomRightRadius (percent 50)
            , exactly "border-style" "none"
            , scale 1
            ]
        ]


profilePicExpanded : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profilePicExpanded =
    Animation.interrupt
        [ Animation.to
            [ width (percent 100)
            , borderTopLeftRadius (percent 15)
            , borderTopRightRadius (percent 15)
            , borderBottomLeftRadius (percent 0)
            , borderBottomRightRadius (percent 0)
            , borderWidth (Animation.rem 0)
            , exactly "border-style" "none"
            , scale 1
            ]
        ]



--profile text--


profileTextProperties : List Animation.Property
profileTextProperties =
    [ Animation.color (Color.rgba 0 0 0 0)
    , Animation.opacity 0
    , Animation.padding (Animation.rem 0)
    , Animation.width (percent 100)
    , Animation.paddingTop (Animation.rem 0.5)
    , Animation.custom "max-height" 0 "rem"
    , zIndex -1
    ]


profileTextFastGone : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profileTextFastGone =
    Animation.interrupt
        [ Animation.set
            profileTextProperties
        ]


profileTextStart : Animation.Messenger.State Update.Msg
profileTextStart =
    styleWith (Animation.spring spring)
        profileTextProperties


profileTextAppear : Float -> Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profileTextAppear delay =
    Animation.interrupt
        [ Animation.wait (millisecond * delay)
        , Animation.set
            [ Animation.width (percent 100) ]
        , Animation.to
            [ Animation.opacity 1
            , Animation.color (Color.rgba 0 0 0 1)
            , Animation.padding (Animation.rem 0.2)
            , Animation.marginTop (Animation.percent 0)
            , Animation.marginBottom (Animation.percent 0)
            , Animation.custom "max-height" 50 "rem"
            ]
        , Animation.Messenger.send <| ProfileAnimationDone Done
        ]


profileTextDisappear : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
profileTextDisappear =
    Animation.interrupt
        [ Animation.to
            profileTextProperties
        ]



--project text--


textStartStyle : Animation.Messenger.State Update.Msg
textStartStyle =
    styleWith (Animation.spring spring)
        [ Animation.opacity 0.0
        , Animation.marginTop (Animation.rem -5)
        , zIndex -1
        ]


textToVisible : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
textToVisible =
    Animation.interrupt
        [ Animation.to
            [ Animation.opacity 1.0
            , Animation.marginTop (Animation.rem 0)
            ]
        , Animation.set [ zIndex 1 ]
        ]


textToHidden : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
textToHidden =
    Animation.interrupt
        [ Animation.set
            [ Animation.opacity 0.0
            , Animation.marginTop (Animation.rem -5)
            , zIndex -1
            ]
        ]



-- chosen project --


closeButtonStyle : List Animation.Property
closeButtonStyle =
    [ Animation.width (Animation.rem 0)
    , Animation.borderWidth (Animation.rem 0)
    , Animation.borderColor (Color.rgb 255 255 255)
    , Animation.exactly "border-style" "solid"
    ]


closeButtonStartStyle : Animation.Messenger.State Update.Msg
closeButtonStartStyle =
    styleWith (Animation.spring spring)
        closeButtonStyle


closeButtonHover : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
closeButtonHover =
    Animation.interrupt
        [ Animation.to
            [ Animation.width (Animation.rem 4)
            , Animation.borderWidth (Animation.rem 0.2)
            ]
        ]


closeButtonNormal : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
closeButtonNormal =
    Animation.interrupt
        [ Animation.to
            [ Animation.width (Animation.rem 3)
            , Animation.borderWidth (Animation.rem 0)
            ]
        ]


closeButtonHidden : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
closeButtonHidden =
    Animation.interrupt
        [ Animation.to
            closeButtonStyle
        ]


initStyleProperties : List Animation.Property
initStyleProperties =
    [ Animation.width (Animation.rem 22.0)
    , Animation.height (Animation.rem 16.5)
    , Animation.opacity 1
    , Animation.marginLeft (Animation.rem 0.5)
    , Animation.marginRight (Animation.rem 0.5)
    ]


projectNormalSize : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
projectNormalSize =
    Animation.interrupt
        [ Animation.set
            [ Animation.opacity 1 ]
        , Animation.to
            initStyleProperties
        ]


projectBigSize : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
projectBigSize =
    Animation.interrupt
        [ Animation.set
            [ Animation.opacity 1 ]
        , Animation.to
            [ Animation.width (Animation.rem 44.0)
            , Animation.height (Animation.rem 33.0)
            , Animation.marginLeft (Animation.rem 0)
            , Animation.marginRight (Animation.rem 0)
            ]
        , Animation.Messenger.send BringOutText
        ]


projectNothingSize : Animation.Messenger.State Update.Msg -> Animation.Messenger.State Update.Msg
projectNothingSize =
    Animation.interrupt
        [ Animation.to
            [ Animation.width (Animation.rem 0)
            , Animation.height (Animation.rem 0)
            , Animation.marginLeft (Animation.rem 0)
            , Animation.marginRight (Animation.rem 0)
            ]
        , Animation.set
            [ Animation.opacity 0 ]
        ]
