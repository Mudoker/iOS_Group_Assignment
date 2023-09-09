//
//  Test+BioMetric.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import LocalAuthentication

struct Test_BioMetric: View {
    @State var unlocked = false
    @State var text = "Locked"
    var body: some View {
        VStack {
            if unlocked {
                Text("Uncloked")
                    .padding(.bottom)
                
            } else {
                Text("Locked")
                    .padding(.bottom)
            }
           
            
            Button(action: {bioMetricAuthenticate()}) {
                Image(systemName: "faceid")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
    
    func bioMetricAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Account Autofill") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful
                        unlocked = true
                    } else {
                        // Biometric authentication failed or was canceled
                        if let error = authenticationError {
                            // Handle the specific error
                            print("Biometric authentication failed: \(error.localizedDescription)")
                            
                        } else {
                            // Handle the case where authentication was canceled or failed without an error
                            print("Biometric authentication failed.")
                        }
                    }
                }
            }
        } else {
            // Handle the case where biometric authentication is not available or supported
            if let error = error {
                // Handle the error
                print("Biometric authentication not available: \(error.localizedDescription)")
            } else {
                // Handle the case where biometric authentication is not supported
                print("Biometric authentication not supported on this device.")
            }
        }
    }
}

struct Test_BioMetric_Previews: PreviewProvider {
    static var previews: some View {
        Test_BioMetric()
    }
}
