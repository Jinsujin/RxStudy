## Practice
1. ### **목표**
- MVVM Pattern을 사용하여, Observable, Subject를 이용한 연습
2. ### **To Do List**</br>
- #### **2-1 요구 사항**</br>
    가. Textfield에 임의의 Text 기입 시 즉시 Label에 표기</br>
    나. Observable의 onNext의 On/Off 기능</br>
    다. Observable onNext 시 Data Type 선택 기능</br>
    라. Data Type는 Int, String, Array로 한정한다.</br>
    - Int: 1 ~ 100까지 Data를 1초에 한번씩 onNext에 흘린다.
    - String: A ~ Z까지 2초에 한번씩 onNext에 흘린다.
    - Array</br>
        i. [Int], [String]에 한정한다.</br>
        ii. [Int]: 1 ~ 100까지 10단위로 1개의 Array를 구성한다.</br>
        iii. [String]: A ~ Z까지 5단위로 1개의 Array를 구성한다.</br>

    마. Log 화면
    - No, Data Type, Data
    - onNext Start/End 시 Log 출력</br>
        
    바. Log Output 기능 (Tableview)</br>
    사. Result 화면 (Log 화면과 1:1 대응)</br>
    아. Observable의 onNext가 On 시 아래 구독 형태에 따른 결과 값을 Result에 출력</br>

3. Main StoryBoard</br>
<img src = "https://github.com/chalie00/RxStudy/blob/4WPractice/Image/MainStoryBoard.png">

4. 현까지 진행 사항</br>
   가. Start/End에 기입이 올바른지 확인</br>
   나. Observable On UI 선택 시 Start ~ End의 Event 발생
5. MVVM(가능한한 MVVM 구조를 지키도록 노력함)
   가. Enum
```
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
```
   나. Model
```
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
```
   다. ViewModel
```
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
            arrays.append(arrayEle)
        }
        generateOnNext()
    }
        
    func generateOnNext() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        let source = Observable<Int>.interval(.milliseconds(1000), scheduler: scheduler)
        var arrayCount = arrays.count
        source.subscribe { event in
            if arrayCount > 0{
                arrayCount -= 1
                print(event)
            }
        }.disposed(by: disposeBag)
    }

```
   라. View
```
    @IBAction func pressedOn(_ sender: UIButton) {
        print("Was On Pressed")
        let startStr = startNo.text
        let endStr = endNo.text
        let strInt = Int(startStr!)
        let endInt = Int(endStr!)
        if startStr != "" && endStr != "" {
            viewModel.generateArray(start: strInt!, end: endInt!)
        }
    }
```
마. Print (Start: 1, End: 10 입력)
```
Was On Pressed
generate On Next Array
next(0)
next(1)
next(2)
next(3)
next(4)
next(5)
next(6)
next(7)
next(8)
next(9)
```
라. 차후 과제</br>
     1. Data 변화에 따른 Tableview 구현
     2. 각 Subject에 대한 결과값을 Tableview에 구현

     