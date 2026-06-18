//
//  DownloadView.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct DownloadView: View {
    @Query var savedTitles : [Title]
    
    var body: some View {
        NavigationStack {
            if savedTitles.isEmpty {
                Text("No Downloads Available")
                    .font(.title3)
                    .bold()
                    .padding()
            } else {
                VerticalListView(titles: savedTitles)
            }
        }
    }
}

#Preview {
    DownloadView()
}
