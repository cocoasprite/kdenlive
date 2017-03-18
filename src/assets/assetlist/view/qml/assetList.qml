/***************************************************************************
 *   Copyright (C) 2017 by Nicolas Carion                                  *
 *   This file is part of Kdenlive. See www.kdenlive.org.                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) version 3 or any later version accepted by the       *
 *   membership of KDE e.V. (or its successor approved  by the membership  *
 *   of KDE e.V.), which shall act as a proxy defined in Section 14 of     *
 *   version 3 of the license.                                             *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. *
 ***************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

Rectangle {
    id: listRoot
    SystemPalette { id: activePalette }
    color: activePalette.window

    function assetType(){
        return isEffectList ? i18n("effects") : i18n("transitions");
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 2
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            spacing: 6
            ExclusiveGroup { id: filterGroup}
            ToolButton {
                id: showAll
                implicitWidth: 40
                implicitHeight: 40
                iconName: "show-all-effects"
                checkable:true
                exclusiveGroup: filterGroup
                tooltip: i18n('Show all ')+assetType()
                onClicked: {
                    assetlist.setFilterType("")
                }
            }
            ToolButton {
                id: showVideo
                visible: isEffectList
                implicitWidth: 40
                implicitHeight: 40
                iconName: "kdenlive-show-video"
                iconSource: 'qrc:///pics/kdenlive-show-video.svgz'
                checkable:true
                exclusiveGroup: filterGroup
                tooltip: i18n('Show all video effects')
                onClicked: {
                    assetlist.setFilterType("video")
                }
            }
            ToolButton {
                id: showAudio
                visible: isEffectList
                implicitWidth: 40
                implicitHeight: 40
                iconName: "kdenlive-show-audio"
                iconSource: 'qrc:///pics/kdenlive-show-audio.svgz'
                checkable:true
                exclusiveGroup: filterGroup
                tooltip: i18n('Show all audio effects')
                onClicked: {
                    assetlist.setFilterType("audio")
                }
            }
            ToolButton {
                id: showCustom
                visible: isEffectList
                implicitWidth: 40
                implicitHeight: 40
                iconName: "kdenlive-custom-effect"
                checkable:true
                exclusiveGroup: filterGroup
                tooltip: i18n('Show all custom effects')
                onClicked: {
                    assetlist.setFilterType("custom")
                }
            }
            Rectangle {
                //This is a spacer
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }
            ToolButton {
                id: showDescription
                implicitWidth: 40
                implicitHeight: 40
                iconName: "help-about"
                checkable:true
                checked: true
                tooltip: i18n('Show/hide description of the ') + assetName()
                onCheckedChanged:{
                    if (!checked) {
                        assetDescription.visible = false
                    }
                }
            }

        }
        TextField {
            id: searchInput
            Layout.fillWidth:true
            Image {
                id: clear
                source: 'image://icon/edit-clear'
                anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
                opacity: 0
                MouseArea {
                    anchors.fill: parent
                    onClicked: { searchInput.text = ''; searchInput.focus = true;  }
                }
            }
            states: State {
                name: "hasText"; when: searchInput.text != ''
                PropertyChanges { target: clear; opacity: 1 }
            }

            transitions: [
                Transition {
                    from: ""; to: "hasText"
                    NumberAnimation { properties: "opacity" }
                },
                Transition {
                    from: "hasText"; to: ""
                    NumberAnimation { properties: "opacity" }
                }
            ]
            onTextChanged: {
                assetlist.setFilterName(text)
            }
        }
        ItemSelectionModel {
            id: sel
            model: assetListModel
        }

        TreeView {
            id: treeView
            Layout.fillHeight: true
            Layout.fillWidth: true
            alternatingRowColors: false
            headerVisible: false
            backgroundVisible:false
            itemDelegate: RowLayout {
                Image{
                    visible: styleData.value != "root"
                    source: 'image://asseticon/' + styleData.value
                }
                Label{
                    text: assetlist.getName(styleData.index)
                }
            }

            TableViewColumn { role: "id"; title: "Name"; width: 200 }
            model: assetListModel
            selection: sel
            onClicked:{
                assetDescription.text = assetlist.getDescription(index)
            }
        }
        TextArea {
            id: assetDescription
            text: ""
            visible: false
            Layout.fillWidth: true
            states: State {
                name: "hasDescription"; when: assetDescription.text != '' && showDescription.checked
                PropertyChanges { target: assetDescription; visible: true}
            }

        }
    }

}