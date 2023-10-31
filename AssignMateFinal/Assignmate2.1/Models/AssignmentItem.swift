
import Foundation

// A struct representing an assignment item
struct AssignmentItem: Codable, Identifiable {
    let id: String           // Unique identifier for the assignment
    let course: String       // Name of the course for the assignment
    let title: String        // Title or description of the assignment
    let dueDate: TimeInterval   // Due date of the assignment (in seconds since reference date)
    let createdDate: TimeInterval  // Date when the assignment was created (in seconds since reference date)
    var isDone: Bool         // Flag indicating whether the assignment is marked as done
    var urgency: String     // New property for indicating urgency level
    var points: Int         // New property for specifying the points associated with the assignment

    // Function to set the 'isDone' flag
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
