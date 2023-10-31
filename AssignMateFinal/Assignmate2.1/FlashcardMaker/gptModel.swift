//
//  gpt_3.5.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import Foundation
import OpenAI

// Define the necessary structures for the OpenAI API's requirements.

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatQuery: Codable {
    let model: String
    let messages: [Message]
}

struct CompletionsResult: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let index: Int
        let message: Message
        let finish_reason: String
    }
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    // ... (include other fields here as necessary)
}
// The OpenAI class that handles the interaction with the API.

class OpenAI {
    private let apiToken: String

    init(apiToken: String) {
        self.apiToken = apiToken
    }

    // Asynchronously sends a query to the chat API and decodes the response.
    func chat(query: ChatQuery) async throws -> CompletionsResult {
        // Prepare the URL and request.
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
    throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.apiToken)", forHTTPHeaderField: "Authorization")

        // Convert the query to JSON data.
        let jsonData = try JSONEncoder().encode(query)
        request.httpBody = jsonData

        // Perform the asynchronous POST request.
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a successful response (2xx status code).
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse) // Or your preferred error.
        }

        // For debugging: print the JSON response data as a String.
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }

        // Decode the JSON response.
        let result = try JSONDecoder().decode(CompletionsResult.self, from: data)
        return result
    }
}
// Main execution starts here.
