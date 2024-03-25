//
//  GestureRecognizerResultProcessor.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 22/03/2024.
//

import MediaPipeTasksVision

class GestureRecognizerResultProcessor: NSObject, GestureRecognizerLiveStreamDelegate {
    weak var delegate: GestureRecognitionDelegate?
    
    func gestureRecognizer(_ gestureRecognizer: GestureRecognizer, didFinishRecognition result: GestureRecognizerResult?, timestampInMilliseconds: Int, error: Error?) {
        //Example processing, adapt based on actual result structure
        guard let result = result else { return }
        //Assuming result contains a way to get the recognized gesture as a String
        let recognizedGesture = "" //Placeholder, options. here
        delegate?.didRecognizeGesture(recognizedGesture)
    }
}
