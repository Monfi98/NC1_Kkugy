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
        
        messagePayloads.append(["role": "system", "content": "이 채팅은 한국에서 20대 친구들 사이에서 이루어지고 있습니다. 이들은 일상생활, 재미있는 사건, 일과 관련된 상황 등을 느긋하고 친근한 말투로 나눕니다. 특히 매우 편안하고 익숙한 언어를 사용하여 친구와 소통합니다. 이러한 특성을 반영하여 대화에서 자연스러운 채팅 메시지를 생성해 주세요. 또한, 대화가 자연스럽게 지속될 수 있도록 궁금증을 유발하거나 추가적인 설명을 요구하는 질문을 포함해 주세요. 질문은 한번에 한가지만 해주세요. 또, 맞춤법은 꼭 맞지않아도 됩니다. 예를 들어, 친구의 최근 경험에 대해 물어보거나, 공유된 링크나 사진에 대한 반응을 유도하는 방식입니다. 메시지는 친구들 사이의 일상적인 대화에서 나올 법한 내용으로, 자연스러움과 친밀감을 유지하며 대화를 계속 이끌어 나가야 합니다. 그리고 저 위에 주어진 대화의 맥락을 고려하여, 이들이 공유할 만한 콘텐츠, 정보, 감정적 반응을 포함해 주세요. max tokens는 150이니까 이것을 고려해서 끊기지 않도록 해주세요."
])
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
        
        messagePayloads.append(["role": "system", "content": "다음은 한 채팅방에서 나눈 대화의 내용입니다. 이 대화 내용을 요약하여, 주요 주제나 이슈를 담은 제목을 한 줄로 만들어 주세요. 제목은 간결하고 명확하게, 대화의 주된 내용을 반영할 수 있도록 작성해야 합니다. 주제를 정확히 파악하고 간략하게 표현해주세요. 20글자 이내로 해주세요."])
        
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
        print(#function)
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

        
        messagePayloads.append(["role": "system", "content": "일기는 마치 사용자가 직접 작성한 것처럼 자연스럽게 써 주세요. 특정 질문이나 요청 없이, 데이터를 바탕으로 일상의 사건, 생각, 감정을 표현하는 형태로 작성해 주세요. 사용자의 입장에서 일기가 쓰여질 것입니다. 문체는 친근하고 개인적인 톤으로 유지하며, 너무 공식적이거나 기계적인 언어는 사용하지 마세요."])
        
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
