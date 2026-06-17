//
//  BlossomMovieApp.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI
import SwiftData

@main
struct BlossomMovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Title.self)
    }
}
