//
//  CustomTextField.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct CustomTextField: View {
    // Get input
    @State var text: String = ""
    
    // Control state
    @State var textFieldTitle = "Username"
    @State var gradientColorsDark: [Color] = [Color(red: 0.27, green: 1.00, blue: 0.79), Color(red: 0.59, green: 1.00, blue: 0.96), Color(red: 0.44, green: 0.57, blue: 0.96)]
    @State var gradientColorsLight: [Color] = [Color(red: 0.96, green: 0.51, blue: 0.65), Color(red: 0.95, green: 0.00, blue: 0.53), Color(red: 0.44, green: 0.10, blue: 0.46)]
    @State var isDarkMode = false
    // Responsive
    @State var titleFont: Font = .body
    @State var textFieldSizeHeight: CGFloat = 0
    @State var textFieldCorner: CGFloat = 0
    @State var textFieldBorderWidth: CGFloat = 2.5
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .leading) {
                // Title
                Text(LocalizedStringKey(textFieldTitle))
                    .font(titleFont)
                    .bold()
                
                // Text field
                ZStack {
                    RoundedRectangle(cornerRadius: textFieldCorner)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? gradientColorsDark : gradientColorsLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: textFieldBorderWidth)
                        .frame(height: textFieldSizeHeight)
                    
                    TextField("", text: $text, prompt:  Text("Username or email").foregroundColor(.black.opacity(0.5))
                    )
                    .padding(.horizontal)
                }
            }
            .padding()
            .onAppear {
                textFieldSizeHeight = proxy.size.width/7
                textFieldCorner = proxy.size.width/50
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField()
    }
}
