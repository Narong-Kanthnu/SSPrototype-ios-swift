//
//  VideoFeedCell.swift
//  SSPrototype
//
//  Created by Narong Kanthanu on 23/10/2561 BE.
//  Copyright © 2561 Narong Kanthanu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher
import UIImageColors
import MarqueeLabel

class VideoFeedCell: UICollectionViewCell {
    
    static let cellId = "VideoFeedCell"
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoDescription: MarqueeLabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var videoFeeds: VideoFeeds? {
        didSet {
            self.didDataSet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setVideoDescriptionMarqueeLebel()
        self.setPlayButtonBackground()
        self.setGestureRecognizer()
        self.headerView.setGradientBackground(startColor: UIColor.darkGray, endColor: UIColor.clear, angle: 270)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.videoFeeds != nil {
            self.videoFeeds = nil
        }
    }
    
    @IBAction func playButtonClicked(sender: UIButton) {
        sender.shakesAnimation()
        self.player.timeControlStatus == .playing ? self.player.pause() : self.player.play()
    }
    
    private func didDataSet() {
        if let videoFeed = videoFeeds {
            self.videoName.text = videoFeed.title
            self.videoDescription.text = videoFeed.videoDescription
            self.setItemCollorFromThumbnail(imageUrl: videoFeed.thumb!)
            self.setVideoViewFromUrl(videoUrl: URL(string: videoFeed.sources![0])!)
            self.setVideoViewLayer()
        }else {
            self.reusingData()
        }
    }
    
    private func reusingData() {
        self.videoName.text = nil
        self.videoDescription.text = nil
    }
    
    private func setGestureRecognizer() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(draggingView))
            gestureRecognizer.direction = direction
            self.addGestureRecognizer(gestureRecognizer)
            self.isUserInteractionEnabled = true
            self.isMultipleTouchEnabled = true
        }
    }
    
    private func setItemCollorFromThumbnail(imageUrl: URL) {
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
            if let image = image {
                image.getColors { colors in
                    self.videoView.backgroundColor = colors.background
                }
            }
        })
    }
    
    private func setPlayButtonBackground() {
        let bgImage = UIImage(asset: Asset.Button.icShakesButtonBg).resizedImage(newSize: CGSize(width: self.playButton.bounds.width, height: self.playButton.bounds.height))

        let playButtonBgView = UIView()
        playButtonBgView.backgroundColor = UIColor(patternImage: bgImage)
        playButtonBgView.translatesAutoresizingMaskIntoConstraints = false
        self.footerView.addSubview(playButtonBgView)
        self.footerView.addSubview(self.playButton)
        playButtonBgView.widthAnchor.constraint(equalToConstant: self.playButton.bounds.width).isActive = true
        playButtonBgView.heightAnchor.constraint(equalToConstant: self.playButton.bounds.height).isActive = true
        playButtonBgView.trailingAnchor.constraint(equalTo: self.playButton.layoutMarginsGuide.trailingAnchor, constant: 12).isActive = true
        playButtonBgView.bottomAnchor.constraint(equalTo: self.playButton.layoutMarginsGuide.bottomAnchor, constant: 12).isActive = true
    }

    private func setVideoViewFromUrl(videoUrl: URL) {
        let item = CachingPlayerItem(url: videoUrl, customFileExtension: "mp4")
        self.player = AVPlayer(playerItem: item)
        self.player.actionAtItemEnd = .none
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.frame = self.bounds
    }
    
    private func setVideoViewLayer() {
        self.videoView.layer.addSublayer(self.playerLayer)
        self.videoView.layer.addSublayer(self.headerView.layer)
        self.videoView.layer.addSublayer(self.footerView.layer)
        self.videoView.layer.masksToBounds = true
        self.videoView.layer.cornerRadius = 8.0
    }
    
    private func setVideoDescriptionMarqueeLebel() {
        self.videoDescription.tag = 501
        self.videoDescription.type = .continuous
        self.videoDescription.speed = .duration(30)
        self.videoDescription.fadeLength = 10.0
        self.videoDescription.trailingBuffer = 30.0
    }
    
    @objc func draggingView(_ sender: UISwipeGestureRecognizer) {
        let views = [self.videoName, self.videoDescription, self.footerView]
        UIView.animate(withDuration: 1.0) {
            if sender.direction == .right {
                for view in views {
                    view!.frame = CGRect(x: self.frame.size.width, y: view!.frame.origin.y , width: view!.frame.size.width, height: view!.frame.size.height)
                    view!.layoutIfNeeded()
                    view!.setNeedsDisplay()
                }
            } else {
                for view in views {
                    view!.frame = CGRect(x: 20, y: view!.frame.origin.y , width: view!.frame.size.width, height: view!.frame.size.height)
                    if view == self.footerView {
                        view!.frame = CGRect(x: 0, y: view!.frame.origin.y , width: view!.frame.size.width, height: view!.frame.size.height)
                    }
                    view!.layoutIfNeeded()
                    view!.setNeedsDisplay()
                }
            }
        }
    }
}

