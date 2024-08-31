import Foundation
import SwiftUICharts

class EDF : ObservableObject {
    @Published var edfPower : Double = 50
    
    @Published var rollKp : String = "2.0"
    @Published var rollKi : String = "0.0"
    @Published var rollKd : String = "0.0"
    @Published var pitchKp : String = "2.0"
    @Published var pitchKi : String = "0.0"
    @Published var pitchKd : String = "0.0"
    @Published var yawKp : String = "2.0"
    @Published var yawKi : String = "0.0"
    @Published var yawKd : String = "0.0"
    
    @Published var yawData : [LineChartDataPoint] = []
    @Published var pitchData : [LineChartDataPoint] = []
    @Published var rollData : [LineChartDataPoint] = []
    @Published var yawVelocityData : [LineChartDataPoint] = []
    
    @Published var servo0pos : [LineChartDataPoint] = []
    @Published var servo1pos : [LineChartDataPoint] = []
    @Published var servo2pos : [LineChartDataPoint] = []
    @Published var servo3pos : [LineChartDataPoint] = []
    
    @Published var yawPIDCommand : [LineChartDataPoint] = []
    @Published var pitchPIDCommand : [LineChartDataPoint] = []
    @Published var rollPIDCommand : [LineChartDataPoint] = []
    
    func addYawVelocity(yawVelocity: Float) {
        yawVelocityData.append(LineChartDataPoint(value: Double(yawVelocity), xAxisLabel: " ", description: "Yaw"))
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
    
    func addServo2Pos(pos: Float) {
        servo2pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 2 Pos"))
    }
    
    func addServo3Pos(pos: Float) {
        servo3pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 3 Pos"))
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
    
    func getYawVelocity() -> LineDataSet {
        return LineDataSet(dataPoints: yawVelocityData,
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
    
    func getServo2Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo2pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getServo3Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo3pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .purple), lineType: .line))
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
    
    func resetRotation() {
        yawData.removeAll()
        pitchData.removeAll()
        rollData.removeAll()
        yawVelocityData.removeAll()
    }
    
    func resetServoPos() {
        servo0pos.removeAll()
        servo1pos.removeAll()
        servo2pos.removeAll()
        servo3pos.removeAll()
    }
    
    func resetPIDCommands() {
        yawPIDCommand.removeAll()
        pitchPIDCommand.removeAll()
        rollPIDCommand.removeAll()
    }
    
    func resetEDF() {
        edfPower = 50
        resetRotation()
        resetServoPos()
        resetPIDCommands()
    }
}
