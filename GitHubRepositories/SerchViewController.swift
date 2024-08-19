//
//  SerchViewController.swift
//  GitHubRepositories
//
//  Created by 吉原飛偉 on 2024/06/24.
//

import Foundation
import UIKit
import JGProgressHUD

class SearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "リポジトリを検索できるよ！"
            searchBar.delegate = self
        }
    }
    
    private var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    //アラート
    private func showAlert(title: String, message: String = "") -> UIAlertController {
            let alert: UIAlertController = UIAlertController(title: title, message : message, preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(defaultAction)
            return alert
    }
    
    private func wrongError() -> UIAlertController {
            return showAlert(title: "不正なワードの入力", message: "検索ワードの確認を行ってください")
    }

        private func networkError() -> UIAlertController {
            return showAlert(title: "インターネットの非接続", message: "接続状況の確認を行ってください")
    }

        private func parseError() -> UIAlertController {
            return showAlert(title: "データの解析に失敗しました")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.cellIdentifier, for: indexPath) as! RepositoryCell

            let repository = repositories[indexPath.row]
            cell.configure(repository: repository)
            return cell
    }
}

extension SearchViewController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        GitHubAPI.taskCancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()

        let progressHUD = JGProgressHUD()
        progressHUD.show(in: self.view)

        if let word = searchBar.text{
            GitHubAPI.fetchRepository(text: word) { result in
                DispatchQueue.main.async {
                    progressHUD.dismiss()
                }

                switch result {
                case .success(let items):
                    self.repositories = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        switch error {
                        case .wrong :
                            let alert = self.wrongError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        case .network:
                            let alert = self.networkError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        case .parse:
                            let alert = self.parseError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
        }
        return
    }
}
