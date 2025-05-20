//
//  Episode.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 12/12/24.
//

import Foundation

struct Episode: Decodable {
  var episode: Int
  var title: String
  var image: URL
  var synopsis: String
  var writtenBy: String
  var directedBy: String
  var airDate: String
  
  var seasonEpisode: String {
    var episodeString = String(episode)
    let season = episodeString.removeFirst()
    
    if episodeString.first! == "0" {
      episodeString = String(episodeString.removeLast())
    }
    
    return "Season \(season) Episode \(episodeString)"
  }
}
