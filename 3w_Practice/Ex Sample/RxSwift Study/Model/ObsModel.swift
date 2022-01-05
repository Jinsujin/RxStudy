//
//  ObsEvent.swift
//  RxSwift Study
//
//  Created by chalie on 2021/12/23.
//

import Foundation
import RxSwift

protocol ObsModelProtocol {
    func validate(startNo: String?, endNo: String?) -> Observable<Void>
}

class ObsModel: ObsModelProtocol {
    
    func validate(startNo: String?, endNo: String?) -> Observable<Void> {
        switch (startNo, endNo) {
        case (.none, .none): return Observable.error(ModelError.invalidStartEnd)
        case (.some, .none): return Observable.error(ModelError.invalidEndNo)
        case (.none, .some): return Observable.error(ModelError.invalidStartNo)
        case (let startNo?, let endNo?):
            switch (startNo.isEmpty, endNo.isEmpty) {
            case (true, true): return Observable.error(ModelError.invalidStartEnd)
            case (false, true): return Observable.error(ModelError.invalidStartNo)
            case (true, false): return Observable.error(ModelError.invalidEndNo)
            case (false, false): return Observable.just(())
            }
        }
    }
}//End Of The Class


