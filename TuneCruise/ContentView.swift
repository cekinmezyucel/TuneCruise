import SwiftUI
import AVFoundation

struct ContentView: View {
    // Create an AVPlayer instance
    @State private var player: AVPlayer?
    @State private var isPlaying = false

    var body: some View {
        VStack {
            if let player = player {
                // Display the play/pause button based on the playback state
                Button(action: {
                    if isPlaying {
                        player.pause()
                    } else {
                        player.play()
                    }
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            // Create a URL object from the streaming URL
            // https://orf-live.ors-shoutcast.at/oe3-q2a
            // https://orf-live.ors-shoutcast.at/wie-q2a
            guard let url = URL(string: "https://orf-live.ors-shoutcast.at/wie-q2a") else {
                fatalError("Invalid URL")
            }
            
            // Create an AVPlayerItem using the URL
            let playerItem = AVPlayerItem(url: url)
            
            // Initialize the AVPlayer with the player item
            player = AVPlayer(playerItem: playerItem)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
