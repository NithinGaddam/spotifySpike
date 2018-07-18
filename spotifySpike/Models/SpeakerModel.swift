//
//  SpeakerModel.swift
//  spotifySpike
//
//  Created by Nithin Gaddam on 7/17/18.
//  Copyright © 2018 Nithin Gaddam. All rights reserved.
//

import Foundation

enum SpeakerModel: String {
    case boom2 = "BOOM 2"
    case megaboom = "MEGABOOM"
    case boom3 = "BOOM 3"
    case megaboom3 = "MEGABOOM 3"
    case unknown = "UNKNOWN"
}

extension SpeakerModel {
    var analyticsModelName: String {
        switch self {
        case .boom2:
            return "Maximus"
        case .megaboom:
            return "Titus"
        case .boom3:
            return "Mendocino"
        case .megaboom3:
            return "Humboldt"
        case .unknown:
            return "UNKNOWN"
        }
    }
}
