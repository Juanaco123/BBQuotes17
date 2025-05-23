//
//  CharacterView.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 11/12/24.
//

import SwiftUI

struct CharacterView: View {
  let character: BBCharacter
  let show: String
   
  var body: some View {
    GeometryReader { geometry in
      ScrollViewReader { proxy in
        
        ZStack(alignment: .top) {
          Image(show.removeCaseAndSpace())
            .resizable()
            .scaledToFit()
          
          ScrollView {
            AsyncCarouselView(
              items: character.images,
              width: geometry.size.width / 1.2,
              height: geometry.size.height / 1.7
            )
            .padding(.top, 60)
            
            VStack(alignment: .leading) {
              Text(character.name)
                .font(.largeTitle)
              
              Text("Portrayed By: \(character.portrayedBy)")
                .font(.subheadline)
              
              Divider()
              
              Text("\(character.name): Character Info")
                .font(.title2)
              
              Text("Born: \(character.birthday)")
              
              Divider()
              
              Text("Occupations:")
              ForEach (character.occupations, id: \.self) { occupation in
                Text("• \(occupation)")
                  .font(.subheadline)
              }
              
              Divider()
              
              Text("Nicknames:")
              if(character.aliases.count > 0) {
                ForEach (character.aliases, id: \.self) { alias in
                  Text("• \(alias)")
                    .font(.subheadline)
                }
              }
              
              Divider()
              
              DisclosureGroup("Status (Spoiler Alert!)") {
                VStack(alignment: .leading) {
                  Text("\(character.status)")
                    .font(.title2)
                  
                  if let death = character.death {
                    AsyncImage(url: death.image) { image in
                      image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 15))
                        .onAppear {
                          withAnimation {
                            proxy.scrollTo(1, anchor: .bottom)
                          }
                        }
                    } placeholder: {
                      ProgressView()
                    }
                    Text("How: \(death.details)")
                      .padding(.bottom, 7)
                    
                    Text("Last words: \"\(death.lastWords)\"")
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .tint(.primary)
              
            }
            .frame(width: geometry.size.width / 1.25, alignment: .leading)
            .padding(.bottom, 50)
            .id(1)
          }
          .scrollIndicators(ScrollIndicatorVisibility.hidden)
        }
      }
    }
    .ignoresSafeArea()
  }
}


struct CharacterView_Preview: PreviewProvider {
  static var previews: some View {
    CharacterView(character: ViewModel().character, show: Constants.breakingBadName)
  }
}
