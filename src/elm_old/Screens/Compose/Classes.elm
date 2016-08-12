module Screens.Compose.Classes exposing (..)


type Classes
    = Container
    | UserBanner
    | UserImageContainer
    | UserImage
    | TextInput
    | PostButtonContainer
    | PostButton
    | PostButtonDisabled
    | ResultIconContainer
    | ContentContainer
    | ResultInfo
    | ResultText
    | ResultButtonsContainer
    | ResultButton
    | LoadingContainer
    | LoadingIcon


cssNamespace : String
cssNamespace =
    "Compose"
