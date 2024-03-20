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
    
    /*
    //standard function to set up the camera session to capture live video feed
    private func setupCameraSession() {
        let captureSession = AVCaptureSession()
        
        //tries to get default camera device
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            //creats input with video capture device
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            
            //camera may not be avaliable
            return
        }
        //checks if seesion can work with the video input
        if (captureSession.canAddInput(videoInput)) {
            
            captureSession.addInput(videoInput)
        } else {
            return
            //cant be added to session
        }
        
        //preview layer with the capture function
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.bounds //preview to fill bounds of the view created
        previewLayer.videoGravity = .resizeAspectFill //
        self.layer.addSublayer(previewLayer) //Adds the preview layer as a sublayer of the camera views layer
        self.previewLayer = previewLayer
        
        captureSession.startRunning() //starts session
    }
     */
}
