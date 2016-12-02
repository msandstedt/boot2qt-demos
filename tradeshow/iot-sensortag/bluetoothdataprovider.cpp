/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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
#include "bluetoothdataprovider.h"
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(boot2QtDemos)

BluetoothDataProvider::BluetoothDataProvider(QString id, QObject *parent)
    : SensorTagDataProvider(id, parent)
    , activeDevice(Q_NULLPTR)
    , m_smaSamples(0)
{
}

BluetoothDataProvider::~BluetoothDataProvider()
{

}

bool BluetoothDataProvider::startDataFetching()
{
    qCDebug(boot2QtDemos) << Q_FUNC_INFO;
    if (activeDevice) {
        connect(activeDevice, &BluetoothDevice::statusUpdated, this, [](const QString& statusMsg) { qCDebug(boot2QtDemos) << "----------" << statusMsg; });
        connect(activeDevice, &BluetoothDevice::stateChanged, this, &BluetoothDataProvider::updateState);
        connect(activeDevice, &BluetoothDevice::temperatureChanged, this, &BluetoothDataProvider::temperatureReceived);
        connect(activeDevice, &BluetoothDevice::barometerChanged, this, &BluetoothDataProvider::barometerReceived);
        connect(activeDevice, &BluetoothDevice::humidityChanged, this, &BluetoothDataProvider::humidityReceived);
        connect(activeDevice, &BluetoothDevice::lightIntensityChanged, this, &BluetoothDataProvider::lightIntensityReceived);
        connect(activeDevice, &BluetoothDevice::motionChanged, this, &BluetoothDataProvider::motionReceived);
        timer.setInterval(1000);
        timer.setSingleShot(true);
        connect(&timer, &QTimer::timeout, this, &BluetoothDataProvider::startServiceScan);
        timer.start();
        qCDebug(boot2QtDemos) << "Active Device is now " << activeDevice->getName() << " at "<< activeDevice->getAddress();
    }
    return true;
}

void BluetoothDataProvider::endDataFetching()
{
}

void BluetoothDataProvider::startServiceScan()
{
    qCDebug(boot2QtDemos)<<Q_FUNC_INFO;
    if (activeDevice)
        activeDevice->scanServices();
}

void BluetoothDataProvider::temperatureReceived(double temperature)
{
    if (temperature == irTemperature)
        return;
    irTemperature = temperature;
    emit infraredCelsiusTemperatureChanged();
}

void BluetoothDataProvider::barometerReceived(double temperature, double barometer)
{
    barometerCelsiusTemperature = temperature;
    emit barometerCelsiusTemperatureChanged();
    barometerTemperatureAverage = (temperature + m_smaSamples * barometerTemperatureAverage)  / (m_smaSamples + 1);
    m_smaSamples++;
    emit barometerCelsiusTemperatureAverageChanged();
    // Use a limited number of samples. It will eventually give wrong avg values, but this is just a demo...
    if (m_smaSamples > 10000)
        m_smaSamples = 0;
    barometerHPa = barometer;
    emit barometer_hPaChanged();
}

void BluetoothDataProvider::humidityReceived(double humidity)
{
    this->humidity = humidity;
    emit relativeHumidityChanged();
}
void BluetoothDataProvider::lightIntensityReceived(double lightIntensity)
{
    lightIntensityLux = lightIntensity;
    emit lightIntensityChanged();
}

float BluetoothDataProvider::countRotationDegrees(double degreesPerSecond, quint64 milliseconds)
{
    const quint32 mseconds = milliseconds;
    const float seconds = ((float)mseconds)/float(1000);
    return ((float)degreesPerSecond) * seconds;
}

void BluetoothDataProvider::motionReceived(MotionSensorData &data)
{
    qCDebug(boot2QtDemos) << Q_FUNC_INFO << ":" << data.gyroScope_x << "," << data.msSincePreviousData
                          << "=" << countRotationDegrees(data.gyroScope_x, data.msSincePreviousData);
    gyroscopeX_degPerSec = data.gyroScope_x;
    gyroscopeY_degPerSec = data.gyroScope_y;
    gyroscopeZ_degPerSec = data.gyroScope_z;
    rotation_x += countRotationDegrees(data.gyroScope_x, data.msSincePreviousData);
    rotation_y += countRotationDegrees(data.gyroScope_y, data.msSincePreviousData);
    rotation_z += countRotationDegrees(data.gyroScope_z, data.msSincePreviousData);
    if (rotation_x > 360)
        rotation_x -= 360;
    else if (rotation_x < 0)
        rotation_x += 360;
    if (rotation_y > 360)
        rotation_y -= 360;
    else if (rotation_y < 0)
        rotation_y += 360;
    if (rotation_z > 360)
        rotation_z -= 360;
    else if (rotation_z < 0)
        rotation_z += 360;
    emit gyroscopeDegPerSecChanged();
    emit rotationXChanged();
    emit rotationYChanged();
    emit rotationZChanged();
    // Signal that all values have changed, for easier
    // value change handling in clients
    emit rotationValuesChanged();
    accelometer_mG_xAxis = data.accelometer_x;
    accelometer_mG_yAxis = data.accelometer_y;
    accelometer_mG_zAxis = data.accelometer_z;
    emit accelometerGChanged();
    magnetometerMicroT_xAxis = data.magnetometer_x;
    magnetometerMicroT_yAxis = data.magnetometer_y;
    magnetometerMicroT_zAxis = data.magnetometer_z;
    emit magnetometerMicroTChanged();
}

QString BluetoothDataProvider::sensorType() const
{
    return QString("Bluetooth data");
}

QString BluetoothDataProvider::versionString() const
{
    return QString("1.0");
}

void BluetoothDataProvider::updateState()
{
    switch (activeDevice->state()) {
    case BluetoothDevice::Disconnected:
        setState(Disconnected);
        break;
    case BluetoothDevice::Connected:
        setState(Connected);
        break;
    case BluetoothDevice::Error:
        setState(Error);
        break;
    default:
        break;
    }
}

void BluetoothDataProvider::bindToDevice(BluetoothDevice *device)
{
    activeDevice = device;
    startDataFetching();
}

BluetoothDevice *BluetoothDataProvider::device()
{
    return activeDevice;
}
