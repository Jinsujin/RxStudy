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

