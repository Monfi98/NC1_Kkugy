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
    
    private init() {} // 싱글톤
    
    func sendMessage(message: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/chat/completions"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiKey.API_KEY)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-0125",
            "messages": [
                ["role": "system","content": "이제부터는 친구처럼 편하게 반말로 대화하기. 꼭맞춤법을 맞추지 않기, 예를들면 안하겟어, 20대처럼 말해봐"],
                ["role": "user", "content": message]
            ],
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
