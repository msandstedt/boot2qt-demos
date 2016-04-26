/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Effect {
    fragmentShaderSrc: "uniform float dividerValue;
                        uniform sampler2D source;
                        uniform lowp float qt_Opacity;
                        varying vec2 qt_TexCoord0;

                        void main()
                        {
                            vec2 uv = qt_TexCoord0.xy;
                            vec4 orig = texture2D(source, uv);
                            vec3 col = orig.rgb;
                            float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
                            y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
                            if (y == 0.5)
                                col = vec3(0.8, 0.0, 0.0);
                            else if (y == 1.0)
                                col = vec3(0.9, 0.9, 0.0);
                            else
                                col = vec3(0.0, 0.0, 0.0);
                            if (uv.x < dividerValue)
                                gl_FragColor = qt_Opacity * vec4(col, 1.0);
                            else
                                gl_FragColor = qt_Opacity * orig;
                        }"
}
