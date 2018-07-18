//
//  SpeakerManager.swift
//  spotifySpike
//
//  Created by Nithin Gaddam on 7/17/18.
//  Copyright © 2018 Nithin Gaddam. All rights reserved.
//

import Foundation

extension Notification.Name {
    public struct SpeakerManager {
        public static let speakerFound = "SpeakerManager.didFindSpeaker"
        public static let speakerLost = "SpeakerManger.didLooseSpeaker"
        public static let speakerConnected = "SpeakerManager.didConnectSpeaker"
        public static let speakerDisconnected = "SpeakerManager.didDisconnectSpeaker"
        public static let speakerPaired = "SpeakerManager.didPairSpeaker"
        public static let speakerUnpaired = "SpeakerManager.didUnpairSpeaker"
        public static let speakerOpened = "SpeakerManager.didOpenSpeaker"
        public static let speakerClosed = "SpeakerManager.didCloseSpeaker"
        public static let speakerUpdated = "SpeakerManager.didUpdateSpeaker"
    }
}

class SpeakerManager {
    let activeDeviceManager: ActiveDeviceManager
    
    private(set) public var speakers = Set<Speaker>()
    
}
