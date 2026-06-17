//
//  TitleDetailView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 16/06/26.
//

import SwiftUI

struct TitleDetailView: View {
    let title: Title
    var titleName: String {
        return (title.name ?? title.title) ?? ""
    }
    let viewModel = ViewModel()
    
    var body: some View { 
        GeometryReader { geo in
            switch viewModel.videoIdStatus {
            case .success:
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        YoutubePlayer(videoID: viewModel.videoId)
                            .aspectRatio(16/9,contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Text(titleName)
                            .font(.title)
                            .bold()
                        
                        Text(title.overview ??  "")
                            .padding(.top, 1)
                    }
                    .padding(.horizontal, 10)
                }
            case .notStarted:
                EmptyView()
            case .fetching:
                ProgressView()
                    .frame(width: geo.size.width, height: geo.size.height)
            case .failed(let underlyingError):
                Text(underlyingError.localizedDescription)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .task {
            await viewModel.getVideoId(for: titleName)
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
