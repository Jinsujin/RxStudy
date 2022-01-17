//
//  ObsVM.swift
//  RxSwift Study
//
//  Created by chalie on 2021/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class ObsVM {
    
    let validationText: Observable<String>
    
    let disposeBag = DisposeBag()
    var logArrays:[Int] = []
    var resultArrays:[Int] = []
    
    init(startNoObs: Observable<String?>, endNoObs: Observable<String?>, model: ObsModel) {
   
        let event = Observable.combineLatest(startNoObs, endNoObs).skip(1).flatMap { startTx, endTxt -> Observable<Event<Void>> in
            return model.validate(startNo: startTx, endNo: endTxt).materialize()
        }.share()
        
        validationText = event.flatMap { event -> Observable<String> in
            switch event {
            case .next: return .just("Start/End OK")
            case let .error(error as ModelError): return .just(error.errorText)
            case .error, .completed: return .empty()
            }
        }.startWith("초기값을 입력해 주세요")
    }
    
    func generateArray(start: Int, end: Int) {
        print("generate On Next Array")

        for i in start ... end {
            let arrayEle = i + start - 1
            logArrays.append(arrayEle)
        }
        generateOnNext()
    }
        
    func generateOnNext() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        let source = Observable<Int>.interval(.milliseconds(1000), scheduler: scheduler)
        var arrayCount = logArrays.count
        source.subscribe { event in
            if arrayCount > 0{
                arrayCount -= 1
                print(event)
            }
        }.disposed(by: disposeBag)
    }

        
// Test Code
//        let i = PublishSubject<Int>()
//            let s = PublishSubject<String>()
//
//            _ = Observable.combineLatest(i, s) {
//                "\($0) + \($1)"
//              }
//              .subscribe {
//                print("onNext: ", $0)
//              }
//
//            i.onNext(1)
//            s.onNext("A")
//            i.onNext(2)
//            s.onNext("B")
//            s.onNext("C")
//            i.onNext(3)
        
    
}//End Of The Class

