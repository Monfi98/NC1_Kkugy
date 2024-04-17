//
//  OpenAIService.swift
//  Kkugy
//
//  Created by 신승재 on 4/15/24.
//

import Alamofire

class NetworkManager {

    static let shared = NetworkManager()
    
    private let baseURL = "https://api.openai.com/v1"
    
    private init() {}
    
    func sendMessage(messages: [Message], newMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/chat/completions"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiKey.API_KEY)",
            "Content-Type": "application/json"
        ]
        
        
        var messagePayloads: [[String: Any]] = messages.map { message in
            ["role": message.isSender ? "user" : "system", "content": message.text!]
        }
        
        messagePayloads.append(["role": "system", "content": "이제부터는 친구처럼 편하게 반말로 대화하기. 꼭맞춤법을 맞추지 않기, 예를들면 안하겟어, 20대처럼 말해봐"])
        messagePayloads.append(["role": "user", "content": newMessage])
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-0125",
            "messages": messagePayloads,
            "max_tokens": 150
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ChatCompletionResponse.self) { response in
            switch response.result {
            case .success(let chatResponse):
                if let messageContent = chatResponse.choices.first?.message.content {
                    completion(.success(messageContent))
                } else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendMessageForTitle(messages: [Message], completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/chat/completions"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiKey.API_KEY)",
            "Content-Type": "application/json"
        ]
        
        
        var messagePayloads: [[String: Any]] = messages.map { message in
            ["role": message.isSender ? "user" : "system", "content": message.text!]
        }
        
        messagePayloads.append(["role": "system", "content": "지금 받은 대화 내용을 15글자 이내로 요약해서 제목을 만들어줘. 내가 바로 쓸 수 있게 딱 제목만 한줄로 출력해서줘"])
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-0125",
            "messages": messagePayloads,
            "max_tokens": 150
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ChatCompletionResponse.self) { response in
            switch response.result {
            case .success(let chatResponse):
                if let messageContent = chatResponse.choices.first?.message.content {
                    completion(.success(messageContent))
                } else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
