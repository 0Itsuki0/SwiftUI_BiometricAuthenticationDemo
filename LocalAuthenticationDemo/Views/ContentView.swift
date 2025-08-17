//
//  ContentView.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/17.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @Environment(AuthenticationManager.self) private var authenticationManager
    
    var body: some View {
        Group {
            if authenticationManager.biometricTypeAllowed == .none {
                ContentUnavailableView(label: {
                    Label(LABiometryType.none.description, systemImage: LABiometryType.none.iconName)
                }, description: {
                    let message = if let error = authenticationManager.error { error.message } else {
                        "Biometric authentication is not supported."
                    }
                    Text(message)
                        .multilineTextAlignment(.center)
                })
            } else {
                AuthenticateView()
                    .environment(authenticationManager)
            }
        }
        .background(.gray.opacity(0.2))

    }
}
