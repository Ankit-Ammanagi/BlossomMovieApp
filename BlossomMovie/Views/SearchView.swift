//
//  SearchView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchViewModel = SearchViewModel()
    @State var showMovieSearch: Bool = true
    @State var searchText: String = ""
    @State private var titleDetailViewPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $titleDetailViewPath) {
            ScrollView {
                if let error = searchViewModel.errorMessage {
                    Text(error)
                        .errorMessage()
                }
                
                if searchViewModel.searchResults.isEmpty && !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("No search results found.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(searchViewModel.searchResults) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                        .onTapGesture {
                            print("Tapped on title: \(title.name ?? title.title ?? "")")
                            titleDetailViewPath.append(title)
                        }
                    }
                }
                .padding(.horizontal,10)
            }
            .navigationTitle(showMovieSearch ? Constants.movieSearchString : Constants.tvSearchString )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMovieSearch.toggle()
                        
                        Task {
                            await searchViewModel.getSearchResults(by: showMovieSearch ? "movie" : "tv", for: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        
                    } label: {
                        Image(systemName: showMovieSearch ? Constants.movieIconString : Constants.tvIconString) 
                    }

                }
            }
            .searchable(text: $searchText, prompt: showMovieSearch ? Constants.moviePlaceholderString : Constants.tvPlaceholderString)
            .task(id: searchText) {
                
                try? await Task.sleep(for: .milliseconds(500))
                
                if Task.isCancelled {
                    return
                }
                
                await searchViewModel.getSearchResults(by: showMovieSearch ? "movie" : "tv", for: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)
            }
        }
        
    }
}

#Preview {
    SearchView()
}
