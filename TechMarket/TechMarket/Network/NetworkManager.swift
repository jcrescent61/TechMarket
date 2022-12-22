//
//  NetworkManager.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

import RxSwift

protocol Requester {
    func request(urlRequest: URLRequest,
                 completion: @escaping (Result<URLSession.Response?, Swift.Error>) -> Void
    )
}

extension URLSession: Requester {
    struct Response {
        let data: Data?
        let status: Int
    }
    
    func request(
        urlRequest: URLRequest,
        completion: @escaping (Result<Response?, Error>) -> Void
    ) {
        dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completion(.success(.init(data: data, status: response.statusCode)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Unknown Networker Error", code: -999, userInfo: nil)))
            }
        }.resume()
    }
}


protocol Networkerable {
    func request<T: Decodable>(
        _ api: ServerAPI,
        dataType: T.Type
    ) -> Single<T>
}

class Networker {
    
    private var baseURL: String = "https://openmarket.yagom-academy.kr"
    
    private lazy var header: [String: Any] = {
        return [:]
    }()
    
    private let requester: Requester
    
    init(
        requester: Requester = URLSession(configuration: .default)
    ) {
        self.requester = requester
    }
}

extension Networker: Networkerable {
    func request<T: Decodable>(
        _ api: ServerAPI,
        dataType: T.Type
    ) -> Single<T> {
        switch api.method {
        case .get:
            var urlComponents = URLComponents(string: self.baseURL + api.path)
            
            var parameters: [URLQueryItem] = []
            api.params?.forEach({ key, value in
                parameters.append(URLQueryItem(name: key, value: String(describing: value)))
            })
            
            urlComponents?.queryItems = parameters
            
            guard let url = urlComponents?.url else {
                return .error(NSError(domain: "URL Not Found", code: -998))
            }
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = api.method.rawValue
            
            self.header.forEach { key, value in
                urlRequest.addValue(String(describing: value), forHTTPHeaderField: key)
            }
            
            return request(urlRequest: urlRequest)
            
        case .post, .put, .delete:
            let urlComponents = URLComponents(string: self.baseURL + api.path)
            
            guard let url = urlComponents?.url else {
                return Single.error(NSError(domain: "URL Not Found", code: -998))
            }
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = api.method.rawValue
            
            let jsonData = try? JSONSerialization.data(withJSONObject: api.params ?? [:])
            urlRequest.httpBody = jsonData
            
            self.header.forEach { key, value in
                urlRequest.addValue(String(describing: value), forHTTPHeaderField: key)
            }
            
            return request(urlRequest: urlRequest)
        }
    }
}

private extension Networker {
    func request<T: Decodable>(
        urlRequest: URLRequest
    ) -> Single<T> {
        return Single<T>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "UnKnown Error", code: -999)))
                return Disposables.create()
            }
            
            self.requester.request(urlRequest: urlRequest) { result in
                switch result {
                case .success(let response):
                    if let data = response?.data {
                        guard let json = try? JSONDecoder().decode(T.self, from: data) else {
                            return single(.failure(NSError(domain: "JSONParsing Error", code: -996)))
                        }
                        return single(.success(json))
                    } else {
                        return single(.failure(NSError(domain: "Data Parsing Error", code: -997)))
                    }
                case .failure(let error):
                    return single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
