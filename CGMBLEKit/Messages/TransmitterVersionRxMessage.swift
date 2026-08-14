//
//  TransmitterVersionRxMessage.swift
//  xDripG5
//
//  Created by Nate Racklyeft on 9/29/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation


struct TransmitterVersionRxMessage: TransmitterRxMessage {
    let status: UInt8
    let firmwareVersion: [UInt8]
    let transmitterExpiryInDays: UInt16

    var isAnubis: Bool {
        transmitterExpiryInDays == 180
    }

    init?(data: Data) {
        guard data.count == 19 && data.isCRCValid else {
            return nil
        }

        guard data.starts(with: .transmitterVersionRx) else {
            return nil
        }

        status = data[1]
        firmwareVersion = data[2..<6].map { $0 }
        transmitterExpiryInDays = (UInt16(data[14]) << 8) | UInt16(data[13])
    }

}
