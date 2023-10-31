import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Display an image of a globe with a tinted color
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // Display a "Hello, world!" text
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
