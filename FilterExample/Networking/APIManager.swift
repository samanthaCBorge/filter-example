//
//  APIManager.swift
//  FilterExample
//
//  Created by Samantha Cruz on 18/4/24.
//

import Combine
import Foundation

protocol HomeListStore {
    func readUsersList() -> Future<[UserReponse], Failure>
}

final class APIManager {
    
    private func request<T>(for stringURL: String) -> Future<T, Failure> where T : Codable {
        return Future { promise in
            
            guard let url = URL(string: stringURL) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data,
                      case .none = error else {
                    promise(.failure(.urlConstructError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(T.self, from: data)
                    promise(.success(searchResponse))
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}

extension APIManager: HomeListStore {
    func readUsersList() -> Future<[UserReponse], Failure> {
        let url = "https://jsonplaceholder.typicode.com/users"
        return request(for: url)
    }
}

