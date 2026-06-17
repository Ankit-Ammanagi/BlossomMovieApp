//
//  UpcomingView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                switch viewModel.upcomingStatus {
                case .success:
                    VerticalListView(titles: viewModel.upcomingMovies)
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
                await viewModel.getUpcomingMovies()
            }
        }
    }
}

#Preview {
    UpcomingView()
}
