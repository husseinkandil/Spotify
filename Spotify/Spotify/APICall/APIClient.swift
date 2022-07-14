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

protocol UserProfileAPIClient: AnyObject {
    func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
}

final class APIClient: UserProfileAPIClient {
    static let shared = APIClient()

    init() {}

    struct Constants {
        static let baseUrl = "https://api.spotify.com/v1"
    }

    func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
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

    public func getartistProfile(artist: String,completion: @escaping (Result<ArtistsSearchResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl+"/search?q=\(artist)&type=artist&limit=50"),
                      type: .GET) { request in

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedFetchingData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(ArtistsSearchResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getArtistAlbum(id: String ,completion: @escaping (Result<Album, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl+"/artists/\(id)/albums"),
                      type: .GET) { request in

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedFetchingData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(Album.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    completion(.failure(error))
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
