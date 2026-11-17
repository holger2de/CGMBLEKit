//
//  SessionStartTxMessage.swift
//  xDripG5
//
//  Created by Nathan Racklyeft on 3/26/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation

struct DexcomCalibrationParameters {
    let parameter1: Int16
    let parameter2: Int16

    init?(sensorCode: String?) {
        guard let sensorCode = sensorCode else {
            parameter1 = 0
            parameter2 = 0
            return
        }

        switch sensorCode {
        case "0000":
            parameter1 = 0
            parameter2 = 0
        case "5915", "9759":
            parameter1 = 3100
            parameter2 = 3600
        case "5917", "9357":
            parameter1 = 3000
            parameter2 = 3500
        case "5931", "9137":
            parameter1 = 2900
            parameter2 = 3400
        case "5937", "7197":
            parameter1 = 2800
            parameter2 = 3300
        case "5951", "9517":
            parameter1 = 3100
            parameter2 = 3500
        case "5955", "9179":
            parameter1 = 3000
            parameter2 = 3400
        case "7171", "7539":
            parameter1 = 2700
            parameter2 = 3300
        case "9117", "7135":
            parameter1 = 2700
            parameter2 = 3200
        case "9159", "5397":
            parameter1 = 2600
            parameter2 = 3200
        case "9311", "5391":
            parameter1 = 2600
            parameter2 = 3100
        case "9371", "5375":
            parameter1 = 2500
            parameter2 = 3100
        case "9515", "5795":
            parameter1 = 2500
            parameter2 = 3000
        case "9551", "5317":
            parameter1 = 2400
            parameter2 = 3000
        case "9577", "5177":
            parameter1 = 2400
            parameter2 = 2900
        case "9713", "5171":
            parameter1 = 2300
            parameter2 = 2900
        default:
            return nil
        }
    }
}


struct SessionStartTxMessage: RespondableMessage {
    typealias Response = SessionStartRxMessage

    /// Time since activation in Dex seconds
    let startTime: UInt32

    /// Time in seconds since Unix Epoch
    let secondsSince1970: UInt32

    /// Optional G6 sensor calibration parameters.
    let calibrationParameters: DexcomCalibrationParameters?

    init(
        startTime: UInt32,
        secondsSince1970: UInt32,
        calibrationParameters: DexcomCalibrationParameters? = nil
    ) {
        self.startTime = startTime
        self.secondsSince1970 = secondsSince1970
        self.calibrationParameters = calibrationParameters
    }

    var data: Data {
        var data = Data(for: .sessionStartTx)
        data.append(startTime)
        data.append(secondsSince1970)

        if let calibrationParameters = calibrationParameters,
           calibrationParameters.parameter1 != 0
        {
            data.append(calibrationParameters.parameter1)
            data.append(calibrationParameters.parameter2)
        }

        return data.appendingCRC()
    }
}
