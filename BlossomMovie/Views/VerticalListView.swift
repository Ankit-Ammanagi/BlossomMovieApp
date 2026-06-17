//
//  VerticalListView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 17/06/26.
//

import SwiftUI

struct VerticalListView: View {
    let titles: [Title]
    
    var body: some View {
        List(titles) { title in
            AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                HStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(10)
                    
                    Text((title.name ?? title.title) ?? "")
                        .bold()
                        .font(.system(size: 14))
                }
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles)
}
