//
//  GestureRecognizerService.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 22/03/2024.
//

import UIKit
import MediaPipeTasksVision

class GestureRecognizerService: NSObject {
    private var handGestureRecognizer: GestureRecognizer?
    private let processor = GestureRecognizerResultProcessor()

    override init() {
        super.init()
        configureHandGestureRecognizer()
    }
    
    private func configureHandGestureRecognizer() {
        do {
            let modelPath = Bundle.main.path(forResource: "gesture_recognizer", ofType: "task")!
            let options = GestureRecognizerOptions()
            options.baseOptions.modelAssetPath = modelPath
            options.runningMode = .liveStream
            options.gestureRecognizerLiveStreamDelegate = processor
            handGestureRecognizer = try GestureRecognizer(options: options)
        } catch {
            print("Error initializing hand gesture recognizer: \(error)")
        }
    }
    
    func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        do {
            let image = try MPImage(sampleBuffer: sampleBuffer)
            let timestamp = Int(CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds) * 1000
            try handGestureRecognizer?.recognizeAsync(image: image, timestampInMilliseconds: timestamp)
        } catch {
            print("Error processing sample buffer: \(error)")
        }
    }
    
    func setGestureRecognitionDelegate(_ delegate: GestureRecognitionDelegate?) {
        processor.delegate = delegate
    }
}
