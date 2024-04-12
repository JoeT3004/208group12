//
//  CameraViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 19/03/2024.
//


import UIKit
import AVFoundation



//Moved the calls to startRunning and stopRunning to a background thread by wrapping them in DispatchQueue.global(qos: .userInitiated).async.
//Ensured setupAVSession runs its session configuration in a background thread to not block the UI while setting up the camera. However, updating the previewLayer is dispatched back to the main thread

//Manages camera live feed using AVFoundation
final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //holds session which holds data from camera input device to the output
    private var cameraFeedSession: AVCaptureSession?
    
    //sets to instance of camera view
    override func loadView() {
        view = CameraView()
    }
  //Create a computed property called cameraView to access the root view as CameraView. You can safely force cast here because you recently assigned an instance of CameraView to view in step one.
    private var cameraView: CameraView {
        return view as! CameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVSession()
    }
    //starts session when view appears on screen
    //background thread avoids ui
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraFeedSession?.startRunning()
        }
    }
    
    //stops session before view disappears
    //background thread
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraFeedSession?.stopRunning()
        }
        super.viewWillDisappear(animated)
    }
    
    private func setupAVSession() {
        //dispatch to allow to work with ui
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraFeedSession = AVCaptureSession()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.cameraFeedSession?.canAddInput(videoInput) ?? false else {
                print("Failed to create video input")
                return
            }
            
            self.cameraFeedSession?.addInput(videoInput)
            
            let dataOutput = AVCaptureVideoDataOutput()
            if self.cameraFeedSession?.canAddOutput(dataOutput) ?? false {
                self.cameraFeedSession?.addOutput(dataOutput)
                dataOutput.alwaysDiscardsLateVideoFrames = true
                dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive))
            } else {
                print("Failed to add video data output")
                return
            }
            //main thread
            DispatchQueue.main.async { [weak self] in
                //configures the preview layer to display the video feed
                self?.cameraView.previewLayer.session = self?.cameraFeedSession
                self?.cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
        }
    }
}
