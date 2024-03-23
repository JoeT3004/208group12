//
//  CameraViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 19/03/2024.
//


import UIKit
import AVFoundation
import MediaPipeTasksVision


//Moved the calls to startRunning and stopRunning to a background thread by wrapping them in DispatchQueue.global(qos: .userInitiated).async.
//Ensured setupAVSession runs its session configuration in a background thread to not block the UI while setting up the camera. However, updating the previewLayer is dispatched back to the main thread

//Manages camera live feed using AVFoundation
final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //holds session which holds data from camera input device to the output
    private var cameraFeedSession: AVCaptureSession?
    
    private var gestureRecognizerService: GestureRecognizerService?

    
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
            
            let session = AVCaptureSession()
            
            session.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(videoInput) else {
                print("Failed to create video input")
                return
            }
            
            session.addInput(videoInput)
            
            let dataOutput = AVCaptureVideoDataOutput()
            if session.canAddOutput(dataOutput) {
                session.addOutput(dataOutput)
                dataOutput.alwaysDiscardsLateVideoFrames = true
                dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraFeedOutputQueue", qos: .userInteractive))
            } else {
                print("failed to add video data output")
                session.commitConfiguration()
                return
            }
            session.commitConfiguration()
            
            //main thread
            DispatchQueue.main.async { [weak self] in
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    //Configures the preview layer to display the video feed
                    let previewLayer = self.cameraView.previewLayer
                    previewLayer.session = session
                    previewLayer.frame = self.cameraView.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    
                    //Initialize the gesture recognizer service
                    self.gestureRecognizerService = GestureRecognizerService()
                }

            }
            
            
            self.cameraFeedSession = session
        }
        
        

    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        gestureRecognizerService?.processSampleBuffer(sampleBuffer)

    }
}
