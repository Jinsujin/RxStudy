//
//  WriteViewController.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import UIKit
import RxSwift
import RxCocoa
//import KarrotFlex
import ReactorKit

class WriteViewController: UIViewController, View {

    // MARK: Properties
    
    typealias Reactor = WriteReactor
    
    fileprivate var writeView: WriteView {
        return self.view as! WriteView
    }
    
    var disposeBag = DisposeBag()
    
    init(with reactor: WriteReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = WriteView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WriteViewController {
    
    // MARK: Bind
    
    func bind(reactor: WriteReactor) {
        
    }
}
