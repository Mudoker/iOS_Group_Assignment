import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    
    // Sample list of picker items
    let pickerItems = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    
    // Filtered picker items based on search text
    var filteredPickerItems: [String] {
        if searchText.isEmpty {
            return pickerItems
        } else {
            return pickerItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding()
            
            List(filteredPickerItems, id: \.self) { item in
                Text(item)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
