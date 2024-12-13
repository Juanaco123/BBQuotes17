//
//  StringExt.swift
//  BBQuotes17
//
//  Created by Juan Camilo Victoria Pacheco on 13/12/24.
//

import Foundation

extension String {
  func removeSpaces() -> String {
    return self.replacingOccurrences(of: " ", with: "")
  }
  
  func removeCaseAndSpace() -> String {
    self.removeSpaces().lowercased()
  }
}
