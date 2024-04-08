//
//  VideoViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 08/04/2024.
//

import UIKit
import AVFoundation


//Define a structure to hold video information
struct Video {
    var name: String
    var thumbnail: UIImage?
    var asset: AVAsset?
}

//Define a structure for a video category
struct VideoCategory {
    var title: String
    var videos: [Video]
}


class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Array of video categories
    var categories: [VideoCategory] = []
    
    func videoNames(forCategory title: String) -> [String] {
        switch title {
        case "Animals":
            return ["Cow", "Dog", "Fish", "Bird", "Cat", "Pig"]
        case "Basics":
            return ["How are you", "Maybe", "My name is"]
        case "Colours":
            return ["Red", "Green", "Blue"]
        case "Greetings":
            return ["Good Morning", "Good Evening", "Good Night"]
        default:
            return []
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //
        collectionView.register(VideoSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VideoSectionHeaderView.reuseIdentifier)
        
        // Load videos into categories
        loadVideos()
    }

    func loadVideos() {
        let categoryTitles = ["Animals", "Basics", "Colours", "Greetings"]
        
        categories = categoryTitles.map { title -> VideoCategory in
            let videoNames = videoNames(forCategory: title) // Get video names for the category
            let videos = videoNames.compactMap { name -> Video? in
                if let path = Bundle.main.path(forResource: name, ofType: "mp4") {
                    let asset = AVAsset(url: URL(fileURLWithPath: path))
                    let thumbnail = generateThumbnail(asset: asset)
                    return Video(name: name, thumbnail: thumbnail, asset: asset)
                }
                return nil
            }
            return VideoCategory(title: title, videos: videos)
        }
    }

    
    // Generate thumbnail for a video
    func generateThumbnail(asset: AVAsset) -> UIImage? {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
        let video = categories[indexPath.section].videos[indexPath.row]
        cell.thumbnailImageView.image = video.thumbnail
        cell.videoNameLabel.text = video.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // Adjust header height as needed
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VideoSectionHeaderView.reuseIdentifier, for: indexPath) as! VideoSectionHeaderView
        
        let categoryTitle = categories[indexPath.section].title
        header.configure(with: categoryTitle)
        
        return header
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = (collectionView.frame.size.width - (numberOfColumns - 1) * 10 - 20) / numberOfColumns
        return CGSize(width: width, height: width) // Adjust height based on your aspect ratio
    }
    
    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let cell = sender as? UICollectionViewCell, // Use the sender as the cell
           let indexPath = collectionView.indexPath(for: cell), // Correct method call
           let detailVC = segue.destination as? VideoPlayerViewController {
            
            let selectedVideo = categories[indexPath.section].videos[indexPath.row]
            detailVC.videoAsset = selectedVideo.asset
            detailVC.videoName = selectedVideo.name
        }
    }

    
    
}

