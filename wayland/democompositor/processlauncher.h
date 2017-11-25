/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef PROCESSLAUNCHER_H
#define PROCESSLAUNCHER_H

#include "apps/appentry.h"

#include <QObject>
#include <QProcess>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(procs)

/**
 * Transient class. Do not keep AppState beyond the
 * finished signal.
 */
class AppState {
    Q_GADGET
    Q_PROPERTY(QProcess *process MEMBER process CONSTANT)
    Q_PROPERTY(AppEntry appEntry MEMBER appEntry CONSTANT)
public:
    QProcess *process;
    AppEntry appEntry;
    QMetaObject::Connection finishedConn;
    QMetaObject::Connection errorOccurredConn;
    QMetaObject::Connection startedConn;
};

class WaylandProcessLauncher : public QObject
{
    Q_OBJECT

public:
    explicit WaylandProcessLauncher(QObject *parent = 0);
    ~WaylandProcessLauncher();
    Q_INVOKABLE void launch(const AppEntry &entry);

    Q_INVOKABLE QVariant appStateForPid(int pid) const;
    Q_INVOKABLE bool isRunning(const AppEntry& entry) const;
    Q_INVOKABLE void kill(const AppEntry& entry);
    Q_INVOKABLE void stop(const AppEntry& entry, int timeout_ms);

Q_SIGNALS:
    void appStarted(const AppState &appState);
    void appFinished(const AppState &appState, int exitCode, QProcess::ExitStatus exitStatus);
    void appNotStarted(const AppState& appState);

private:
    QVector<AppState> m_appStates;
};

Q_DECLARE_METATYPE(AppState)

#endif // PROCESSLAUNCHER_H
