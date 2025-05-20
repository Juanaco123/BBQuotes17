//
//  ViewModel.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 29/11/24.
//

import SwiftUI
import Foundation

@Observable
@MainActor
class ViewModel {
  // 1. Create fetch status
  enum FetchStatus {
    case notStarted
    case fetching
    case successQuote
    case successEpisode
    case failed(error: Error)
  }
  
  // 2. create a fetch status property
  private(set) var status: FetchStatus = .notStarted // -> this way, the property is partialy private. The view can only get the value, but not change it.
  
  private let fetcher = FetchService()
  
  var progress: CGFloat = 0.0
  var quote: Quote
  var character: BBCharacter
  var episode: Episode
  
  init() {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
    
    quote = try! decoder.decode(Quote.self, from: quoteData)
    
    let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
    
    character = try! decoder.decode(BBCharacter.self, from: characterData)
    
    let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
    
    episode = try! decoder.decode(Episode.self, from: episodeData)
  }
  
  func getQuoteData(for show: String) async {
    status = .fetching
    progress = 0.0
    do {
      
      quote = try await fetcher.fetchQuote(from: show)
      character = try await fetcher.fetchCharacter(quote.character)
      character.death = try await fetcher.fetchDeath(for: character.name)
      
      status = .successQuote
    } catch {
      status = .failed(error: error)
    }
  }
  
  func getEpisode(for show: String) async {
    status = .fetching
    do {
      if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
        episode = unwrappedEpisode
        status = .successEpisode
      }
    } catch {
      status = .failed(error: error)
    }
  }
}
