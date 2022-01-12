//
//  MainView.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import Foundation

import RxCocoa
import RxSwift
import KarrotFlex
import UIKit
import Then

class MainView: UIView {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32)
        $0.textAlignment = .center
        $0.text = "🐶"
    }
    
    let writeButton = UIButton().then {
        $0.setTitle("➕", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let profileView = UIView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 3.0
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 8
    }
    
    let profileLabel = UILabel().then {
        $0.text = "❤️ 혼자 놀기 너무 재밌어! ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 0
    }
    
    let contentLabel = UILabel().then {
        $0.text = "\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ\naaaaㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ"
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
    }
    
    let headerUnderLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        self.define()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        self.flex.layout(mode: .fitContainer)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.flex.padding(self.safeAreaInsets)
        self.setNeedsLayout()
    }
}

extension MainView {
    
    // MARK: Define
    private func define() {
        self.flex.define {
            FlexVStack($0, justifyContent: .center, alignItems: .stretch) {
                
                FlexHStack($0, justifyContent: .spaceBetween, alignItems: .stretch) {
                    FlexItem($0, view: self.titleLabel)
                    FlexItem($0, view: self.writeButton)
                }
                .padding(16)
                .backgroundColor(.systemGray5)
                
                FlexSpacer($0, spacing: 50)
                
                FlexItem($0, view: self.profileView)
                    .define {
                        FlexVStack($0) {
                            FlexItem($0, view: self.profileLabel)
                            FlexSpacer($0, spacing: 8)
                            FlexItem($0, view: self.contentLabel)
                        }
                        .padding(16)
                    }
                    .backgroundColor(.white)
            }
            .padding(16)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let mainView = MainView()
            return mainView
        }.previewLayout(.sizeThatFits)
    }
}
#endif
