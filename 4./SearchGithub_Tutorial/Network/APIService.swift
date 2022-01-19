//
//  APIService.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import Alamofire
import RxSwift
import Foundation

let baseURL = "https://api.github.com/search/repositories"

final class APIService {
    
    static let shared = APIService()
    
    // MARK: API Call
    fileprivate func requestAPI<T: Decodable>(
        url: String,
        parameters: Parameters,
        headers: HTTPHeaders,
        decode: T.Type
        ) -> Single<T> {
        
        print("[REQUEST URL] [\(url)]")
        print("[REQUEST PARAMS] -> \(parameters)")
        print("[REQUEST HEADERS] -> [\(headers)]")
        
        return Single.create { single in
            let request = AF.request(
                url,
                method: .post,
                parameters: parameters,
                headers: headers
            )
            .responseData { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("[RESPONSE] -> \(utf8Text)")
                }
                switch response.result {
                case let .success(jsonData):
                    do {
                        let data = try JSONDecoder().decode(decode, from: jsonData)
                        single(.success(data))
                    }
                    catch let e {
                        print("[RESPONSE DECODE ERROR] -> \(e.localizedDescription)")
                        single(.failure(e))
                    }
                case let .failure(e):
                    print("[RESPONSE ERROR] -> [\(e.responseCode)] reason:\(String(describing: e.failureReason)) description:\(e.localizedDescription) ")
                    single(.failure(e))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    // MARK: 검색
    
    func searchRepo(
        page: Int,
        query: String
    ) -> Single<GithubResponse.Github> {
        
        let parameters: [String : Any] = [
            "page": page,
            "query": query
        ]
        
        return requestAPI(
            url: baseURL,
            parameters: parameters,
            headers: [:],
            decode: GithubResponse.Github.self
        )
    }
}
