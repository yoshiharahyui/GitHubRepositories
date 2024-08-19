//
//  GitHubAPI.swift
//  GitHubRepositories
//
//  Created by 吉原飛偉 on 2024/06/25.
//

import Foundation

class GitHubAPI {
    private static var task: URLSessionTask?
    
    enum FetchRepositoryError: Error {
        case wrong
        case network
        case parse
    }
    
    static func fetchRepository(text: String, completionHandler: @escaping (Result<[Repository], FetchRepositoryError>) -> Void) {
        if !text.isEmpty {
            //GitHub APIを使用してリポジトリを検索するためのURLを作成
            let urlString = "https://api.github.com/search/repositories?q=\(text)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            //文字列からURLオブジェクトを作成し、その成功・失敗に応じて処理を分岐させる
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(FetchRepositoryError.wrong))
                return
            }
            //URLSessionを使用してネットワークリクエストを作成
            let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
                //レスポンスデータを受け取りエラーチェックを行う
                            if err != nil {
                                completionHandler(.failure(FetchRepositoryError.network))
                                return
                            }

                            guard let safeData = data else {return}
                
                            //JSONDecoderでデコードする
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            //データの処理
                            do {
                                let decodedData = try decoder.decode(Repositories.self, from: safeData)
                                completionHandler(.success(decodedData.items))

                            } catch  {
                                completionHandler(.failure(FetchRepositoryError.parse))
                            }
                        }
                        //タスクの実行
                        task.resume()
                }
            }
            static func taskCancel() {
                task?.cancel()
            }
        }

