# RxStudy

RxSwift 를 공부하고 공유하는 공간입니다.

- Rx, MVVM 을 마스터 하는 것을 목표로 해요.
  - 이론으로 시작해 코드로 작성해요.
  - 토이 프로젝트를 만들어 봐요.
- 1주에 한번 공유해요.
  - 주제를 정해 발표해요.
- 기록을 남겨요.
  - github: 코드와 공부한 내용을 Readme 로 작성해 PR로 올리고, 생각을 나누어요.
  - notion: 같이 공유하면 좋을 참고자료와 회의록을 남겨요.
    <br/>

### 참여

| 🧑🏻‍💻                                | 👨🏻‍💻                                 | 🧑🏻‍💻                                 | 👩🏼‍💻                                  |
| ------------------------------------ | ---------------------------------- | ------------------------------------- | ----------------------------------- |
| [주노](https://github.com/junho7108) | [호드](https://github.com/herohjk) | [Chalie](https://github.com/chalie00) | [진수](https://github.com/Jinsujin) |

<br/>

### 📄 주제

| Week |           |
| :--: | --------- |
|  1   | OT        |
|  2   | 이론 공부 |
|  3   | -         |

---------------------------------------------------------------------------------------------------------------------------
## 1 week
### 함수형 프로그래밍
 1. 순수 함수를 선언적으로 평가하는 것
 2. 순순 함수: 외부에서 관측 가능한 부작용을 회피하는 것으로 불변성을 지닌 프로그래밍을 생성한다.
 3. 중요 Point
  - 선언형
  - 순수 함수
  - 불변성
  * 선언형
  
### 옵저버 패턴
### 모바일 아키텍처 패턴
### RxSwift 기본 개념
### (optional)Observable




---------------------------------------------------------------------------------------------------------------------------

### RxSwift 개념
1. ReactiveX(Reactive Extensions) Swift판
2. Rx는 FRP(Functional Reactive Programming)의 한 종류
__FRP에 대해 추후 Update 예정__
3. 비동기 처리, Event 처리를 Support하는 Library(Callback 지옥에서 해방)

### MVVM
1. App 구현을 Model, ViewModel, View layer로 나눈 아키텍쳐
2. View → ViewModel → Model을 참조한다. View → Model로 참조 불가
3. View와 ViewModel을 Bind (Data가 변경 시 UI 표시를 갱신하기 위한 경우 필요)
4. 각 Layer의 역할 배치로 ViewController에 과중된 역할 탈피(Fat ViewController 대응)

### Observable
1. onNext: 통상의 Event을 통지, 여러번 보내진다.
2. onError: Error 발생을 통지, 발생 후 Event가 일절 발생하지 않는다.
3. onCompleted: 완료를 통지, 발생 후 Event가 일절 발생하지 않는다.

'''RxSwift
private let disposeBag = DisposeBag()
let contentOffset = tableView.rx.contentOffset
        
contentOffset
    .subscribe(onNext: {
        print("next")
    }, onError: { _ in
        print("error")
    }, onCompleted: { 
        print("completed")
    })
    .addDisposableTo(disposeBag)
'''


 ### Subscribe
1. subscribe를 쓰는 걸로 Obserbvable를 구독 가능
2. Event가 발생 할 때마다 subscribe에 onNext가 전달하는 closer가 호출됨
3. .onError, .onCompleted 동일하게 closer가 호출됨

### Disposable
1. Disposable는 구독을 해제한며, dispose Method 호출로 구독 해제된다.
2. ~~DisposeBag를 관리하려면 addDisposableTo Method를 호출~~ 삭제됨

### Subject
- observable/observer 모두 가능 (즉 event 검지 및 발생 모두 가능)
1. observable: 사전 의미 그대로 피관찰자
- 한 스레드에서 다른 스레드로 넘길 수 있는 데이터들을 모아놓은 데이터 스트림의 생산자
2. observer: Observable이 만들어낸 데이터의 소비자
- Observer들은 observable을 subscribeOn() 메소드를 통해 구독해 observable이 방출하는 데이터를 받는다.
#### ReplaySubject
 - 지정한 수만 최신의 Event를 Cash하는 것이 가능 subscribe된 시점에 Cash된 Event가 전송된다.

#### BehaviorSubject
- ReplaySubject의 bufferSize가 1일 때와 동일한 동작을 나타낸다.
- 지금까지 다루었던 Event를 발생검지가 가능하고 Event에 값이 포함되었지만, 상시로 값을 가지는 것은 아니었다.
BehaviorSubject는 현재 값을 취득 가능한 value Method를 가지고 있다. 
Observable이기도 하기 때문에 onError, onCompleted가 이미 발생했을 가능성이 있기 때문에 value Method를 사용할 때 분기를 추가할 필요가 있다.

~~#### Variable ~~ 삭제됨
~~Variable는 BehaviorSubject에서 Observable를 제거한 것 같은 것으로, onError, onCompleted를 발생 시키지 않는다. ~~
~~때문에 value 취득 시 BehaviorSubject 처럼 분기를 추가할 필요가 없다. Observable로써 사용할 경우 asObservable를 사용한다. ~~
~~또한 값을 저장할 수 있고, 갱신을 검지하고 싶을 경우 Observable를 갱신하고 구독하는 것으로 가능하다. ~~
