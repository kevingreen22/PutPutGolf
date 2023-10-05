//
//  NavigationViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/30/23.
//

import SwiftUI

class NavigationStore: ObservableObject {
    @Published var path = NavigationPath() //{ didSet { save() } }
    
//    private let savePath = URL.documentsDirectory.appending(path: "SavedNavigationStore")
//
//    init() {
//        if let data = try? Data(contentsOf: savePath) {
//            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
//                path = NavigationPath(decoded)
//                return
//            }
//        }
//    }
//
//    func save() {
//        guard let representation = path.codable else { return }
//
//        do {
//            let data = try JSONEncoder().encode(representation)
//            try data.write(to: savePath)
//        } catch {
//            print("Failed to save navigation data")
//        }
//    }
    
}
