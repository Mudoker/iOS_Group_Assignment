import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    @Binding var isSuccess: Bool
    var title: String
    var message: String
    var actionText: String

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    ZStack {
                        VStack (spacing: 0) {
                            Color.red.opacity(0.5)
                                .frame(height: proxy.size.height/7)
                            Color.white
                                .frame(height: proxy.size.height/5)
                        }
                        VStack {
                            Text(title)
                                .font(.title)
                                .bold()
                                .padding()

                            Text(message)
                                .font(.body)
                                .padding()

                            Button(action: {
                                isPresented.toggle()
                            }) {
                                Text(actionText)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        
                        
                    }
                    
                }
                .cornerRadius(20)
                .padding()
            }
            .opacity(isPresented ? 1 : 0)
            .onTapGesture {
                withAnimation {
                    isPresented.toggle()
                }
        }
        }
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(isPresented: .constant(true), isSuccess: .constant(false), title: "Login Failed", message: "Invalid Username or Password", actionText: "Try again!")
    }
}
