//
//  SFSymbols.swift
//  GitHubRepositories
//
//  Created by 吉原飛偉 on 2024/06/25.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(systemName: String, tintColor: UIColor) {
            self.image = UIImage(systemName: systemName)
            self.tintColor = tintColor
        }
}
