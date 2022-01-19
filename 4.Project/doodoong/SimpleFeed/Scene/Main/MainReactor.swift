//
//  MainReactor.swift
//  SimpleFeed
//
//  Created by 송형욱 on 2022/01/11.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

final class MainReactor: Reactor, Stepper {
    
    // MARK: init

    let initialState: State = State()
    var steps = PublishRelay<Step>()

    enum Action {
        case presentAddVC
    }

    enum Mutation {
        case error
    }

    struct State {
        var error: String?
    }
}

extension MainReactor {

    // MARK: Input, Output
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .presentAddVC:
            self.steps.accept(AppStep.showMain)
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .error:
            _state.error = "네트워크 오류?!?!"
        }
        return _state
    }
}
