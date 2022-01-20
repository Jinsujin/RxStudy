//
//  WriteReactor.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/20.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

final class WriteReactor: Reactor, Stepper {
    
    // MARK: init

    let initialState: State = State()
    var steps = PublishRelay<Step>()

    enum Action {
//        case presentAddVC
    }

    enum Mutation {
//        case error
    }

    struct State {
//        var error: String?
    }
}

extension WriteReactor {

    // MARK: Input, Output
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        }
        return _state
    }
}
