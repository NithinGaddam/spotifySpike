//
//  Speaker.swift
//  spotifySpike
//
//  Created by Nithin Gaddam on 7/17/18.
//  Copyright © 2018 Nithin Gaddam. All rights reserved.
//

import Foundation

enum AdvertisementStatusFlag: UInt8 {
    case poweredOff = 0x00
    case OnNotStreamingDisconnected = 0x20
    case OnNotStreamingConnected = 0x40
}

enum ConnectionType: String {
    case bt = "Classic"
    case ble = "BLE"
    case unkown = "UNKNOWN"
}

enum SpeakerPowerState {
    case on
    case off
    case changing
    case unknown
}

class Speaker {
    let model: SpeakerModel
    var isSupported: Bool {
        switch model {
        case .boom3, .megaboom3:
            return true
        default:
            return  false
        }
    }
    
    var connectionType: ConnectionType = .unkown
    
    let colorCode: UInt16
    var displayName: String {
        return speakerName == nil ? model.rawValue : speakerName!
    }
    
    var speakerName: String?
    
    var firmwareVersion: String?
    var serialNumber: UInt?
    
    var isPaired: Bool = false
    var isOpened: Bool = false
    
    var isPairedToAnotherDevice:Bool? {
        var result: Bool? = nil
        if let scanResponse = bleDevice?.scanResponse {
            let flags = (scanResponse as NSData).extractUint8(atOffset: FLAGS_OFFSET)
            let statusFlag = flags & FLAG_MASK.STREAMING_BROADCAST.rawValue
            result = !isOpened && statusFlag != AdvertisementStatusFlag.poweredOff.rawValue && statusFlag != AdvertisementStatusFlag.OnNotStreamingDisconnected.rawValue
        }
        return result
    }
    
    //MARK: Power state
    var powerState: HHSpeakerPowerStatwe = .unkown
    var isPoweredOn: Bool {
        return powerState == .on
    }
    
    var isSleeping :Bool {
        return powerState == .on
    }
    
    var isSleeping: Bool {
        return !isOpened && bleDevice != nil
    }
    
    var chargeLevel:UInt16? {
        if let device = bleDevice {
            return device.chargeLevel
        }
        else if let device = btDevice {
            return device.chargeLevel
        }
        else {
            return nil
        }
    }
    
    var address: Data
    var btDevice:UEDevice?
    
    private init(model: SpeakerModel,
                 colorCode: UInte16,
                 addresss: Data,
                 powerState: SpeakerPowerState = .unknown,
                 isPaired: Bool = false,
                 isOpened: Bool = false) {
        
        self.model = model
        self.colorCode = colorCode
        self.powerState = powerState
        self.isPaired = isPaired
        self.isOpened = isOpened
        
    }
    
    convenience init(btDevice:UEDevice,
                     address: Data,
                     powerState: SpeakerPowerState = .unknown,
                     isPaired: Bool = false,
                     isOpened: Bool = false) {
        let colorCode = (bleDevice.scanResponse as NSData).extractUint16(atOffSet: COLOR_OFFSET)
        let model = Speaker.modelForColorCode(colorCode)
        self.init(model: model, colorCode: colorcode, address: address, powerState: powerState, isPaired: isPaired, isOpened: isOpened)
        self.bleDevice = bleDevice
        self.connectionType = .ble
        setupSerialNumber()
        setupFirmwareVersion()
        update()
    }
    
    static func modelForColorCode(_ colorCode:UInt16) -> SpeakerModel {
        var result = SpeakerModel.unknown
        let modelString = UEDeviceColorManager.shared().getAttributesForColorCode(colorCode)?.type
        
        switch modelString {
        case "Maximus":
            result = .boom2
        
        case "Mendacino":
            result = .boom3
            
        case "Humboldt":
            result = .megaboom3
            
        default:
            result = .boom3
        }
        
        return result
    }
    
    func update() {
        if let bleDevice = bleDevice, bleDevice.scanResponse.count > FLAGS_OFFSET {
            let flags = (bleDevice.scanResonse as NSData).extractUint8(atOffset: FLAGS_OFFSET)
            let isPoweredOff = (flags & FLAGS_MASK.STREAMING_BROADCAST.rawValue) == AdvertisementStatusFlag.poweredOff.rawValue
            powerState = isPoweredOff ? .off : .on
        }
    }
}

extension Speaker {
    func setupFirmwareVersion() {
        bleDevice?.queryFirmwareVersion({ (data, success) in
            if success, let data = data as NSData? {
                self.firmwareVersion = String(format: "%d.%d.%d", data.extractUint8(atOffset: 0), data.extractUint8(atOffset: 1),
                                              data.extractUint8(atOffset: 2))
            }
        })
    }
    
    func setupSerialNumber() {
        bleDevice?.querySerialNumber({ (data, sucess) in
            if success, let data = data {
                self.serialNumber = UInt(String(data: data, encoding: String.Encoding.utf8) ?? "0")
            }
        })
    }
}


