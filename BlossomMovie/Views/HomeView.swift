//
//  HomeView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
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
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")) {
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
                                    titleDetailPath.append(viewModel.heroTitle)
                                } label: {
                                    Text(Constants.playString)
                                        .ghostButton()
                                }
                                
                                Button {
                                    modelContext.insert(viewModel.heroTitle)
                                    try? modelContext.save()
                                } label: {
                                    Text(Constants.downloadString)
                                        .ghostButton()
                                }
                            }
                            
                            
                            HorizontalListView(titleString: Constants.trendingMovies, titles: viewModel.trendingMovies) {
                                title in
                                titleDetailPath.append(title)
                            }
                             
                            HorizontalListView(titleString: Constants.trendingTVString, titles: viewModel.trendingTVShows) {
                                title in
                                titleDetailPath.append(title)
                            }
                            
                            
                            HorizontalListView(titleString: Constants.topRatedMovieString, titles: viewModel.topRatedMovies) {
                                title in
                                titleDetailPath.append(title)
                            }
                            
                            
                            HorizontalListView(titleString: Constants.topRatedTVString, titles: viewModel.topRatedTVShows) {
                                title in
                                titleDetailPath.append(title)
                            }
                        }
                        .padding(.horizontal, 10)
                        
                    case .failed(let error):
                        Text(error.localizedDescription)
                            .errorMessage()
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .task {
                    await viewModel.getTitles()
                }
                .navigationDestination(for: Title.self) { title in
                    TitleDetailView(title: title)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
