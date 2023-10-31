import Foundation

// A struct to represent scanned data
struct ScanData: Identifiable {
    var id = UUID()        // Unique identifier for each ScanData instance
    let content: String    // The content of the scanned data
    
    // Initialize a ScanData instance with the provided content
    init(content: String) {
        self.content = content
    }
}
