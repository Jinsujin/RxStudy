//
//  ExampleReactor.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import ReactorKit
import RxSwift

final class ExampleReactor: Reactor {
    // init
    
    let initialState: State = State()
    
    enum Action {
        case search(query: String, page: Int)
    }
    
    enum Mutation {
        case searched(_ repo: GithubResponse.Github)
        case error
    }

    struct State {
        var repos: [GithubSection] = []
        var error: String?
    }
}

extension ExampleReactor {
    
    // MARK: Input, Output
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let query, let page):
            return APIService.shared.searchRepo(page: page, query: query)
                .map { Mutation.searched($0) }
                .catchAndReturn(Mutation.error)
                .asObservable()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .searched(let repos):
            let items = repos.items.map { GitHubItem($0) }
            _state.repos = [GithubSection(header: "first", gitHubItems: items)]
        case .error:
            _state.error = "네트워크 오류?!?!"
        }
        return _state
    }
}
