/*
 * SPDX-FileCopyrightText: 2026 midnightonyx
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "#080709"

        Image {
            anchors.fill: parent
            source: Qt.resolvedUrl("../images/midnight-manor.png")
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            smooth: true
            asynchronous: true
            cache: true
        }

        FogLayer {
            anchors.fill: parent

            source: Qt.resolvedUrl("../images/midnight-fog.png")

            fogOpacity: 0.30
            fogScale: 0.40
            verticalPosition: 0.67
            driftDuration: 89000
        }

    }
}
