//
//  MainFlow.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

class MainFlow: Flow, Stepper {

    var root: Presentable {
        return self.rootViewController
    }
    let steps = PublishRelay<Step>()

    private lazy var rootViewController = UINavigationController()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .showMain:
            return self.showMain()
        case .showWrite:
            return self.showWrite()
        }
    }
    
    private func showMain() -> FlowContributors {
        let reactor = MainReactor()
        let viewController = MainViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: reactor
        ))
    }
    
    private func showWrite() -> FlowContributors {
        let reactor = WriteReactor()
        let viewController = WriteViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: reactor
        ))
    }
}
