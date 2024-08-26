//
//  BMI088.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/12/24.
//

import Foundation
import SwiftUICharts

class Rocket : ObservableObject {
    @Published var logs = ""
    @Published var deltaTime = "-1"
    @Published var maxPosition : Double = 15
    
    @Published var rollKp : String = "10.0"
    @Published var rollKi : String = "0.0"
    @Published var rollKd : String = "0.0"
    @Published var pitchKp : String = "10.0"
    @Published var pitchKi : String = "0.0"
    @Published var pitchKd : String = "0.0"
    @Published var yawKp : String = "10.0"
    @Published var yawKi : String = "0.0"
    @Published var yawKd : String = "0.0"
        
    @Published var onPad = false
    @Published var tvcActive = false
    @Published var coasting = false
    @Published var parachuteOut = false
    @Published var touchdown = false
    
    @Published var yawData : [LineChartDataPoint] = []
    @Published var pitchData : [LineChartDataPoint] = []
    @Published var rollData : [LineChartDataPoint] = []
    
    @Published var servo0pos : [LineChartDataPoint] = []
    @Published var servo1pos : [LineChartDataPoint] = []

    @Published var yawPIDCommand : [LineChartDataPoint] = []
    @Published var pitchPIDCommand : [LineChartDataPoint] = []
    @Published var rollPIDCommand : [LineChartDataPoint] = []
    
    @Published var accelX : [LineChartDataPoint] = []
    @Published var accelY : [LineChartDataPoint] = []
    @Published var accelZ : [LineChartDataPoint] = []
    
    @Published var gyroX : [LineChartDataPoint] = []
    @Published var gyroY : [LineChartDataPoint] = []
    @Published var gyroZ : [LineChartDataPoint] = []

    @Published var altitude : [LineChartDataPoint] = []
    @Published var temperature : [LineChartDataPoint] = []
    @Published var pressure : [LineChartDataPoint] = []
    
    func addAccelX(accelX: Float) {
        self.accelX.append(LineChartDataPoint(value: Double(accelX), xAxisLabel: " ", description: "Acceleration X"))
    }
    
    func addAccelY(accelY: Float) {
        self.accelY.append(LineChartDataPoint(value: Double(accelY), xAxisLabel: " ", description: "Acceleration Y"))
    }
    
    func addAccelZ(accelZ: Float) {
        self.accelZ.append(LineChartDataPoint(value: Double(accelZ), xAxisLabel: " ", description: "Acceleration Z"))
    }
    
    func addGyroX(gyroX: Float) {
        self.gyroX.append(LineChartDataPoint(value: Double(gyroX), xAxisLabel: " ", description: "Gyroscope X"))
    }
    
    func addGyroY(gyroY: Float) {
        self.gyroY.append(LineChartDataPoint(value: Double(gyroY), xAxisLabel: " ", description: "Gyroscope Z"))
    }
    
    func addGyroZ(gyroZ: Float) {
        self.gyroZ.append(LineChartDataPoint(value: Double(gyroZ), xAxisLabel: " ", description: "Gyroscope Z"))
    }
    
    func addAltitude(altitude: Float) {
        self.altitude.append(LineChartDataPoint(value: Double(altitude), xAxisLabel: " ", description: "Altitude"))
    }
    
    func addTemperature(temperature: Float) {
        self.temperature.append(LineChartDataPoint(value: Double(temperature), xAxisLabel: " ", description: "°C"))
    }
    
    func addPressure(pressure: Float) {
        self.pressure.append(LineChartDataPoint(value: Double(pressure), xAxisLabel: " ", description: "Pascals"))
    }
    
    func addYaw(yaw: Float) {
        yawData.append(LineChartDataPoint(value: Double(yaw), xAxisLabel: " ", description: "Yaw"))
    }
    
    func addPitch(pitch: Float) {
        pitchData.append(LineChartDataPoint(value: Double(pitch), xAxisLabel: " ", description: "Y"))
    }
    
    func addRoll(roll: Float) {
        rollData.append(LineChartDataPoint(value: Double(roll), xAxisLabel: " ", description: "Z"))
    }
    
    func addServo0Pos(pos: Float) {
        servo0pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 0 Pos"))
    }
    
    func addServo1Pos(pos: Float) {
        servo1pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 1 Pos"))
    }
    
    
    func addYawCommand(cmd: Float) {
        yawPIDCommand.append(LineChartDataPoint(value: Double(cmd), xAxisLabel: " ", description: "Yaw Command"))
    }
    
    func addPitchCommand(cmd: Float) {
        pitchPIDCommand.append(LineChartDataPoint(value: Double(cmd), xAxisLabel: " ", description: "Pitch Command"))
    }
    
    func addRollCommand(cmd: Float) {
        rollPIDCommand.append(LineChartDataPoint(value: Double(cmd), xAxisLabel: " ", description: "Roll Command"))
    }
    
    func getAccelX() -> LineDataSet {
        return LineDataSet(dataPoints: accelX,
                           legendTitle: "m/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getAccelY() -> LineDataSet {
        return LineDataSet(dataPoints: accelY,
                           legendTitle: "m/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getAccelZ() -> LineDataSet {
        return LineDataSet(dataPoints: accelZ,
                           legendTitle: "m/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getGyroX() -> LineDataSet {
        return LineDataSet(dataPoints: gyroX,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getGyroY() -> LineDataSet {
        return LineDataSet(dataPoints: gyroY,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getGyroZ() -> LineDataSet {
        return LineDataSet(dataPoints: gyroZ,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getYaw() -> LineDataSet {
        return LineDataSet(dataPoints: yawData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getPitch() -> LineDataSet {
        return LineDataSet(dataPoints: pitchData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getRoll() -> LineDataSet {
        return LineDataSet(dataPoints: rollData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getServo0Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo0pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getServo1Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo1pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getYawCommand() -> LineDataSet {
        return LineDataSet(dataPoints: yawPIDCommand,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getPitchCommand() -> LineDataSet {
        return LineDataSet(dataPoints: pitchPIDCommand,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getRollCommand() -> LineDataSet {
        return LineDataSet(dataPoints: rollPIDCommand,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .purple), lineType: .line))
    }
    
    func getAltitude() -> LineDataSet {
        return LineDataSet(dataPoints: altitude,
                           legendTitle: "m",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getTemperature() -> LineDataSet {
        return LineDataSet(dataPoints: temperature,
                           legendTitle: "°C",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getPressure() -> LineDataSet {
        return LineDataSet(dataPoints: pressure,
                           legendTitle: "Pascals",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func resetBMI088() {
        accelX.removeAll()
        accelY.removeAll()
        accelZ.removeAll()
        gyroX.removeAll()
        gyroY.removeAll()
        gyroZ.removeAll()
    }
    
    func resetRotation() {
        yawData.removeAll()
        pitchData.removeAll()
        rollData.removeAll()
    }
    
    func resetServoPos() {
        servo0pos.removeAll()
        servo1pos.removeAll()
    }
    
    func resetPIDCommands() {
        yawPIDCommand.removeAll()
        pitchPIDCommand.removeAll()
        rollPIDCommand.removeAll()
    }
    
    func resetBMP390() {
        altitude.removeAll()
        temperature.removeAll()
        pressure.removeAll()
    }
    
    func clearLogs() {
        logs = ""
    }
    
    func reset() {
        resetRotation()
        resetServoPos()
        resetPIDCommands()
        resetBMP390()
        resetBMI088()
        clearLogs()
        deltaTime = "-1"
        onPad = false
        tvcActive = false
        coasting = false
        parachuteOut = false
        touchdown = false
    }
}
