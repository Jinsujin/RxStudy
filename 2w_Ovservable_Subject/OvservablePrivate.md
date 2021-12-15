### Rx의 3요소</br>
1. Observable(Observable, Observer, Disposable 등등)
2. Operator(map, flatMap 등등)
3. Scheduler(MainScheduler, ConcurrentDispatchQueueSchedule 등등)

### Observable Pattern</br>
1. Pull형 Observer 
   * Observable는 Observer에 공통된 Protocol을 가진 Interface을 Collection으로써 보유하고 상태 변이 시 각각에게 통지한다.
   * Observer은 Observable에서 어떠한 정보가 발생했다는 정보 만을 Notify() Method를 경유해 취득한다.
   * Observer은 필요에 따라 Observable의 값을 조회한다.

```
public protocol Observable {
    func subscribe(obs: Observer)
    func unsubscribe(obs: Observer)
}

public class ConcreteObservable {
    private var observers: [Observer] = []
    public var isHoge: Bool = false {
        didSet { observers.forEach { x in x.notify() } }
    }
    public func subscribe(obs: Observer) { observers += [obs] }
    pubilc func unsubscribe(obs: Observer) {
        observers = observers.filter { x in
            // this means reference equality
            ObjectIdentifier(x) != ObjectIdentifier(obs)
        }
    }
}

public protocol Observer: class {
    func notify()
}

public class ConcreteObserver: Observer {
    public func notify() { NSLog("통지를 받았다.") }
}

// Playground에서 확인 가능
let v1 = ConcreteObservable()
let obs1 = ConcreteObserver()
v1.subscribe(obs: obs1)
v1.isHoge = false //=> 로그가 출력된
v1.isHoge = true  //=> 로그가 출력된
v1.unsubscribe(obs: obs1)
v1.isHoge = false //=> 로그가 출력된
```

2. Push형 Observer</br>
- pull형의 Observer Pattern의 경우 Observer은 Observable의 상태가 변경되었다는 사실을 알 수는 있으나, 어떤 값에 변화가 있는지는 Overvable의 Property 등을 참조하지 않으면 알 수 없다. 변경된 값을 참조하기 위해 OVerser도 Observable의 참조를 어떠한 방법으로든 해야할 필요가 있으며, <mark>상호 참조를 하게 되는 구조가 된다.</mark>


### RxSwift의 Observer, Observable 구현
- 기본적으로 push형 Observer Pattern과 동일한 구조가 되지만 3가지 다른 점이 있다.
1. notify 시 값을 .next, .error, .completed로 묶어 enum Event에 Wrap하여 전달
2. .next 이 외의 값이 들어오면 이후 Event는 흐르지 않는다.
3. unsubscribe의 책무를 Disposable로 하고 있다.

#### Event 구현
 RxSwift의 observable는 변화한 값(next)에 뿐만아니라 error와 completed라는 것도 Observer에 통지가 가능하다. 이런 통지를 표현하는 것은 Event라는 enum이다. 
```
public enum Event<Element> {
    case next(Element)
    case error(Error)
    case completed
}
```
또한 통지에 관해 push형 observer Pattern에는 없는 rule가 있다. 그것이 next 이 외의 값이 들어오면 이후 Event는 흐르지 않는다. 라는 rule다 
```
extension Event {
    public var isStopEvent: Bool {
        switch self {
        case .next: return false
        case .error, .completed: return true
        }
    }
}
```

#### Disposable Protocol의 정의
push형의 observer pattern에는 존재하지 않는다. 이 Protocol은 단순히 push형의 observer pattern의 unscribe의 역할을 object로써 때어낸것이다.</br> 
unsubscribe를 발생시키는 단순한 Method dispose만을 가지는 simple한 interface가 된다.
```
public protocol Disposable {
    func dispose()
}
```
### ObserverType, ObservableType Protocol 정의
거의 push형 Observer Pattern과 차이가 없다. 차이가 있는 점은 값이 Event라는 문법으로 통지되는 점이 다르다.
문법이 있기 때문에 지금까지 notify라 명명한 부분이 on이라는 이름으로 변경되어 있다. 이것은 인수에 enum 값으로  .next(Element), .error(Error), .completed가 전달된다고 생각하면 자원스러운 명칭이다.
```swift
public protocol ObservableType {
    associatedtype E
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E
}

public protocol ObserverType {
    associatedtype E
    func on(_ event: Event<E>)
}
```
또 ObserverTypeㅇ는 편리한 확장 Method로써 onNext(Element), onError(Error), onCompleted가 있다.
```swift
extension ObserverType {    
    public final func onNext(_ element: E) {
        on(.next(element))
    }

    public final func onCompleted() {
        on(.completed)
    }

    public final func onError(_ error: Swift.Error) {
        on(.error(error))
    }
}
```

### Observable 구현
기본적으로 ObserverType의 관련형(associated type)을 형Parameter로 끌어올리는것 이 외의 것은 하고 있지 않다.
swift에는 추상 클래스나 추상 메소드라는 언어 기능이 존재하지 않기 때문에 Never형을 return하는 메소드를 호출하는 것이 특징이다.
```swift
public class Observable<Element>: ObservableType {
    public typealias E = Element

    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        abstractMethod()
    }
}

/// 추상 Method를 표현하기 위한 고육지책
func abstractMethod() -> Never {
    fatalError("abstract method")
}
```

