//
//  Repository.swift
//  GitHubRepositories
//
//  Created by 吉原飛偉 on 2024/06/25.
//

import Foundation
import UIKit

//RepositoriesがCodableプロトコルに準拠
//これにより、この構造体のインスタンスをJSONなどの形式にエンコード（変換）したり、JSONからデコード（復元）したりすることが容易になります
struct Repositories: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let name: String
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let description: String?

    let owner: Owner

    var avatarImageUrl: URL? {
        return URL(string: owner.avatarUrl)
    }
}

struct Owner: Codable {
    //所有者のアバター画像のURLを表す文字列プロパティ
    let avatarUrl: String
    //所有者のログイン名（ユーザー名）を表す文字列プロパティ
    let login: String
}
