module Player exposing (play, redo, doCtrlX, doCtrlV, doCtrlC)

import Scenario exposing (Msg(..))
import Model
import PlayerDataModel
import Identifier exposing (Identifier)
import DataModelActions
import DataModel
import ModelManagement


isDataMsg : Msg -> Bool
isDataMsg msg =
    case msg of
        CtrlC _ ->
            True

        CtrlV _ ->
            True

        CtrlX _ ->
            True

        _ ->
            False


playOne : Msg -> Model.Model -> Model.Model
playOne msg model =
    let
        newModel =
            case (isDataMsg msg) of
                False ->
                    let
                        newDataModel =
                            PlayerDataModel.playOne msg model.dataModel
                    in
                        { model | dataModel = newDataModel }

                True ->
                    case msg of
                        CtrlC id ->
                            doCtrlC id model

                        CtrlX id ->
                            doCtrlX id model

                        CtrlV m_id ->
                            doCtrlV m_id model

                        _ ->
                            model
    in
        newModel


play : Scenario.Model -> Model.Model -> Model.Model
play list model =
    case list of
        x :: xs ->
            play xs (playOne x model)

        [] ->
            model


redo : Scenario.RedoModel -> Model.Model -> Model.Model
redo m_redo model =
    case m_redo of
        Just x ->
            playOne x model

        Nothing ->
            model
