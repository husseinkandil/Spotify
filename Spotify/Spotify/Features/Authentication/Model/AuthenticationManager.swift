//
//  AuthenticationManager.swift
//  Spotify
//
//  Created by Hussin Kandil on 18/05/2022.
//

import UIKit

final class AuthenticationManager {

    struct Constants {
        static let clientId = "e95850cd94094e7d83386c65ad4bfdeb"
        static let clientSecretId = "6232b7cfe9234e6caa579c588f741217"
        static let tokenURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.example.com"
        static let scope = "user-read-private"
        static let baseUrl = "https://accounts.spotify.com/authorize"
    }

    static let shared = AuthenticationManager()

    private var isRefreshing = false

    private init() {}

    public var signinURL: URL?{

        let string = "\(Constants.baseUrl)?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"

        return URL(string: string)
    }

    var isSignedIn: Bool {
        return accessToken != nil
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }

    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }

    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else { return false }

        let currentDate = Date()
        let tenMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(tenMinutes) >= tokenExpirationDate
    }

    public func generateToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let urlString = URL(string: Constants.tokenURL) else { return }
        var params = URLComponents()
        params.queryItems = [
            URLQueryItem.init(name: "grant_type", value: "authorization_code"),
            URLQueryItem.init(name: "code", value: code),
            URLQueryItem.init(name: "redirect_uri", value: "https://www.example.com"),
        ]

        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.httpBody = params.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let headerToken = Constants.clientId+":"+Constants.clientSecretId
        let data = headerToken.data(using: .utf8)
        guard let base64 = data?.base64EncodedString() else {
            completion(false)
            print("error encoding base64")
            return
        }
        request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data ,error == nil else {
                completion(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
                print(error.localizedDescription)
            }

        }
        task.resume()
    }

    public func refreshToken(completion: @escaping (Bool) -> Void) {
        guard !isRefreshing else { return }

        guard shouldRefreshToken else {
            completion(true)
            return
        }

        guard let refreshToken = refreshToken else { return }

        guard let urlString = URL(string: Constants.tokenURL) else { return }

        isRefreshing = true
        var params = URLComponents()
        params.queryItems = [
            URLQueryItem.init(name: "grant_type", value: "refresh_token"),
            URLQueryItem.init(name: "refresh_token", value: refreshToken),
        ]

        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.httpBody = params.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let headerToken = Constants.clientId+":"+Constants.clientSecretId
        let data = headerToken.data(using: .utf8)
        guard let base64 = data?.base64EncodedString() else {
            completion(false)
            print("error encoding base64")
            return
        }
        request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }

            self.isRefreshing = false
            guard let data = data ,error == nil else {
                completion(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                self.cacheToken(result: result)
                self.refresh.forEach {
                    $0(result.access_token)
                }
                self.refresh.removeAll()
                completion(true)
            } catch {
                completion(false)
                print(error.localizedDescription)
            }

        }
        task.resume()


    }

    private var refresh = [((String) -> Void)]()

    public func validateToke(completion: @escaping (String) -> Void) {
        guard !isRefreshing else {
            refresh.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshToken { [weak self] success in
                guard let self = self else { return }

                if let token = self.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }

    public func cacheToken(result: AuthenticationResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }

    public func signout(completion: @escaping (Bool) -> Void) {
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "refresh_token")
        UserDefaults.standard.set(nil, forKey: "expirationDate")

        completion(true)
    }
}
