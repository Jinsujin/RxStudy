//
//  MainPgeTopView.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/17.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class MainPageTopView: UIView {
    var settingButton = UIButton()
    var sortButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    var sortButtonSubject = PublishSubject<Void>()
    
    convenience init(viewModel: TODOViewModel) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        uiBuild()
        
        viewModel
            .sortObservable
            .subscribe(
                with: self,
                onNext: { owner, sort in
                    owner.sortButton.setTitle(sort.rawValue, for: .normal)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func uiBuild() {
        let lineView = UIView()
        addSubviews(settingButton, sortButton, lineView)
        
        sortButton.do {
            $0.setTitleColor(.black, for: .normal)
            
            $0.rx.tap.bind(with: self) { owner, _  in
                owner.sortButtonSubject.onNext(())
            }
            .disposed(by: self.disposeBag)
            
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(10)
            }
        }
        
        settingButton.do {
            $0.setTitle("설정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.right.equalTo(sortButton.snp.left).offset(-30)
            }
        }
        
        lineView.do {
            $0.backgroundColor = .darkGray.withAlphaComponent(0.6)
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.height.equalTo(1)
                $0.left.right.equalToSuperview().inset(5)
            }
        }
    }
}



// #if DEBUG
// import SwiftUI
//
// @available(iOS 13, *)
// struct MainPageTopViewPreview: PreviewProvider {
//
//     static var previews: some View {
//         ViewRepresentable(view: MainPageTopView())
//             .previewLayout(.fixed(width: 375, height: 40))
//     }
// }
// #endif
