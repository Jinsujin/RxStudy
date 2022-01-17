//
//  LogTableViewCell.swift
//  RxSwift Study
//
//  Created by chalie on 2021/12/28.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unmLbl: UILabel!
    @IBOutlet weak var logLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
