//
//  HorizontalListView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI

struct HorizontalListView: View {
    let titleString: String
    let titles: [Title]
    let onSelect: (Title) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(titleString)
                .font(.title)
                
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(titles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            onSelect(title)
                        }
                    }
                }
            }
        }
        .frame(height: 250)
        .padding(10)
    }
}

#Preview {
    HorizontalListView(titleString: Constants.trendingMovies, titles: Title.previewTitles) { _ in }
}
