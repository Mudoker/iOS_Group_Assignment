//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct SignUp: View {
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
    @State var confrimPasswordText = ""
    @State var isDarkMode = false
    @State private var gradientColorsDark: [Color] = [Color(red: 0.27, green: 1.00, blue: 0.79), Color(red: 0.59, green: 1.00, blue: 0.96), Color(red: 0.44, green: 0.57, blue: 0.96)]
    @State private var gradientColorsLight: [Color] = [Color(red: 0.96, green: 0.51, blue: 0.65), Color(red: 0.95, green: 0.00, blue: 0.53), Color(red: 0.44, green: 0.10, blue: 0.46)]
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Title
                Text ("Sign Up")
                    .font(.system(size: titleFont))
                    .bold()
                
                Text("Create a new profile")
                    .font(captionFont)
                    .bold()
                    .opacity(0.7)
                
                Image("applogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: logoImageSize, height: logoImageSize)
                
                CustomTextField(text: $accountText, textFieldTitle: "Username", testFieldPlaceHolder: "Username or Account", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(false))
                
                CustomTextField(text: $passwordText, textFieldTitle: "Password", testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                
                HStack {
                    Text("At least 8 characters and not contain special symbols")
                        .font(.caption)
                        .padding(.bottom, 5)
                        .opacity(0.7)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                CustomTextField(text: $confrimPasswordText, textFieldTitle: "Confirm Password", testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                
                HStack {
                    Text("Re-enter your password")
                        .font(.caption)
                        .padding(.bottom, 5)
                        .opacity(0.7)
                    
                    Spacer()
                }
                .padding(.horizontal)
                VStack {
                    // Login button
                    Button(action: {
                        // Add your login action here
                    }) {
                        Text("Sign Up")
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
                }
                
                
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

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

