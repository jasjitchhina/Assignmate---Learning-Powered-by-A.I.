
import SwiftUI

// A custom button view
struct AMButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(background)
                    
                    Text(title)
                        .foregroundStyle(Color.white)
                        .bold()
                }
            })
    }
}

// A preview of the custom button
struct AMButton_Previews: PreviewProvider {
    static var previews: some View {
        AMButton(title: "Value",
                 background: .blue) {
            // Action to perform when the button is tapped
        }
    }
}
