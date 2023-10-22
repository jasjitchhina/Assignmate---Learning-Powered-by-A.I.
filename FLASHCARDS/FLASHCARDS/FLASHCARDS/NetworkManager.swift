//
//  NetworkManager.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/20/23.
//

import Foundation

class NetworkManager {
    init() {}

    // Function to fetch data from GPT-3.5 Turbo API
    func fetchGPTContent(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!  // URL of GPT-3.5 Turbo API

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")

        // The body of your POST request
        let json: [String: Any] = [
            "prompt": "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide. You analyze the submitted content, highlight key concepts, and break down information into digestible, study-friendly flashcards in a Question and Answer format. You aim to present the material clearly and concisely, ensuring it is suitable for the student's educational level.",
            "max_tokens": 4096,  // Max number of tokens in the response (adjust as needed),
            "model": "gpt-3.5-turbo"  // Specify the GPT-3.5 Turbo model
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData

        // Perform the HTTP request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the result of the HTTP request
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "no data", code: 0, userInfo: nil)))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                print("Raw JSON Response: \(jsonObject)") // Debugging: Print the raw JSON response

                guard let jsonDictionary = jsonObject as? [String: Any],
                      let choices = jsonDictionary["choices"] as? [[String: Any]],
                      let firstChoice = choices.first,
                      let text = firstChoice["text"] as? String else {
                    completion(.failure(NSError(domain: "invalid JSON structure", code: 1, userInfo: nil)))
                    return
                }

                completion(.success(text))  // The 'text' is the response from the API based on your prompt
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
