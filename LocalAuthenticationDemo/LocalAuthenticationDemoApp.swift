//
//  LocalAuthenticationDemoApp.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/17.
//

import SwiftUI

@main
struct LocalAuthenticationDemoApp: App {
    private let authenticationManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authenticationManager)
        }
    }
}
