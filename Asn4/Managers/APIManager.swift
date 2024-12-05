//
//  APIManager.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//

import Foundation

class APIManager {
    
    //private let apiKey = "fb0e8138-4b95-403f-ad49-d8d19a16a33d"
    private var apiKey: String {
        guard let key = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API Key is missing")
        }
        return key
    }

    
    static let shared = APIManager() // Singleton instance
    private let baseURL = "https://api.pokemontcg.io/v2"

    func fetchCards(completion: @escaping ([Card]?) -> Void) {
        // Create the URL
        let urlString = "\(baseURL)/cards"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Create a URL request
       var request = URLRequest(url: url)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key") // Add the API key header


        // Perform the request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching cards: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON: \(jsonString)")
            }

            do {
                // Decode JSON into Card objects
                let decodedResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                let cards = decodedResponse.data // The key `data` contains the cards array
                completion(cards)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume() // Start the network request
    }
}
