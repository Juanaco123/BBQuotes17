//
//  FetchService.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 7/09/24.
//

import Foundation

struct FetchService {
  enum FetchError: Error {
    case badResponse
  }
  // Steps to create a network connection
  // MARK: - Get the URL/Endpoint
  let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
  
  // Example:
  // https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
  func fetchQuote(from show: String) async throws  -> Quote {
    
    // MARK: - Build the fetch URL
    let quoteURL = baseURL.appending(path: "quotes/random")
    
    let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
    // MARK: - Fetch data
    let (data, response) = try await URLSession.shared.data(from: fetchURL)
    
    // MARK: - Handle response
    guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
      throw FetchError.badResponse
    }
    
    //MARK: - Decode data
    let quote = try JSONDecoder().decode(Quote.self, from: data)
    
    // MARK: - Return the data
    // quote
    return quote
  }
}
