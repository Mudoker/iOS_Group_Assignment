import SwiftUI

struct ContentView: View {
    @State private var recWidth: CGFloat = 100
    @State private var recHeight: CGFloat = 50
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<5, id: \.self) { index in
                    Rectangle()
                        .fill(Color.random)
                        .frame(width: recWidth, height: recHeight)
                }
            }
            .padding()
        }
    }
}

extension Color {
    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
