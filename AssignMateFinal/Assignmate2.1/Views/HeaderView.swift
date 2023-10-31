import SwiftUI

// A custom header view with a title, subtitle, angle, and background color
struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    var body: some View {
        ZStack{
            // Rounded rectangle background with specified color
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(background)
                .rotationEffect(Angle(degrees: angle))
           
            VStack{
                // Title text with custom styling
                Text(title)
                    .foregroundStyle(Color.white)
                    .offset(y:20)
                    .font(.system(size: 50))
                    .bold()
                
                // Subtitle text with custom styling
                Text(subtitle)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
                    .offset(y:20)
            }
        }
        // Set the frame and offset of the header view
        .frame(width: UIScreen.main.bounds.width * 3, height:300)
        .offset(y: -100)
    }
}

#Preview {
    // Example usage of HeaderView with specified parameters
    HeaderView(title: "Title",
               subtitle: "Subtitle",
               angle: 15,
               background: .blue
    )
}
