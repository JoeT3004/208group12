//
//  ModelFiles.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 18/03/2024.
//

import Foundation

struct QuestionType1: QuestionTypes {
    var text: String
    var videoFileName: String?
    var answers: [Answer]
}

struct QuestionType2: QuestionTypes {
    var text: String
    var answers: [Answer]
}

struct Quiz {
    let title: String
    let type: QuizType
    let questions: [QuestionTypes]
}


struct Answer {
    let text: String
    let correct: Bool
}

enum QuizType {
    case BSLtoEnglish
    case EnglishtoBSL
}


protocol QuestionTypes{
    var text: String { get }
    var answers: [Answer] { get }
    //hand gesture variable
}


