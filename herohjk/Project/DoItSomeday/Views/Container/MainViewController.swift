//
//  MainContainer.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import SnapKit
import Then
import UIKit
import RxSwift

class MainViewController: UIViewController {
    var mainPageView = MainPageView()
    var viewModel = TODOViewModel()
    
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    
    var disposeBag = DisposeBag()
    
    var pickerItems: [SortCategory] = [
        .dDayUp,
        .dDayDown,
        .writeDateUp,
        .writeDateDown,
        .nameUp,
        .nameDown
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageView = MainPageView(viewModel: viewModel)
        
        self.view.addSubview(mainPageView)
        
        mainPageView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainPageView.topView?.sortButtonSubject.subscribe(with: self, onNext: { owner, _ in
            owner.createPickerView()
        })
            .disposed(by: disposeBag)
    }
    
    func createPickerView() {
        picker = UIPickerView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor.white
            $0.setValue(UIColor.black, forKey: "textColor")
            $0.autoresizingMask = .flexibleWidth
            $0.contentMode = .center
            $0.frame = CGRect.init(
                x: 0.0,
                y: UIScreen.main.bounds.size.height - 300,
                width: UIScreen.main.bounds.size.width,
                height: 300
            )
            view.addSubview($0)
        }
        
        toolBar = UIToolbar().then {
            $0.frame = CGRect(
                x: 0.0,
                y: UIScreen.main.bounds.size.height - 300,
                width: UIScreen.main.bounds.size.width,
                height: 50.0
            )
            $0.items = [
                UIBarButtonItem.init(
                    title: "Done",
                    style: .done,
                    target: self,
                    action: #selector(onDoneButtonTapped)
                )
            ]
            view.addSubview($0)
        }
    }
    
    @objc
    func onDoneButtonTapped() {
        viewModel.sort(pickerItems[picker.selectedRow(inComponent: 0)])
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerItems.count
    }
    
    // swiftlint:disable line_length
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // swiftlint:enable line_length
        pickerItems[row].rawValue
    }
}
