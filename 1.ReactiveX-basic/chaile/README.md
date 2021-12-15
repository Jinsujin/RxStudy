### 함수형 프로그래밍

1.  상태 값을 갖지 않고 순수하게 함수만으로 동작
    - 동일한 Input에 동일한 Output 보장
2.  상호 간섭 없이 실행, 병렬 처리를 할 때 부작용이 거의 없다는 장점
3.  함수를 일급 객체로 다룬다.
4.  중요 Point

- 선언형
  - 하기의 SQL 문과 같이 결과가 어떻게 출력되는가를 선언하고, 내부 처리에 대해서는 PC에 일임함

```
  SELECT name FROM USERS
```

- 명령형
  - 어떻게 실행해야되는지 상세하게 지시하는 것으로 대부분의 Object 지향 언어에 사용되고 있음
- 명령/선언형 예시 (편의점 심부름)

  - 명령형: 몇m 진행 -> 몇개의 골목길을 지나 -> 신호를 건너고 -> 몇m 진행 -> 편의점에 들어간다. ...
  - 선언형: 편의점에서 무엇을 사와라

- 순수 함수
  - 입력 값이 동일할 때 출력되는 값이 동일한 함수 (순수 함수의 투명성)
  - 함수형 프로그램은 이 순순함수를 이용해 불변성을 보증하고 있다.
  - 순수 함수는 함수의 Scope 이 외의 있는 변수를 일절 사용하지 않는다.
- 1급 객체
  - 함수의 파라미터로 전달되거나, 리턴값으로 사용될 수 있는 객체를 의미

### 옵저버 패턴

1. 객체의 상태 변화, Event 발생 등의 움직임을 알고 싶은 쪽에서 확인하는 것이 아닌 객체 스스로 발신 및 통지
   - 저쪽에서 움직임이 있다면 바로 알려줘 이쪽도 바로 움직이겠다. 라는 Pattern
2. 관찰 중인 객체에서 발생하는 Event를 여러 다른 객체에 알리는 메커니즘

- Subject (Publisher)
  - Observer들을 가지고 있으며 개수는 제한이 없습니다.
  - Observer들을 추가, 제거하는 인터페이스를 제공합니다.
- Observer (Subscriber)
  - 객체의 변경 사항을 알려야하는 객체에 대한 Update 인터페이스를 제공합니다.

### 모바일 아키텍처 패턴

1. MVP

- Presenter은 View를 Delegate하여 Event를 취득
- Presenter은 View에서 분리되어 있음. View를 Interface를 통해 Control
- Presenter의 특징
  - View -> Presenter과 Presenter -> View를 많이 보유
  - Ex) Save Button을 Click -> View의 Event Controller는 Presenter에 Delegate되어 있기 때문에 Presenter에서 OnSave가 호출됨 -> Save 완료되면, Presenter에서 Interface를 통해 View에 Save되었다고 표시
  - 실제 써본적이 없어서 예제 Code로 확인 필요

2. 2가지 MVP

   - Passive View</br>
     View 내의 Logic는 가능한한 줄이고, Presenter을 View와 Model을 중개하돌고하고, Model이 Data에 변경이 있다는 등의 Event를 발생하고, Presenter가 그것을 받고, Presenter가 View를 Update한다.</br>
     완전히 Model과 View가 분리된다.</br>

     장점: View와 Model이 깨끗한게 분리되어 Test가 쉽다.</br>
     단점: 많은 Setter을 쓰지 않으면 안된다.

   - Supervising Controller</br>
     Data Binding을 이용하여 Model에서 View에 Bind하는 방법 이 경우 Presenter에서 행한 Model에서 Vivew에 DAta를 건내기 위한 Code가 필요없게 된다. Presenter에는 Button을 누를 때의 Logic, 어디로 이동할까 하는 등의 Logic등이 쓰여지게 된다.</br>

     장점: Data Binding에 의해 Code가 줄어든다.</br>
     단점: Data binding 때문에 Passive View 대비 Test 난이도가 증가.</br>
     &nbsp;&nbsp;Model과 View가 직접 연결되기 때문에 Capsule화가 잘 이루어지지 않음

3. MVC
   - MVC에서 Controller은 모든 Action에 대해 대응하는 View를 결정 할 임무가 있음
   - MVC와 MVP의 차이점 2가지
     1. View에서 Presenter(Controller)에의 호출의 흐름이 다름</br>
        - MVC에서는 View 내부의 Action이 Controller을 호출하는 관계이다.</br>
          Ex) Web에서 View 내부 Action은 URL을 호출하고, 거기에 대응하는 Controller이 처리함
          그리고 Controller의 처리가 끝나면, 올바른 View을 반환</br>
          View 냅부의 Action -> Controller 호출 -> Contrller Logic -> View 반환
     2. View가 Model에 직접 연결되지 않음
        - MVC에서 Vivew는 Simple하게 표시한다. 그리고 완전히 상태를 가지고 있지 않다.</br>
          View에 대해서만 Logic이 없음. 즉 MVP라면 절대적으로 필요한 View에서 Presenter로의 Delegate가 없다.
4. MVVM
   - App 구현을 Model, ViewModel, View layer로 나눈 아키텍쳐
   - View → ViewModel → Model을 참조한다. View → Model로 참조 불가
   - View와 ViewModel을 Bind (Data가 변경 시 UI 표시를 갱신하기 위한 경우 필요)
   - 각 Layer의 역할 배치로 ViewController에 과중된 역할 탈피(Fat ViewController 대응)

---

### RxSwift 개념

1. ReactiveX(Reactive Extensions) Swift판
2. Rx는 FRP(Functional Reactive Programming)의 한 종류
   **FRP에 대해 추후 Update 예정**
3. 비동기 처리, Event 처리를 Support하는 Library(Callback 지옥에서 해방)

### Observable

1. onNext: 통상의 Event을 통지, 여러번 보내진다.
2. onError: Error 발생을 통지, 발생 후 Event가 일절 발생하지 않는다.
3. onCompleted: 완료를 통지, 발생 후 Event가 일절 발생하지 않는다.

```RxSwift
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
```

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

#### ~~Variable~~ 삭제됨

1. ~~Variable는 BehaviorSubject에서 Observable를 제거한 것 같은 것으로, onError, onCompleted를 발생 시키지 않는다.~~
2. ~~때문에 value 취득 시 BehaviorSubject 처럼 분기를 추가할 필요가 없다. Observable로써 사용할 경우 asObservable를 사용한다.~~
3. ~~또한 값을 저장할 수 있고, 갱신을 검지하고 싶을 경우 Observable를 갱신하고 구독하는 것으로 가능하다.~~
