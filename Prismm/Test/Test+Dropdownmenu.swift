//import SwiftUI
//
//struct OptionsView: View {
//    @State private var isShowingOptions = false
//    @State private var selectedOption: String?
//
//    var body: some View {
//        VStack {
//            Menu {
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "delete.left")
//                        Text("Delete Post")
//                    }
//                }
//                
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "person.crop.circle.badge.xmark")
//                        Text("Block this user")
//                    }
//                }
//                
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "rectangle.portrait.slash")
//                        Text("Hide this user")
//                    }
//                }
//                
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "text.badge.xmark")
//                        Text("Turn off comment")
//                    }
//                }
//                
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "square.and.pencil")
//                        Text("Edit post")
//                    }
//                }
//                
//                
//            } label: {
//                Image(systemName: "line.3.horizontal.decrease")
//                    .font(.title)
//            }
//        }
//    }
//
//    func performAction(option: String) {
//        print("Selected Option: \(option)")
//        isShowingOptions.toggle() // Close the menu after an option is selected
//    }
//}
//
//struct OptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OptionsView()
//    }
//}
