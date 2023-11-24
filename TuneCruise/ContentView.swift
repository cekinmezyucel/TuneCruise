import SwiftUI
import AVFoundation

struct ContentView: View {
    // Radio stations
    @State private var selectedStationIndex = 0
    let radioStations = [
        RadioStation(name: "OE3", streamURL: "https://orf-live.ors-shoutcast.at/oe3-q2a"),
        RadioStation(name: "Radio Wien", streamURL: "https://orf-live.ors-shoutcast.at/wie-q2a")
    ]
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            // Clickable list of radio stations
            List(radioStations, id: \.name) { station in
                Button(action: {
                    playStation(streamURL: station.streamURL)
                    if let index = radioStations.firstIndex(where: { $0.name == station.name }) {
                        selectedStationIndex = index
                    }
                }) {
                    Text(station.name)
                }
            }
            .background(Color.gray.opacity(0.1))
            
            // Playback controls
            HStack {
                Button(action: playPrevious) {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .disabled(selectedStationIndex == 0)
                
                Spacer()
                
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
                .padding()
                
                Spacer()
                
                Button(action: playNext) {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .disabled(selectedStationIndex == radioStations.count - 1)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
        .padding()
    }
    
    func playStation(streamURL: String) {
        stopCurrentStation()
        
        // Create a URL object from the streaming URL
        guard let url = URL(string: streamURL) else {
            fatalError("Invalid URL")
        }
        
        // Create an AVPlayerItem using the URL
        let playerItem = AVPlayerItem(url: url)
        
        // Initialize the AVPlayer with the player item
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
    }
    
    func stopCurrentStation() {
        player?.pause()
        player = nil
        isPlaying = false
    }
    
    func togglePlayPause() {
        if let player = player {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying.toggle()
        }
    }
    
    func playNext() {
        if selectedStationIndex < radioStations.count - 1 {
            selectedStationIndex += 1
            let nextStation = radioStations[selectedStationIndex]
            playStation(streamURL: nextStation.streamURL)
        }
    }
    
    func playPrevious() {
        if selectedStationIndex > 0 {
            selectedStationIndex -= 1
            let previousStation = radioStations[selectedStationIndex]
            playStation(streamURL: previousStation.streamURL)
        }
    }
}

struct RadioStation: Identifiable {
    let id = UUID()
    let name: String
    let streamURL: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
