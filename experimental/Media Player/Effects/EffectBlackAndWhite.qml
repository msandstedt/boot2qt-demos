/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Effect {
    parameters: ListModel {
        ListElement {
            name: "threshold"
            value: 0.5
        }
    }

    // Transform slider values, and bind result to shader uniforms
    property real threshold: parameters.get(0).value

    fragmentShaderSrc: "uniform float threshold;
                        uniform float dividerValue;

                        uniform sampler2D source;
                        uniform lowp float qt_Opacity;
                        varying vec2 qt_TexCoord0;

                        void main()
                        {
                            vec2 uv = qt_TexCoord0.xy;
                            vec4 orig = texture2D(source, uv);
                            vec3 col = orig.rgb;
                            float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
                            y = y < threshold ? 0.0 : 1.0;
                            if (uv.x < dividerValue)
                                gl_FragColor = qt_Opacity * vec4(y, y, y, 1.0);
                            else
                                gl_FragColor = qt_Opacity * orig;
                        }"
}
