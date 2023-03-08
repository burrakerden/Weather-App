// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct CoordApi1: Codable {
    let name: String?
    let lat, lon: Double?
    let country: String?
}


typealias CoordApi = [CoordApi1]
