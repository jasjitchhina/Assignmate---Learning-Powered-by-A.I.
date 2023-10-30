import SwiftUI
import AVFoundation

struct AssignmentItemView: View {
    @StateObject var viewModel = AssignmentItemViewViewModel()
    @State private var isDeleted = false
    @State private var scaleEffect: CGFloat = 1.0

    let item: AssignmentItem

    @Environment(\.colorScheme) var colorScheme // To determine the current appearance mode

    var body: some View {
        if !isDeleted {
            HStack(spacing: 20) {
                // Display the urgency level with a colored circle
                Circle()
                    .fill(urgencyColor)
                    .frame(width: 16, height: 16)

                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.title3)
                        .bold()

                    Text(item.course)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))

                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.yellow)
                            .frame(width: 16, height: 16)
                        Text("\(item.points) points")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()

                Button {
                    withAnimation {
                        scaleEffect = 1.2
                        playSound()
                        viewModel.toggleIsDone(item: item)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scaleEffect = 1.0
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation {
                                    isDeleted = true
                                    viewModel.removeItem(item: item)
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.purple)
                        .frame(width: 24, height: 24)
                }
                .scaleEffect(scaleEffect)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(colorScheme == .dark ? Color("DarkBackground") : Color("LightBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }

    var urgencyColor: Color {
        switch item.urgency {
        case "Low":
            return Color.green
        case "Normal":
            return Color.yellow
        case "High":
            return Color.red
        default:
            return Color.gray
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "popSound", withExtension: "mp3") else { return }
        do {
            let soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect.play()
        } catch {
            print("Error playing sound")
        }
    }
}
