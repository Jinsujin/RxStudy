//
//  MainViewController.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import UIKit
import RxSwift
import RxCocoa
import KarrotFlex
import ReactorKit

class MainViewController: UIViewController, View {

    // MARK: Properties
    
    typealias Reactor = MainReactor
    
    fileprivate var mainView: MainView {
        return self.view as! MainView
    }
    
    var disposeBag = DisposeBag()
    
    init(with reactor: MainReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController {
    
    // MARK: Bind
    
    func bind(reactor: MainReactor) {
        self.mainView.writeButton
            .rx.tap
            .map { Reactor.Action.presentAddVC }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
