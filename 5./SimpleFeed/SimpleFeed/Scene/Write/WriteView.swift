//
//  WriteView.swift
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

class WriteView: UIView {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "🐶 제목"
        $0.font = .systemFont(ofSize: 24)
        $0.textAlignment = .center
    }
    
    let titleTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.placeholder = "20자 제한"
        $0.borderStyle = .roundedRect
    }
    
    let contentLabel = UILabel().then {
        $0.text = "📝 메모"
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.textAlignment = .center
    }
    
    let contentTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let placeholderLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.text = "200자 제한"
        $0.textColor = .systemGray3
    }
    
    let warningLabel = UILabel().then {
        $0.text = "200자 제한"
        $0.textColor = .red
        $0.alpha = 0
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    let doneButton = UIButton().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 3.0
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 8
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
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
 
extension WriteView {
    
    // MARK: Define
    private func define() {
        self.flex.define {
            FlexVStack($0, justifyContent: .start, alignItems: .stretch) {
                FlexSpacer($0, spacing: 50)
                FlexHStack($0) {
                    FlexItem($0, view: self.titleLabel)
                    FlexSpacer($0, spacing: 16)
                    FlexItem($0, view: self.titleTextField).grow(3)
                }
                .padding(16)

                FlexHStack($0) {
                    FlexItem($0, view: self.contentLabel)
                    FlexSpacer($0, spacing: 16)
                    FlexItem($0, view: self.contentTextView)
                        .define {
                            FlexItem($0, view: self.placeholderLabel)
                                .marginTop(-20)
                                .marginLeft(6)
                        }
                        .height(300)
                        .grow(3)
                }
                .padding(16)

                FlexHStack($0) {
                    FlexItem($0, view: self.warningLabel)
                    FlexSpacer($0, spacing: 16)
                    FlexSpacer($0, spacing: 16)
                }
                .alignSelf(.end)
            }
        }
    }
    
    private func bind() {
        self.contentTextView.rx.text
            .map { $0?.count ?? 0 > 0 }
            .bind(to: self.placeholderLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct WriteViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let writeView = WriteView()
            return writeView
        }.previewLayout(.sizeThatFits)
    }
}
#endif
