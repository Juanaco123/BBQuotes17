//
//  ContentView.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 13/06/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      FetchView(show: Constants.breakingBadName)
        .toolbarBackground(.visible, for: .tabBar)
        .tabItem {
          Label(Constants.breakingBadName, systemImage: "tortoise")
        }
      
      FetchView(show: Constants.betterCallSaulName)
        .toolbarBackground(.visible, for: .tabBar)
        .tabItem {
          Label(Constants.betterCallSaulName, systemImage: "briefcase")
        }
      
      FetchView(show: Constants.elCaminoName)
        .toolbarBackground(.visible, for: .tabBar)
        .tabItem {
          Label(Constants.elCaminoName, systemImage: "car")
        }
    }
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
}
