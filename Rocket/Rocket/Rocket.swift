//
//  BMI088.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/12/24.
//

import Foundation
import SwiftUICharts

class Rocket : ObservableObject {
    @Published var rollKp : String = "50.0"
    @Published var rollKi : String = "0.0"
    @Published var rollKd : String = "0.0"
    @Published var pitchKp : String = "50.0"
    @Published var pitchKi : String = "0.0"
    @Published var pitchKd : String = "0.0"
    @Published var yawKp : String = "50.0"
    @Published var yawKi : String = "0.0"
    @Published var yawKd : String = "0.0"
    
    @Published var logs = "Logs: "
    
    @Published var armed = false
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

    @Published var altitude : [LineChartDataPoint] = []
    
    func addAltitude(altitude: Float) {
        self.altitude.append(LineChartDataPoint(value: Double(altitude), xAxisLabel: " ", description: "Altitude"))
    }
    
    func addYaw(yaw: Float) {
        yawData.append(LineChartDataPoint(value: Double(yaw * 57.29), xAxisLabel: " ", description: "Yaw"))
    }
    
    func addPitch(pitch: Float) {
        pitchData.append(LineChartDataPoint(value: Double(pitch * 57.29), xAxisLabel: " ", description: "Y"))
    }
    
    func addRoll(roll: Float) {
        rollData.append(LineChartDataPoint(value: Double(roll * 57.29), xAxisLabel: " ", description: "Z"))
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
    
    func resetAltitude() {
        altitude.removeAll()
    }
}
