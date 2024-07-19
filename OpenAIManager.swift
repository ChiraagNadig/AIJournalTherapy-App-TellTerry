//
//  OpenAIManager.swift
//  AI WORKJ
//
//  Created by Chiraag Nadig on 4/19/24.
//

import Foundation
import Alamofire

struct Response: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let role: String
    let content: String
}

class OpenAIManager {
    private let apiKey = "sk-proj-2WoFCfVvcLqvrHq401aTT3BlbkFJ6XeVjr9ZK4wZklasC5YY"  // Replace with your actual API key
    private let url = "https://api.openai.com/v1/chat/completions?"

    func generateResponse(for prompt: String, completion: @escaping (String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //print("Raw JSON Response: \(response.value)")  // Log the complete raw JSON response to the console
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let choices = json["choices"] as? [[String: Any]], let firstChoice = choices.first, let message = firstChoice["message"] as? [String: Any], let text = message["content"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion("Failed to parse response")
                }
            case .failure(let error):
                print("Error: \(error)")
                completion("Failed to get response")
            }
        }
    }
}

