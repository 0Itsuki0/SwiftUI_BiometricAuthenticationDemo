//
//  AuthenticationManager.swift
//  LocalAuthenticationDemo
//
//  Created by Itsuki on 2025/08/17.
//

import SwiftUI
import LocalAuthentication

extension AuthenticationManager {
    enum _Error: Error {
        case authenticationFailed
        case biometricAuthNotAvailable
    }
}

@Observable
class AuthenticationManager {
    
    var error: (any Error)? = nil {
        didSet {
            if let error = self.error {
                print(error)
                self.showError = true
            }
        }
    }

    var showError: Bool = false {
        didSet {
            if !showError {
                self.error = nil
            }
        }
    }

    
    // to sign out, we can simply set `authenticated` to `false`.
    var authenticated: Bool = false
    
    var biometricTypeAllowed: LABiometryType = .none
    
    // store a reference so that we can cancel authentication request programmatically
    private var context: LAContext?
    
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
    init() {
        self.checkAvailability()
    }
    
    
    @discardableResult
    private func checkAvailability() -> Bool {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(self.policy, error: &error)
        if let error = error  {
            self.error = error
        }
        
        if canEvaluate {
            // `context.biometryType` is set only after you call the canEvaluatePolicy(_:error:) method,
            // and is set no matter what the call returns.
            // The default value is LABiometryType.none.
            //
            // need to check canEvaluate because this value can be set to, for example, faceId, even if the canEvaluate is false.
            self.biometricTypeAllowed = context.biometryType
        } else {
            self.biometricTypeAllowed = .none
        }
        
        return canEvaluate
    }
    
    
    // to sign out, we can simply set `authenticated` to `false`.
    func authenticate() async throws {
        guard !self.authenticated else {
            return
        }
        
        // checking every time before making request
        // because the availability to the specific policy might change as a result of changes in the system.
        // For example, a user might disable Touch ID after you call this method.
        guard self.checkAvailability() else {
            return
        }
        
        // A new context for each authentication.
        // If we use the same context on multiple attempts (by storing the context as a property),
        // then a previously successful authentication will cause the next policy evaluation to succeed without testing biometry again.
        let context = LAContext()
        
        context.localizedCancelTitle = "Cancel!"
        context.localizedFallbackTitle = "Fallback!"
        
        // If the user unlocks the device using Touch ID within the specified time interval,
        // then authentication for the receiver succeeds automatically, without prompting the user for Touch ID.
        // This bypasses a scenario where the user unlocks the device and then is almost immediately prompted for another fingerprint.
        //
        // The default value is 0, meaning that Touch ID authentication isn’t reused.
        // The maximum allowable duration for Touch ID authentication reuse is specified by the LATouchIDAuthenticationMaximumAllowableReuseDuration constant.
        context.touchIDAuthenticationAllowableReuseDuration = LATouchIDAuthenticationMaximumAllowableReuseDuration
        
        self.context = context
        
        let result = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please authenticate!")

        guard result else {
            throw _Error.authenticationFailed
        }
        
        // give it couple seconds for the system UI to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.authenticated = true
        })
    }
    
    func cancelAuthentication() {
        self.context?.invalidate()
    }

}
