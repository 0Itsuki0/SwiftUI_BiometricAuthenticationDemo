//
//  AuthenticateView.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/18.
//

import SwiftUI
import LocalAuthentication

struct AuthenticateView: View {
    @Environment(AuthenticationManager.self) private var authenticationManager

    var body: some View {
        @Bindable var authenticationManager = authenticationManager
        NavigationStack {
            VStack(spacing: 48) {
                Text("Please Authenticate!")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Button(action: {
                    Task {
                        do {
                            try await authenticationManager.authenticate()
                        } catch(let error) {
                            authenticationManager.error = error
                        }
                    }
                }, label: {
                    Text("Authenticate with \(authenticationManager.biometricTypeAllowed.description) \(Image(systemName: authenticationManager.biometricTypeAllowed.iconName))")
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow.opacity(0.1))
            .onTapGesture {
                // by default, in the case of Face ID,
                // user will be able to cancel authentication by tapping within the gray bounding box
                // we will also be cancelling those on touches outside
                authenticationManager.cancelAuthentication()
            }
            .navigationTitle("Public View")
            .navigationDestination(isPresented: $authenticationManager.authenticated, destination: {
                PrivateView()
                    .environment(authenticationManager)
            })
            .alert("Oops!", isPresented: $authenticationManager.showError, actions: {
                Button(action: {
                    authenticationManager.showError = false
                }, label: {
                    Text("OK")
                })
            }, message: {
                Text(authenticationManager.error?.message ?? "Unknown Error")
            })


        }
    }
}
