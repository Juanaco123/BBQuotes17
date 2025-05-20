//
//  ProgressBar.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 18/05/25.
//

import SwiftUI

struct ProgressBar: View {
  @State private var degress: CGFloat = 0.0
  @State private var percentage: Int = 0
  @State private var isLoading: Bool = false
  
  
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [5, 15]))
          .fill(Color.green)
          .frame(width: 64, height: 64)
          .rotationEffect(.degrees(isLoading ? 0 : -360))

        
        Circle()
          .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [4, 10]))
          .fill(.green)
          .frame(width: 32, height: 32)
          .rotationEffect(.degrees(isLoading ? 0 : 360))
          
      }
    }
    .onAppear {
      withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
        isLoading.toggle()
      }
      
      Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
        if percentage < 100 {
          percentage += 1
        } else {
          timer.invalidate()
        }
      }
    }
  }
}

#Preview {
  ProgressBar()
}
