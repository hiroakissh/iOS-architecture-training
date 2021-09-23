//
//  Repository.swift
//  GithubSearcher
//
//  Created by nakajima on 2021/09/22.
//

import Foundation

/// GithubのAPIが返すリポジトリのデータ。必要なプロパティのみを取得する
struct Repository: Codable, Identifiable {
    let id = UUID()
    let name: String
    let htmlUrl: String
    let description: String = ""
    let language: String
    let stargazersCount: Int
    let forksCount: Int

    private enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }
}
