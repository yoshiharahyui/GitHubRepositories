//
//  RepositoryCellTableViewCell.swift
//  GitHubRepositories
//
//  Created by 吉原飛偉 on 2024/06/24.
//

import UIKit
import SDWebImage

class RepositoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var ownerImageView: UIImageView! {
        didSet {
            ownerImageView.layer.cornerRadius = 10
            ownerImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var repositoryNameLabel: UILabel! {
        didSet {
            repositoryNameLabel.textColor = UIColor.link
        }
    }
    @IBOutlet weak var startImageView: UIImageView! {
        didSet {
            startImageView.image = UIImage(named: "star")
            startImageView.tintColor = UIColor.systemGray
        }
    }
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    //RepositoryCellのクラスの名前を文字列としてcellIdentifierに格納する
    static let cellIdentifier = String(describing: RepositoryCell.self)
    
    func configure(repository: Repository) {
            ownerNameLabel.text = repository.owner.login
            repositoryNameLabel.text = repository.fullName

            if let url = repository.avatarImageUrl {
                ownerImageView.sd_setImage(with: url, completed: nil)
            } else {
                ownerImageView.image = nil
            }

            repositoryDescriptionLabel.text = repository.description ?? ""
            starCountLabel.text = "\(repository.stargazersCount)"
            languageLabel.text = repository.language
            accessoryType = .disclosureIndicator
        }
}
