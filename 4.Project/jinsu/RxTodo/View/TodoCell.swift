//
//  TodoCell.swift
//  RxTodo
//
//  Created by jsj on 2022/01/05.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)

          // Configure the view for the selected state
      }
    
    func setData(_ data: Todo) {
        self.titleLabel.text = data.title
        
        if data.isDone {
            self.titleLabel.textColor = .gray
        } else {
            self.titleLabel.textColor = .black
        }
    }
}
