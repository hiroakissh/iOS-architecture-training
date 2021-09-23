//
//  GithubModel.swift
//  GithubSearcher
//
//  Created by nakajima on 2021/09/22.
//

import Foundation

/// GithubのREST APIを叩いて、結果を返すクラス
class GithubModel: ObservableObject {
    @Published var users = [User]()
    @Published var isNotFound = false
    @Published var error: ModelError?

    private var endpoint: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        return components
    }

    /// QueryをもとにGithubのユーザー検索APIを叩いて、結果をPublishする
    public func fetchUser(query: String) {
        users = [User]()
        error = nil
        isNotFound = false

        guard let url = userSearchEndpoint(query: query) else { return }

        Task {
            let result = await fetch(url: url)

            switch result {
            case .success(let data):
                guard let users = try? JSONDecoder().decode(Users.self, from: data) else {
                    error = .jsonParseError(String(data: data, encoding: .utf8) ?? "")
                    return
                }

                publishUsers(users: users)
            case .failure(let error):
                self.error = .responseError(error)
            }
        }
    }

    private func userSearchEndpoint(query: String) -> URL? {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            error =  .encodingError
            return nil
        }

        var urlComponents = endpoint
        urlComponents.path = "/search/users"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: encodedQuery)]
        guard let url = urlComponents.url else {
            error = .urlError
            return nil
        }

        return url
    }

    @MainActor
    private func fetch(url: URL) async -> Result<Data, Error> {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

    private func publishUsers(users: Users) {
        if users.totalCount == 0 {
            isNotFound = true
            self.users = [User]()
            return
        }
        self.users = users.items
    }
}
