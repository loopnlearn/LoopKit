//
//  SetBolusError.swift
//  LoopKit
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import Foundation


public enum SetBolusError: Error {
    case certain(LocalizedError)
    case uncertain(LocalizedError)
}


extension SetBolusError: LocalizedError {
    public func errorDescriptionWithUnits(_ units: Double) -> String {
        let format: String

        switch self {
        case .certain:
            format = LocalizedString("%1$@ U bolus failed", comment: "Describes a certain bolus failure (1: size of the bolus in units)")
        case .uncertain:
            format = LocalizedString("%1$@ U bolus may not have succeeded", comment: "Describes an uncertain bolus failure (1: size of the bolus in units)")
        }

        return String(format: format, NumberFormatter.localizedString(from: NSNumber(value: units), number: .decimal))
    }

    // returns the localized description for the failure reason
    public var failureReason: String? {
        switch self {
        case .certain(let error):
            return error.localizedDescription
        case .uncertain(let error):
            return error.localizedDescription
        }
    }

    // returns an approproate recovery suggestion based on the certainty and the underlying recovery suggestion
    public var recoverySuggestion: String? {
        switch self {
        case .certain(let error):
            if let suggestion = error.recoverySuggestion {
                return suggestion + LocalizedString(" and try again", comment: "Recovery instruction addition to rety for certain bolus failure")
            }
            return LocalizedString("It is safe to retry", comment: "Recovery instruction for a certain bolus failure")
        case .uncertain:
            return LocalizedString("Check your pump before retrying", comment: "Recovery instruction for an uncertain bolus failure")
        }
    }

    public var helpAnchor: String? {
        switch self {
        case .certain(let error):
            return error.helpAnchor
        case .uncertain(let error):
            return error.helpAnchor
        }
    }
}
