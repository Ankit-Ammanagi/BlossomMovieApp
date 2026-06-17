//
//  YoutubePlayer.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 16/06/26.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
                configuration.allowsInlineMediaPlayback = true
                configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)

                // Mock a browser environment
                webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"


                // 3. HTML wrapper with strict-origin policy explicitly attached to the frame
                let htmlString = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body { margin: 0; padding: 0; background-color: #000; }
                        .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; }
                        .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
                    </style>
                </head>
                <body>
                    <div class="video-container">
                        <iframe
                            src="https://www.youtube.com/embed/\(videoID)?playsinline=1"
                            referrerpolicy="strict-origin-when-cross-origin"
                            frameborder="0"
                            allowfullscreen>
                        </iframe>
                    </div>
                </body>
                </html>
                """

                // 4. CRITICAL FIX: The baseURL MUST be a valid https web address.
                // This forces WKWebView to pass "https://yourdomain.com" as the Referer header to YouTube!
                if let dummyBaseURL = URL(string: "https://yourdomain.com") {
                    webView.loadHTMLString(htmlString, baseURL: dummyBaseURL)
                }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Keep empty to prevent scroll updates from cutting playback
    }
}
