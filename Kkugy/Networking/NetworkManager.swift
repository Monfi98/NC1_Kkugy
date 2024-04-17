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
    
    func categorizeForSummary(chatRooms: [ChatRoom], completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/chat/completions"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiKey.API_KEY)",
            "Content-Type": "application/json"
        ]
        
        let messages = chatRooms.flatMap { chatRoom in
            guard let messagesSet = chatRoom.messages as? Set<Message> else { return [] }
            return Array(messagesSet)
        }
        
        
        var messagePayloads: [[String: Any]] = [
            ["role": "system", "content": "이제부터 제공되는 채팅 데이터를 기반으로 일기를 작성해 주세요. 채팅 데이터는 다음과 같습니다."]
        ]
        
        
        messagePayloads.append(contentsOf: messages.map { message in
            ["role": (message as AnyObject).isSender ? "user" : "system", "content": (message as AnyObject).text ?? ""]
        })

        
        messagePayloads.append(["role": "system", "content": "일기는 마치 사용자가 직접 작성한 것처럼 자연스럽게 써 주세요. 특정 질문이나 요청 없이, 데이터를 바탕으로 일상의 사건, 생각, 감정을 표현하는 형태로 작성해 주세요. 사용자의 입장에서 일기가 쓰여질 것입니다. 문체는 친근하고 개인적인 톤으로 유지하며, 너무 공식적이거나 기계적인 언어는 사용하지 마세요. 맨위에 한줄은 제목을 출력해주세요."])
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-0125",
            "messages": messagePayloads,
            "max_tokens": 500
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
