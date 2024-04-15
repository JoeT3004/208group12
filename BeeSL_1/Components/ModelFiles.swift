//
//  ModelFiles.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 18/03/2024.
//

import Foundation
import UIKit
import AVFoundation


struct User: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let password: String
}


//defines BSL->English quesiton type = 1
struct QuestionType1: QuestionTypes {
    var text: String //prompt of question (label)
    var videoFileName: String? //file name for video which is optional
    var answers: [Answer] //possible answers
}
//defines English->BSL quesiton type = 2
struct QuestionType2: QuestionTypes {
    var text: String //prompt of question (label)
    var answers: [Answer]
}

//Quiz structure which is a collection of quesitions listed in QuizOptionViewController
struct Quiz {
    let title: String
    //The type of quiz as either BSLtoEnglish or EnglishtoBSL
    let type: QuizType
    //seems like it allows for mixed quesiton types but does not
    let questions: [QuestionTypes]
}

//answer for questions
struct Answer {
    let text: String
    let correct: Bool //indicates whether answer is correct
}

//enumarates quiz type supported
enum QuizType {
    case BSLtoEnglish
    case EnglishtoBSL
}

//defines requiresments for quesiton type
protocol QuestionTypes{
    var text: String { get }
    var answers: [Answer] { get }
    //hand gesture variable
}

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

