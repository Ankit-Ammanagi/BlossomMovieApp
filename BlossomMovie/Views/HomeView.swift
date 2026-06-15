//
//  HomeView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI

struct HomeView: View {
    let heroTestURL = Constants.testTitleURL
    let viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                switch viewModel.homeStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    LazyVStack {
                        AsyncImage(url: URL(string: heroTestURL)) {
                            image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    LinearGradient(
                                        stops: [Gradient.Stop(color: .clear, location: 0.8), Gradient.Stop(color: .gradient, location: 1)], startPoint: .top,
                                        endPoint: .bottom)
                                }
                                .transition(AnyTransition.scale.animation(.easeInOut))
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: geo.size.height * 0.75)
                        
                        HStack {
                            Button {
                                // Action for Play button
                            } label: {
                                Text(Constants.playString)
                                    .ghostButton()
                            }
                            
                            Button {
                                // Action for Download button
                            } label: {
                                Text(Constants.downloadString)
                                    .ghostButton()
                            }
                        }
                       
                        
                        HorizontalListView(titleString: Constants.trendingMovies, titles: viewModel.trendingMovies)
                        
                        HorizontalListView(titleString: Constants.trendingTVString, titles: viewModel.trendingTVShows)
                        
                        
                        HorizontalListView(titleString: Constants.topRatedMovieString, titles: viewModel.topRatedMovies)
                        
                        
                        HorizontalListView(titleString: Constants.topRatedTVString, titles: viewModel.topRatedTVShows)
                    }
                    .padding(.horizontal, 10)
                case .failed(let error):
                    Text("Failed to load data: \(error.localizedDescription)")
                }
            }
            .task {
                await viewModel.getTitles()
            }
        }
    }
}

#Preview {
    HomeView()
}
