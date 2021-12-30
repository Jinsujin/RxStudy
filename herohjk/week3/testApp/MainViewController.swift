//
//  MainViewController.swift
//  testApp
//
//  Created by 김호종 on 2021/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    var timerTextLabel = UILabel()
    var startButton = UIButton()
    var clearButton = UIButton()
    
    var timerStatus = TimerStatus.ready
    
    var startTime: CFAbsoluteTime?
    
    var pauseTime: CFAbsoluteTime?
    
    var disposeBag = DisposeBag()
    
    var timerSubject = BehaviorSubject<Double>(value: 0.0)
    
    var timerDisposeBag = DisposeBag()
    
    var paused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        
        timerSubject
            .filter { _ in !self.paused }
            .map { doubleToTimeString($0) }
            .bind(to: timerTextLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func drawUI() {
        let backgroundColor = UIColor.rgb(0xD2D5B8)
        let buttonColor = UIColor.rgb(0xC9BA9B)
        let buttonColor2 = UIColor.rgb(0xBDC2BB)
        self.view.backgroundColor = backgroundColor
        self.view.addSubviews(
            timerTextLabel,
            startButton,
            clearButton
        )
        
        timerTextLabel.do {
            $0.font = .base(.bold, 30)
            $0.text = "0"
            $0.textAlignment = .center
            
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(100)
                $0.left.right.equalToSuperview().inset(20)
            }
        }
        
        startButton.do {
            $0.titleLabel?.font = .base(.bold, 20)
            $0.setTitle("START", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = buttonColor
            $0.rx.tap.bind(with: self) { owner, _  in
                owner.startButtonTap()
            }
            .disposed(by: self.disposeBag)
            
            $0.snp.makeConstraints {
                $0.top.equalTo(timerTextLabel.snp.bottom).offset(20)
                $0.left.equalToSuperview().inset(20)
                $0.width.equalToSuperview().multipliedBy(0.4)
                $0.height.equalTo(40)
            }
        }
        
        clearButton.do {
            $0.titleLabel?.font = .base(.bold, 20)
            $0.setTitle("CLEAR", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = buttonColor2
            
            $0.rx.tap.bind(with: self) { owner, _ in
                owner.timerStatus = .ready
                owner.startButton.setTitle("START", for: .normal)
                owner.timerDisposeBag = DisposeBag()
            }
            .disposed(by: self.disposeBag)
            
            $0.snp.makeConstraints {
                $0.top.equalTo(startButton.snp.bottom).offset(20)
                $0.left.right.equalToSuperview().inset(20)
                $0.height.equalTo(40)
            }
        }
    }
    
    func startButtonTap() {
        switch timerStatus {
        case .ready:
            timerStatus = .start
            startTime = CFAbsoluteTimeGetCurrent()
            startButton.setTitle("PAUSE", for: .normal)
            
            Observable<Int>.timer(
                .milliseconds(10),
                period: .milliseconds(10),
                scheduler: MainScheduler.instance
            )
                .filter { _ in self.timerStatus != .ready }
                .subscribe(
                    with: self,
                    onNext: { owner, _ in
                        if owner.timerStatus == .start, let startTime = owner.startTime {
                            owner
                                .timerSubject
                                .onNext(CFAbsoluteTimeGetCurrent() - startTime)
                        }
                    },
                    onDisposed: { owner in owner.timerSubject.onNext(0.0) }
                )
                .disposed(by: timerDisposeBag)
        case .start:
            timerStatus = .pause
            pauseTime = CFAbsoluteTimeGetCurrent()
            startButton.setTitle("START", for: .normal)
        case .pause:
            guard let pauseTime = pauseTime else { return }
            timerStatus = .start
            startTime? += (CFAbsoluteTimeGetCurrent() - pauseTime)
            startButton.setTitle("PAUSE", for: .normal)
        }
    }
}
