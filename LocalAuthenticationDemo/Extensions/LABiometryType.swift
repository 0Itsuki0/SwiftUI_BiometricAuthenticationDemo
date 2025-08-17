//
//  LABiometryType.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/18.
//


import SwiftUI
import LocalAuthentication

extension LABiometryType {
    var iconName: String {
        let imageName: String = switch self {
        case .none:
            "exclamationmark.triangle"
        case .touchID:
            "touchid"
        case .faceID:
            "faceid"
        case .opticID:
            "opticid"
        @unknown default:
            "exclamationmark.triangle"
        }
        return imageName
    }
    
    var description: String {
        switch self {
        case .none:
            "Biometric not supported."
        case .touchID:
            "Touch ID"
        case .faceID:
            "Face ID"
        case .opticID:
            "Optic ID"
        @unknown default:
            "I don't know what is going on!"
        }
    }
}
