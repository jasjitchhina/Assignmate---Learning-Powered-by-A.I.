
import Foundation

// A struct representing a user
struct User: Codable {
    let id: String          // Unique identifier for the user
    let name: String        // User's name
    let email: String       // User's email address
    let joined: TimeInterval // Date when the user joined (in seconds since reference date)
}
