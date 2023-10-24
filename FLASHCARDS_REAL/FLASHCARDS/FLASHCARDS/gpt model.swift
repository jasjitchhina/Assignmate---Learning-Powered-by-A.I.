//
//  gpt model.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/23/23.
//

import Foundation

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
        struct Data: Codable {
    let text: String
        }
        let data: Data
    }
    let choices: [Choice]
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


struct Main {
    static func main() async {
        let openAI = OpenAI(apiToken: "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")

        let query = ChatQuery(model: "ft:gpt-3.5-turbo-0613:personal::8BNCq0xA", messages: [
            .init(role: "system", content: "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide. You analyze the submitted content, highlight key concepts, and break down information into digestible, study-friendly flashcards in a Question and Answer format. You aim to present the material clearly and concisely, ensuring it is suitable for the student's educational level."),
            .init(role: "user", content: "") // Replace with your actual query text.
        ])

        do {
            let result = try await openAI.chat(query: query)

            // Process and print the result.
            if let firstResponse = result.choices.first {
                print("Response from the model: \(firstResponse.data.text)")
            } else {
                print("No response received.")
            }
        } catch {
            print("An error occurred: \(error)")
        }
    }
}
