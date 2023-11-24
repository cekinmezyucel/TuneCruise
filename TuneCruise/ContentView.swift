import SwiftUI
import AVFoundation

struct ContentView: View {
    let radioStations = [
        RadioStation(name: "Ö3", streamURL: "https://orf-live.ors-shoutcast.at/oe3-q2a"),
        RadioStation(name: "Wien", streamURL: "https://orf-live.ors-shoutcast.at/wie-q2a")
    ]
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var selectedStation: RadioStation?
    
    var body: some View {
        VStack {
            List(radioStations, id: \.self) { station in
                Button(action: {
                    selectStation(station)
                }) {
                    Text(station.name)
                }
                .foregroundColor(selectedStation == station ? .blue : .black)
            }
            Spacer()
            Button(action: {
                togglePlayPause()
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
    
    private func selectStation(_ station: RadioStation) {
        guard let url = URL(string: station.streamURL) else {
            print("Invalid URL")
            return
        }
        
        if let selected = selectedStation, selected == station {
            togglePlayPause()
        } else {
            selectedStation = station
            playStream(url)
        }
    }
    
    private func playStream(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
    }
    
    private func togglePlayPause() {
        if let player = player {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying.toggle()
        }
    }
}

struct RadioStation: Hashable {
    let name: String
    let streamURL: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
