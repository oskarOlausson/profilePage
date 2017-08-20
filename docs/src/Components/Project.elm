module Components.Project exposing (..)

import String
import List exposing (map)


--union for three different modes the Cells (squares) can have


type Content
    = Image String --image path
    | Text String --text
    | ImageWithText String String --image path, explanation


type alias Project =
    { title : String --title
    , imagePath : String --image path
    , contents : List Content
    }


projectPicture : String -> String -> String -> List Content -> Project
projectPicture title folder image contents =
    Project title (loadImage folder image) (map (fixImages folder) contents)


fixImages : String -> Content -> Content
fixImages folder content =
    case content of
        Text _ ->
            content

        Image src ->
            Image (loadImage folder src)

        ImageWithText src text ->
            ImageWithText (loadImage folder src) text



--IMAGES--
--loads one image


loadImage : String -> String -> String
loadImage folder imgName =
    "static/img/" ++ (format folder) ++ imgName ++ ".png"


format : String -> String
format folderName =
    if String.isEmpty folderName then
        ""
    else if (not (String.endsWith "/" folderName)) then
        folderName ++ "/"
    else
        folderName



--loads all images into html


loadImages : String -> List String -> List String
loadImages folder imageNames =
    (List.map (\x -> (format folder) ++ x) imageNames)
