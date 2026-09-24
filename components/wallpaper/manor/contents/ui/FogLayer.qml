/*
 * SPDX-FileCopyrightText: 2026 midnightonyx
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: root

    property url source
    property real fogOpacity: 0.30
    property real fogScale: 0.50
    property real verticalPosition: 0.50
    property int driftDuration: 90000

    readonly property real tileAspectRatio: 2000 / 667
    readonly property real tileHeight: root.height * root.fogScale
    readonly property real tileWidth: tileHeight * root.tileAspectRatio

    readonly property bool imagesReady:
        fogA.status === Image.Ready &&
        fogB.status === Image.Ready &&
        fogC.status === Image.Ready

    clip: true

    Item {
        id: drift

        y: root.height * root.verticalPosition
        width: root.tileWidth * 3
        height: root.tileHeight

        Image {
            id: fogA

            x: 0
            y: 0
            width: root.tileWidth
            height: root.tileHeight

            source: root.source
            fillMode: Image.Stretch
            opacity: root.fogOpacity

            smooth: true
            asynchronous: false
            cache: true
        }

        Image {
            id: fogB

            x: root.tileWidth
            y: 0
            width: root.tileWidth
            height: root.tileHeight

            source: root.source
            fillMode: Image.Stretch
            opacity: root.fogOpacity

            smooth: true
            asynchronous: false
            cache: true
        }

        Image {
            id: fogC

            x: root.tileWidth * 2
            y: 0
            width: root.tileWidth
            height: root.tileHeight

            source: root.source
            fillMode: Image.Stretch
            opacity: root.fogOpacity

            smooth: true
            asynchronous: false
            cache: true
        }

        NumberAnimation on x {
            from: -root.tileWidth / 2
            to: -(root.tileWidth * 1.5)

            duration: root.driftDuration
            loops: Animation.Infinite
            easing.type: Easing.Linear

            running: root.imagesReady
        }
    }
}