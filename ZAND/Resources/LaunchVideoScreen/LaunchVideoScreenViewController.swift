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
        guard let path = Bundle.main.path(
            forResource: Config.splash_video,
            ofType: Config.splash_video_type
        ) else {
            debugPrint("splash_video is not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        view.layer.addSublayer(playerLayer)
        player.seek(to: CMTime.zero)
        player.play()
    }
}
