import SwiftUI

// View for creating a new assignment item
struct NewItemView: View {
    // View model to handle new assignment creation
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool

    // Custom Picker Display View for urgency
    struct UrgencyView: View {
        var urgency: String

        var body: some View {
            HStack {
                Circle()
                    .fill(urgencyColor)
                    .frame(width: 10, height: 10)
                Text(urgency)
            }
        }

        // Determine the color based on urgency level
        var urgencyColor: Color {
            switch urgency {
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
    
    var body: some View {
        VStack {
            // Title for the new assignment view
            Text("New Assignment")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                // Course input field
                TextField("Course Name", text: $viewModel.course)
                
                // Assignment title input field
                TextField("Assignment Name", text: $viewModel.title)
                
                // Urgency Picker
                Picker(selection: $viewModel.urgency, label: UrgencyView(urgency: viewModel.urgency)) {
                    Text("Low").tag("Low")
                    Text("Normal").tag("Normal")
                    Text("High").tag("High")
                }
                .pickerStyle(MenuPickerStyle())

                // New Picker for points
                Picker("Points", selection: $viewModel.points) {
                    ForEach(0..<21) { index in
                        Text("\(index * 5)").tag(index * 5)
                    }
                }

                // Due date selection
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                // Save button
                AMButton(title: "Save", background: .purple) {
                    // Check if the assignment can be saved
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("Fill in all fields and select a due date that is not in the past."))
            }
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: .constant(true))
    }
}
