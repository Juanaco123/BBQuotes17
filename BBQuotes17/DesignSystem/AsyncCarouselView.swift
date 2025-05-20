//
//  AsyncCarouselView.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 20/05/25.
//

import SwiftUI

struct AsyncCarouselView: View {
  let items: [URL]
  let width: CGFloat
  let height: CGFloat
  let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
  
  @State var isReversing: Bool = false
  @State var currentImage: Int = 0
  
  init(
    items: [URL],
    width: CGFloat,
    height: CGFloat,
  ) {
    self.items = items
    self.width = width
    self.height = height
  }
  
  var body: some View {
    ZStack {
      TabView(selection: $currentImage) {
        ForEach(Array(items.enumerated()), id: \.offset) { index, image in
          AsyncImage(url: image) { imageURL in
            imageURL
              .resizable()
              .scaledToFill()
          } placeholder: {
            ProgressBar()
          }
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
          .tag(index)
        }
      }
      .tabViewStyle(.page)
      .frame(width: width, height: height)
      .clipShape(.rect(cornerRadius: 25))
    }
    .onReceive(timer) { _ in
      withAnimation(.snappy) {
        if isReversing {
          if currentImage > 0 {
            currentImage -= 1
          } else {
            isReversing = false
            currentImage += 1
          }
        } else {
          if currentImage < items.count - 1 {
            currentImage += 1
          } else {
            isReversing = true
            currentImage -= 1
          }
        }
      }
    }
  }
}

#Preview {
  AsyncCarouselView(
    items: [
      URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!,
      URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!,
      URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!
    ],
    width: 300,
    height: 550
  )
}
