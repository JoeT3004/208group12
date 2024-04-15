//
//  VideoPlayerViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 08/04/2024.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoNameLabel: UILabel!
    
    @IBOutlet weak var videoContainerView: UIView!
    
    var videoAsset: AVAsset?
    var videoName: String?

    // Add a property for AVPlayer
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        videoNameLabel.text = "This BSL sign means, '\(videoName ?? "video name unknown")'"
        setupVideoPlayer()
    }

    
    //simple video player
    func setupVideoPlayer() {
        guard let videoAsset = videoAsset else { return }
        let playerItem = AVPlayerItem(asset: videoAsset)
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoContainerView.bounds
        videoContainerView.layer.addSublayer(playerLayer)

        //Add observer to loop the video indefinetly
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

        player?.play()
    }

    @objc func loopVideo(notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }

}
