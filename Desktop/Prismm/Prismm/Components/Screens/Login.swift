//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct Login: View {
    // Responsive
    @State var titleFont: CGFloat = 40
    @State var logoImageSize: CGFloat = 0
    @State var captionFont: Font = .caption
    @State var textFieldTitleFont: Font = .body
    @State var textFieldSizeHeight: CGFloat = 0
    @State var textFieldCorner: CGFloat = 0
    @State var textFieldBorderWidth: CGFloat = 2.5
    @State var faceIdImageSize: CGFloat = 0
    
    
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State var isDarkMode = false
    @State private var gradientColorsDark: [Color] = [Color(red: 0.27, green: 1.00, blue: 0.79), Color(red: 0.59, green: 1.00, blue: 0.96), Color(red: 0.44, green: 0.57, blue: 0.96)]
    @State private var gradientColorsLight: [Color] = [Color(red: 0.96, green: 0.51, blue: 0.65), Color(red: 0.95, green: 0.00, blue: 0.53), Color(red: 0.44, green: 0.10, blue: 0.46)]
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Title
                Text ("Log in")
                    .font(.system(size: titleFont))
                    .bold()
                
                Text("Please sign in to continue")
                    .font(captionFont)
                    .bold()
                    .opacity(0.7)
                
                Image("applogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: logoImageSize, height: logoImageSize)
                
                CustomTextField(text: $accountText, textFieldTitle: "Username", testFieldPlaceHolder: "Username or Account", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(false))
                
                CustomTextField(text: $passwordText, textFieldTitle: "Password", testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                
                Spacer()
                // Login button
                Button(action: {
                    // Add your login action here
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        // Add your login action here
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Add your login action here
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                    }
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Sign in with")
                            .bold()
                            .opacity(0.4)
                        
                        Button(action: {
                            // Add your login action here
                        }) {
                            Image(systemName: "faceid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: faceIdImageSize)
                        }
                        
                    }
                    Spacer()
                }
                .padding(.top)
                
                // Push view
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                logoImageSize = proxy.size.width/2
                textFieldSizeHeight = proxy.size.width/7
                textFieldCorner = proxy.size.width/50
                faceIdImageSize = proxy.size.width/10
            }
        }
        //        .background(.black)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

