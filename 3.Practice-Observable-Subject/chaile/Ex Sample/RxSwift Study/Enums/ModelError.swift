//
//  ModelError.swift
//  RxSwift Study
//
//  Created by chalie on 2021/12/24.
//

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ModelError: Error {
    case invalidStartNo
    case invalidEndNo
    case invalidStartEnd
    var errorText: String {
        switch self {
        case .invalidStartNo: return "마지막 값을 입력해 주세요."
        case .invalidEndNo: return "시작 값을 입력해 주세요."
        case .invalidStartEnd: return "시작/마지막 값을 입력해 주세요."
        }
    }
}
