//
//  PrivateView.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/18.
//

import SwiftUI
import LocalAuthentication

struct PrivateView: View {
    @Environment(AuthenticationManager.self) private var authenticationManager

    var body: some View {
        VStack(spacing: 48) {
            stars
            Text("Welcome to Itsuki's Private World!")
                .font(.title3)
                .fontWeight(.bold)
            stars

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow.opacity(0.1))
        .navigationTitle("Private View")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    authenticationManager.authenticated = false
                }, label: {
                    Text("Sign Out")
                })
                .buttonStyle(.glassProminent)
            })
        })

    }
    
    var stars: some View {
        HStack(spacing: 48) {
            ForEach(0..<5, id: \.self ) { _ in
                Image(systemName: "star.fill")
            }
        }.foregroundStyle(.red)
    }
}
