//
//  AppStepper.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    init() {}
    
    var initialStep: Step {
        return AppStep.showMain
    }
}
