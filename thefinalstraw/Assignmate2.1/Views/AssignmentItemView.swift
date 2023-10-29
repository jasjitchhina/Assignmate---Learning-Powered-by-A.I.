import SwiftUI

struct AssignmentItemView: View {
    @StateObject var viewModel = AssignmentItemViewViewModel()
    
    let item: AssignmentItem
    
    var body: some View {
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
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.purple)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
}
