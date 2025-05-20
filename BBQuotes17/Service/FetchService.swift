//
//  FetchService.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 7/09/24.
//

import Foundation

struct FetchService {
  private enum FetchError: Error {
    case badResponse
  }
  // Steps to create a network connection
  // MARK: - Get the URL/Endpoint
  private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
  
  // Example:
  // https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
  func fetchQuote(from show: String) async throws  -> Quote { //progressHandler: @escaping (Double) -> Void) async throws  -> Quote {
    
    // MARK: - Build the fetch URL
    let quoteURL = baseURL.appending(path: "quotes/random")
    
    let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
    
    // MARK: [This new lines is to add a loader based on the download process of the data]
//    var observation: NSKeyValueObservation?
//    
//    return try await withCheckedThrowingContinuation { continuation in
//      let task = URLSession.shared.dataTask(with: fetchURL) { data, response, error in
//        observation?.invalidate()
//        
//        if let error = error {
//          continuation.resume(throwing: error)
//        }
//        
//        guard let data = data,
//              let response = response as? HTTPURLResponse,
//              response.statusCode == 200 else {
//          continuation.resume(throwing: FetchError.badResponse)
//          return
//        }
//        
//        do {
//          let quote = try JSONDecoder().decode(Quote.self, from: data)
//          continuation.resume(returning: quote)
//        } catch {
//          continuation.resume(throwing: error)
//        }
//      }
//      
//      observation = task.progress.observe(\.fractionCompleted) { progress, _ in
//        DispatchQueue.main.async {
//          progressHandler(progress.fractionCompleted)
//        }
//      }
//      
//      task.resume()
//    }
    // MARK: I don't delete this lines of code bacause is useful for me as reference
//    // MARK: - Fetch data
    let (data, response) = try await URLSession.shared.data(from: fetchURL)
    
    // MARK: - Handle response
    guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
      throw FetchError.badResponse
    }
    
    //MARK: - Decode data
    let quote = try JSONDecoder().decode(Quote.self, from: data)
    
//     MARK: - Return the data
//     quote
    return quote
  }
  
  func fetchCharacter(_ name: String) async throws -> BBCharacter {
    let characterURL = baseURL.appending(path: "characters")
    let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
    
    let (data, response) = try await URLSession.shared.data(from: fetchURL)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw FetchError.badResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let characters = try decoder.decode([ BBCharacter].self, from: data)
    return characters[0]
  }
  
  func fetchDeath(for character: String) async throws -> Death? {
    let fetchURL = baseURL.appending(path: "deaths")
    let (data, response) = try await URLSession.shared.data(from: fetchURL)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw FetchError.badResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let deaths  = try decoder.decode([Death].self, from: data)
    
    for death in deaths {
      if death.character == character {
        return death
      }
    }
    return nil
  }
  
  func fetchEpisode(from show: String) async throws -> Episode? {
    let episodeURL = baseURL.appending(path: "episodes")
    let fetchURL = episodeURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
    
    let (data, response) = try await URLSession.shared.data(from: fetchURL)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw FetchError.badResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let episodes = try decoder.decode([Episode].self, from: data)
    
    return episodes.randomElement()
  }
}
