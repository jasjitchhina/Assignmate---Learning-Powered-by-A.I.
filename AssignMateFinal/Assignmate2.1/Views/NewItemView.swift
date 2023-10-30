import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool

    // The Custom Picker Display View
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
            Text("New Assignment")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                //course
                TextField("Course Name", text: $viewModel.course)
                
                //title
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

                //due date
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                //button
                AMButton(title: "Save", background: .purple) {
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
