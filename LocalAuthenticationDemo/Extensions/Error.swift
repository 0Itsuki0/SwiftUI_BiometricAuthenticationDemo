//
//  Error.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/18.
//


import SwiftUI

extension Error {
    var message: String {
        if let error  = self as? AuthenticationManager._Error {
            return switch error {
            case .authenticationFailed:
                "Authentication Failed."
            case .biometricAuthNotAvailable:
                "Biometric Authentication is not available"
            }
        }
        return self.localizedDescription
    }
}
