//
//  APIClient.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

enum HTTPMethod: String {
    case GET
    case POST
}

enum APIError: Error {
    case failedFetchingData
    case custom(message: String)
}

import UIKit
import Foundation

final class APIClient {
    static let shared = APIClient()

    init() {}

    struct Constants {
        static let baseUrl = "https://api.spotify.com/v1"
    }

    public func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl+"/me"),
                      type: .GET) { request in

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedFetchingData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    if let result = String(data: data, encoding: .utf8) {
                        completion(.failure(APIError.custom(message: result)))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }

    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthenticationManager.shared.validateToke { token in
            guard let url = url else { return }

            let header =  ["Accept": "application/json",
                           "Content-Type": "application/json",
                           "Authorization":"Bearer \(token)"]
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = header
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
