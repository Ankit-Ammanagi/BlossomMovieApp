//
//  ContentView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                Tab(Constants.homeString, systemImage: Constants.homeImageIcon ) {
                        HomeView()
                }
                Tab(Constants.upcommingString, systemImage: Constants.upcommingImageIcon ) {
                        UpcomingView()
                }
                Tab(Constants.searchString, systemImage: Constants.searchImageIcon ) {
                        SearchView()
                } 
                Tab(Constants.downloadString, systemImage: Constants.downloadImageIcon ) {
                        DownloadView()
                }
            }
    }
}   

#Preview {
    ContentView()
}
