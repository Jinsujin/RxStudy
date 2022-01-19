//
//  ExampleCells.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import Foundation

import UIKit

enum ExampleCells: String, CaseIterable {
    
    case apacheLicense20 = "Apache License 2.0"
    case gnuGeneralPublicLicenseV30 = "GNU General Public License v3.0"
    case microsoftPublicLicense = "Microsoft Public License"
    case mitLicense = "MIT License"
    case mozillaPublicLicense20 = "Mozilla Public License 2.0"
    case other = "Other"
    
    var cellClass: AnyClass {
        switch self {
        case .apacheLicense20:
            return ApacheLicense20Cell.self
        case .gnuGeneralPublicLicenseV30:
            return GnuGeneralPublicLicenseV30Cell.self
        case .microsoftPublicLicense:
            return MicrosoftPublicLicenseCell.self
        case .mitLicense:
            return MitLicenseCell.self
        case .mozillaPublicLicense20:
            return MozillaPublicLicense20Cell.self
        case .other:
            return OtherCell.self
        }
    }
    
    var identifier: String {
        return "\(self.rawValue)"
    }
    
    func dequeue<T: UITableViewCell>(tableView: UITableView, for indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! T
    }
}
