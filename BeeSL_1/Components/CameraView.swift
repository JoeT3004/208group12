//
//  CameraView.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 19/03/2024.
//

import UIKit
import AVFoundation

//used to display video feed
class CameraView: UIView {

    //reference to display the video captured by the camera
    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected preview for type layer")
        }
        return layer
    }
    
    //overide layer class to return to preview layer
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    
    //Initializer for creating the view programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        //sets background of the camera view to black
        self.backgroundColor = .black
        //setupCameraSession() //starts camera session
    }
    //required
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
        //setupCameraSession()
    }
}
