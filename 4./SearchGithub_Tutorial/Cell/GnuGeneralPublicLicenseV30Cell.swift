//
//  GnuGeneralPublicLicenseV30Cell.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import Foundation

import UIKit
import KarrotFlex

final class GnuGeneralPublicLicenseV30Cell: UITableViewCell {
    
    private let labelView = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      self.accessoryType = .disclosureIndicator
        
      self.labelView.text = "GnuGeneralPublicLicenseV30Cell"
      self.labelView.numberOfLines = 0
        
      self.contentView.flex.define {
        FlexItem($0, view: self.labelView).margin(24.0)
      }
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
      self.contentView.bounds.size.width = size.width
      self.contentView.flex.layout(mode: .adjustHeight)
      return self.contentView.bounds.size
    }
}
