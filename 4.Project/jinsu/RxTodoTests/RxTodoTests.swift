//
//  RxTodoTests.swift
//  RxTodoTests
//
//  Created by jsj on 2022/01/03.
//

import XCTest
@testable import RxTodo


class RxTodoTests: XCTestCase {

    var todoViewModel:TodoViewModel!
    
    var mockRepository: MockRepository!
    
    
    override func setUpWithError() throws {
        super.setUp()
        
        mockRepository = MockRepository()
        todoViewModel = TodoViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        todoViewModel = nil
        mockRepository = nil
        
        super.tearDown()
    }

    func testViewModel_add_todo() throws {
        let newTodoTitle = "NewTodo"
        todoViewModel.add(newTodoTitle)
        
        // dataList 에 새로 추가된 Todo 가 있나 확인한다
//        todoViewModel.dataList
        
        XCTAssertFalse(todoViewModel.dataList.isEmpty) // false
        XCTAssertEqual(todoViewModel.dataList.count, 1)
        XCTAssertEqual(todoViewModel.dataList.first?.title, newTodoTitle)
    }
    
    func testViewModel_after_delete_todo() throws {
        // given
        let newTodoTitle = "NewTodo"
        todoViewModel.add(newTodoTitle)
        
        // when
        XCTAssertEqual(todoViewModel.dataList.count, 1)
        todoViewModel.delete(at: 0, completion: {})
        
        // then
        XCTAssertTrue(todoViewModel.dataList.isEmpty, "Din't load todos data") // 비어 있어야 한다
    }
    
    
    func testViewModel_fetchAll() throws {
        // given
        let todos: [Todo] = [
            .init("빨래"),
            .init("공부"),
            .init("청소")
        ]
        todoViewModel.dataList = todos
        
        // then
        XCTAssertFalse(todoViewModel.dataList.isEmpty)
        XCTAssertEqual(todoViewModel.dataList.count, 3)
    }
    
    func testViewModel_after_checkTodo() throws {
        // given
        let newTodoTitle = "NewTodo"
        todoViewModel.add(newTodoTitle)
        
        // when
        XCTAssertFalse(todoViewModel.dataList.isEmpty)
        todoViewModel.checkDone(at: 0, completion: {})
        
        // then
        XCTAssertEqual(todoViewModel.dataList.first?.isDone, true)
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}



// MARK: Mocked MockRepository
class MockRepository: Repository {
    var dataList: [Todo] = []

    func add(_ title: String, completion: ((Todo?) -> Void)?) {
        let data = Todo(title)
        self.dataList.append(data)
        completion?(data)
    }
    
    func delete(at uid: UUID, completion: ((Bool) -> Void)?) {
        guard let findIdx = dataList.firstIndex(where: { $0.uid == uid }) else {
            completion?(false)
            return
        }
        dataList.remove(at: findIdx)
        completion?(true)
    }
    
    func checkDone(at uid: UUID, completion: ((Todo?) -> Void)?) {
        guard var findData = dataList.first(where: { $0.uid == uid }),
              let idx = dataList.firstIndex(where: { $0.uid == uid }) else {
            completion?(nil)
            return
        }
        
        findData.toggleDone()
        self.dataList[idx] = findData
        completion?(findData)
    }
    
    func fetchAll() -> [Todo] {
        return self.dataList
    }
}


// MARK: Mocked API service.
//class MockAPIService: APIServiceProtocol {
//
//    /// Determine whether the api fetch was invoked or not.
//    var didfetchPopularMovies: Bool = false
//
//    /// Mocks the APIServiceProtocol conformance to fetch popular movies
//    func fetchPopularMoviesData(pageNumber: Int,
//                                completion: @escaping (Result<ServiceResponseVO, Error>) -> Void) {
//        didfetchPopularMovies = true
//
//        do {
//            /// Loads data from a json file stored in the target.
//            guard let json = JSONHelper.loadJSONFile("popular-movies", bundle: Bundle(for: HomeViewModelTests.self)) else {
//                completion(.failure(JSONError.jsonFileNotFound(filePath: "popular-movies")))
//                return
//            }
//
//            let response = try JSONDecoder().decode(ServiceResponseVO.self, from: json)
//            completion(.success(response))
//        } catch {
//            completion(.failure(JSONError.jsonFileNotFound(filePath: "popular-movies")))
//        }
//    }
//}
