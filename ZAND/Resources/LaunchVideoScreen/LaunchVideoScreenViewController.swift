//
//  LaunchVideoScreenViewController.swift
//  ZAND
//
//  Created by Василий on 15.05.2023.
//

import UIKit
import AVKit
import AVFoundation

final class LaunchVideoScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private let videoController = AVPlayerViewController()

    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playVideo()
    }
}

extension LaunchVideoScreenViewController {
    
    // MARK: - Instance methods
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splash_video", ofType: "mp4") else {
            debugPrint("splash_video is not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        videoController.showsPlaybackControls = false
        videoController.player = player
        videoController.videoGravity = .resizeAspectFill
        present(videoController, animated: true) {
            player.play()
        }
    }
}
