//
//  OpenAIModel.swift
//  Kkugy
//
//  Created by 신승재 on 4/15/24.
//

import Foundation


struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}


struct Choice: Codable {
    let finishReason: String
    let index: Int
    let message: ChatMessage
    
    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index
        case message
    }
}

struct ChatMessage: Codable {
    let content: String
    let role: String
}
