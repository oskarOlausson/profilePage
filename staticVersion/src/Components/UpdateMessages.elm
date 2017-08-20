module Components.UpdateMessages exposing (..)

import Components.Project exposing (Project)
import Animation exposing (Msg)
import Animation.Messenger exposing (..)


--This is the messages we send to the update function,
--I have isolated them in their own file because two modules need them (Main and AnimationHelper) but they can't import each other so this is the only solution


type Msg
    = NoOp
    | ToggleDetailed ProjectCell
    | Animate Animation.Msg
    | BringOutText
    | HoverOn HoverType
    | HoverOff HoverType
    | ProfileClick
    | ProfileAnimationDone ProfilePicMode


type alias ProjectCell =
    { project : Project
    , style : Animation.Messenger.State Msg
    }


type HoverType
    = ProjectHover
    | ProfileHover


type ProfilePicMode
    = Off
    | Animating
    | Done


type alias ProfilePic =
    { style : Animation.Messenger.State Msg
    , mode : ProfilePicMode
    , textStyle : Animation.Messenger.State Msg
    }
