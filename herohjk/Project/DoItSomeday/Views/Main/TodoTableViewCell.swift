//
//  TodoCellNode.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import UIKit
import SnapKit
import Then

final class TodoTableViewCell: UITableViewCell {
    static let identifier = "TodoTableViewCell"
    
    var titleText = UILabel()
    var dDayText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiBuild()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func uiBuild() {
        addSubviews(titleText, dDayText)
        
        titleText.do {
            $0.font = .base(.regular, 15)
            $0.text = "sample"
            $0.textColor = .black
            
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().inset(10)
            }
        }
        
        dDayText.do {
            $0.font = .base(.regular, 15)
            $0.text = "D-3"
            $0.textColor = .black
            
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleText)
                $0.left.equalTo(titleText.snp.right).offset(10)
            }
        }
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TodoTableViewCellPreview: PreviewProvider {

    static var previews: some View {
        ViewRepresentable(view: TodoTableViewCell())
            .previewLayout(.fixed(width: 375, height: 50))
    }
}
#endif
