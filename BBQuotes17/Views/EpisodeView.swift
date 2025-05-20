//
//  EpisodeView.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 13/12/24.
//

import SwiftUI

struct EpisodeView: View {
  let episode: Episode
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(episode.title)
        .font(.largeTitle)
      
      Text(episode.seasonEpisode)
        .font(.title2)
      
      AsyncImage(url: episode.image) { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(.rect(cornerRadius: 15))
        
      } placeholder: {
        ProgressView()
      }
      
      Text(episode.synopsis)
        .font(.title3)
        .minimumScaleFactor(0.5)
        .padding(.bottom)
      
      Text("Written By: \(episode.writtenBy)")
      Text("Directed By: \(episode.directedBy)")
      Text("Aired: \(episode.airDate)")
    }
    .padding()
    .foregroundStyle(.white)
    .background(.black.opacity(0.6))
    .clipShape(.rect(cornerRadius: 25))
    .padding(.horizontal)
  }
}

struct EpisodeView_Preview: PreviewProvider {
  static var previews: some View {
    EpisodeView(episode: ViewModel().episode)
  }
}
