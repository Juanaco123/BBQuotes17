//
//  QuoteView.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 8/12/24.
//

import SwiftUI

struct QuoteView: View {
  
  @State var viewModel = ViewModel()
  let show: String
  
  @State var showCharacterInfo: Bool = false
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Image(show.removeCaseAndSpace())
          .resizable()
          .frame(width: geometry.size.width * 2.7, height: geometry.size.height * 1.2)
        
        VStack {
          VStack {
            Spacer(minLength: 60)
            
            switch viewModel.status {
            case .notStarted:
              setQuoteView(using: geometry)
                .onAppear {
                  Task {
                    await viewModel.getQuoteData(for: show)
                  }
                }
              
            case .fetching:
              ProgressBar()
              
            case .successQuote:
              setQuoteView(using: geometry)
              
            case .successEpisode:
              EpisodeView(episode: viewModel.episode)
              
            case .failed(let error):
              Text(error.localizedDescription)
            }
            
            Spacer(minLength: 20)
          }
          
          HStack() {
            Button {
              Task {
                await viewModel.getQuoteData(for: show)
              }
            } label: {
              Text("Get Random Quote")
                .font(.title3)
                .foregroundStyle(.white)
                .padding()
                .background(Color("\(show.removeSpaces())Button"))
                .clipShape(.rect(cornerRadius: 7))
                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
            }
            
            Spacer()
            
            Button {
              Task {
                await viewModel.getEpisode(for: show)
              }
            } label: {
              Text("Get Random Episode")
                .font(.title3)
                .foregroundStyle(.white)
                .padding()
                .background(Color("\(show.removeSpaces())Button"))
                .clipShape(.rect(cornerRadius: 7))
                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
            }
          }
          .padding(.horizontal, 30)
          
          Spacer(minLength: 100)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
    .ignoresSafeArea()
    .sheet(isPresented: $showCharacterInfo) {
      CharacterView(character: viewModel.character, show: show)
        .preferredColorScheme(.dark)
    }
  }
  
  @ViewBuilder
  private func setQuoteView(using geometry: GeometryProxy) -> some View {
    Text("\"\(viewModel.quote.quote)\"")
      .minimumScaleFactor(0.5)
      .multilineTextAlignment(.center)
      .foregroundStyle(.white)
      .padding()
      .background(.black.opacity(0.5))
      .clipShape(.rect(cornerRadius: 25))
      .padding(.horizontal)
    
    ZStack(alignment: .bottom) {
      AsyncImage(url: viewModel.character.images.randomElement()) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ProgressView()
      }
      .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 1.8)
      
      Text(viewModel.quote.character)
        .foregroundStyle(.white)
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
      
    }
    .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 1.8)
    .clipShape(.rect(cornerRadius: 50))
    .onTapGesture {
      showCharacterInfo.toggle()
    }
  }
}

struct QuoteView_preview: PreviewProvider {
  static var previews: some View {
    QuoteView(show: Constants.breakingBadName)
      .preferredColorScheme(.dark)
  }
}
