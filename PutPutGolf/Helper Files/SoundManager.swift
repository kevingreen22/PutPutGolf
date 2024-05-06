//
//  SoundManager.swift
//  PutPutGolf
//
//  Created by Kevin Green on 5/2/24.
//

import SwiftUI
import AVKit

public class SoundManager {
    
    static let instance = SoundManager()
    
    private var player: AVAudioPlayer?
    
    private init() { }
    
    /// Plays a sound file contained in the main bundle.
    func playeffect(_ forResource: String, withExtension: String? = ".mp3") throws {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            throw error
        }
    }
    
    /// Plays a sound file contained in the main bundle.
    func playeffect(_ forResource: String, withExtension: String? = ".mp3") async throws {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            throw error
        }
    }
    
}

