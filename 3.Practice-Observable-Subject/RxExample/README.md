# Observable & Subject 실습

## 1. Observable

`Observable` 에서 방출한 데이터는 `subscribe` 한 곳에서 받아 처리할 수 있다.
그렇다면, 데이터가 흐르는 **stream** 은 어떤 LifeCycle 을 가지는지 살펴보자.

```swift
Observable.from(["Hello", "Rx!"])
    .subscribe(onNext: { str in
        print("Subscribe: ", str)
    }, onError: { error in
        print("onError: ", error.localizedDescription)
    }, onCompleted: {
        print("onCompleted")
    }, onDisposed: {
        print("onDisposed")
    })
    .disposed(by: disposeBag)
//        Subscribe:  Hello
//        Subscribe:  Rx!
//        onCompleted
//        onDisposed
```

`from` 은 인자로 받은 데이터를 사용해 `Observable`을 생성하는 **Operator** 이다.
데이터를 하나씩 내려보내 주므로, `"Hello"` `"Rx"` 가 따로 방출되는 것을 확인할 수 있다.
그 다음 `onCompleted`, `onDisposed` 가 프린트 된다.

RxSwift 에서 `subscribe` 메서드의 정의는 다음과 같다:

```swift
// ObservableType+Extensions.swift
    public func subscribe(
        onNext: ((Element) -> Void)? = nil,
        onError: ((Swift.Error) -> Void)? = nil,
        onCompleted: (() -> Void)? = nil,
        onDisposed: (() -> Void)? = nil
    ) -> Disposable {
```

데이터가 문제없이 처리될때는 다음과 같은 순서대로 처리된다:

1. onNext
2. onCompleted
3. onDisposed

에러가 발생했을때는 다음과 같다:

1. onError
2. onDisposed

`dispose()` 했을때:

1. onDisposed

<br/>
<br/>

## 2. Subject

> **Subject**는 **Observable** 이자 **Observer** 라고 알아 보았다.
> <br/> **Observer** 이기에 하나이상의 **Observable**을 구독할 수 있고, **Observable** 이기에 데이터를 발행할 수도 있다.

이번 시간에는 실습을 통해 **Subject**의 내부구현과 사용방법을 살펴보려고 한다.

Int 값을 가지는 `PublishSubject` 를 생성했다.

```swift
 let subject = PublishSubject<Int>()
```

`PublishSubject` 는 `subscribe()`한 이후부터 종료될때까지(.completed, .error) 데이터를 방출한다.

아래처럼 외부에서 값을 넣어 줄 수 있다:

```swift
subject.onNext(value)
subject.onCompleted()
subject.onError(Swift.Error)
```

- `onNext`: 외부에서 값을 넣어줌
- `onCompleted`: 스트림을 완료한다
- `onError`: 에러를 발생시킨다
  3개의 메서드 모두 **on** 키워드가 접두사로 붙는것을 확인할 수 있다.
  next, completed, error 3개를 한정된 값으로 가지는 것...익숙하지 않은가?

RxSwift 에 정의를 살펴보자:

```swift
// ObserverType.swift
public protocol ObserverType {
    associatedtype Element

    func on(_ event: Event<Element>)
}

extension ObserverType {
    public func onNext(_ element: Element) {
        self.on(.next(element))
    }

    public func onCompleted() {
        self.on(.completed)
    }

    public func onError(_ error: Swift.Error) {
        self.on(.error(error))
    }
}
```

그렇다! Event 를 인자로 가지는 Convenience method 였던 것이다 🤭
**ObserverType** 은 Protocol 로 정의되어 있다.
그럼, 이 프로토콜을 채택하는 곳인 `PublishSubject` 에서 `on` 을 구체적으로 정의하고 있겠지?

```swift
public final class PublishSubject<Element>
    : Observable<Element>
    , SubjectType
    , Cancelable
    , ObserverType
    , SynchronizedUnsubscribeType {

...

    public func on(_ event: Event<Element>) {
        #if DEBUG
            self.synchronizationTracker.register(synchronizationErrorMessage: .default)
            defer { self.synchronizationTracker.unregister() }
        #endif
        dispatch(self.synchronized_on(event), event)
    }
```

`on` 에서 실행하는 `dispatch` 메서드는 Bag 타입을 인자로 받는것을 보아 dispose 하는데 사용되는 듯 하다 아마도..?
여기까지 알아보기로 하자 😇

**Subject** 에 외부에서 값을 넣어보고 어떤 흐름으로 실행되는지 살펴보자:

```swift
let subject = PublishSubject<Int>()

let subscriber1 = subject.subscribe(onNext: { (num) in
    print("subscriber 1️⃣: ", num)
}, onError: { error in
    print("subscriber 1️⃣ Error: ", error.localizedDescription)
}, onCompleted: {
    print("subscriber 1️⃣ onCompleted")
}, onDisposed: {
    print("subscriber 1️⃣ onDisposed")
})

let subscriber2 = subject.subscribe(onNext:..위와 같음,생략..)
```

`PublishSubject` 를 생성하고 이를 구독하는 subscriber가 2개 있다.
외부에서 이벤트를 넣어주었을때, subscriber는 어떻게 반응할까?

`onNext` 로 값을 흘려보내 보자:

```swift
subject.onNext(1)
subject.onNext(2)
//subscriber 1️⃣:  1
//subscriber 2️⃣:  1
//subscriber 1️⃣:  2
//subscriber 2️⃣:  2
```

방출된 데이터를 순서대로 받는것을 확인 해 볼수 있었다.
Observable 의 데이터 방출 순서보장에 대해서는 [Hot & Cold Observable](https://reactivex.io/documentation/observable.html) 설명에서 확인해 볼 수 있었다.

- **Cold**
  - 구독한 시점(Subscribe) 부터 데이터를 방출하므로, 모든 데이터를 수신할 수 있다.(Observable, Operator 의 기본값)
  - Cold Observable은 스트림을 분기시키는 성질을 가지고 있지 않다. 따라서, Cold Observable을 여러번 Subscribe 하는 경우, 각각 별도의 스트림이 생성되고 할당되게 된다.
- **Hot**
  - 구독(Subscribe)과 상관없이 데이터를 방출하므로, 모든 데이터를 수신할 수 있다고 보장할 수 없다.(Subject)
  - Hot Observable은 스트림을 분기시키는 성질을 가지고 있기 때문에 스트림의 분기가 필요한 경우 Hot Observable을 사용해야 한다.

대부분의 Operator 는 Cold 속성을 지니므로, Subscribe 하기 전에는 동작하지 않는다. 이때 Hot 으로 변환시키는`.publish()` Operator 를 사용하면 Subscribe하기 전에 실행할 수 있다.

<br/>

### 예제

**Subject** 는 `Hot`이고, **Operator**의 기본 속성은 `Cold` 이다.
그래서 subject에 값을 넣어도(onNext) 구독(subscribe)하기 이전에 들어간 데이터는 무시되는 것을 아래 코드에서 확인할 수 있다:

```swift
let subject = PublishSubject<String>()

// subject에서 생성된 Observable은 [Hot]
let sourceObservable = subject.asObservable()

// Scan()은 [Cold]
let stringObservable = sourceObservable.scan("") { $0 + $1 }

// 스트림에 값을 흘린다
subject.onNext("A")
subject.onNext("B")

// 스트림에 값을 흘린 후 Subscribe 한다.
stringObservable.debug("stringObservable debug:").subscribe()

// Subscribe 후 스트림에 값을 흘린다.
subject.onNext("C")

// 완료
subject.onCompleted()

// 결과
// subscribed
// Event next(C)
// Event completed
// isDisposed
```

<br/>

`subscribe` 하기 이전에 흘려넣은 A,B 데이터도 처리하려면 어떻게 해야할까?
**Cold Operator** 를 `Hot` 으로 변환하면 된다.

```swift
let subject = PublishSubject<String>()

// subject에서 생성된 Observable은 [Hot]
let sourceObservable = subject.asObservable()

// 스트림에 흘러 들어온 문자열을 연결하여 새로운 문자열로 만드는 스트림
// Scan()은 [Cold]
let stringObservable = sourceObservable.scan("") { $0 + $1 }
    .publish() // Hot 변환 오퍼레이터

stringObservable.connect() // 스트림 가동 개시

// 스트림에 값을 흘린다
subject.onNext("A")
subject.onNext("B")

// 스트림에 값을 흘린 후 Subscribe 한다.
stringObservable.debug("stringObservable debug:").subscribe()

// Subscribe 후 스트림에 값을 흘린다.
subject.onNext("C")

// 완료
subject.onCompleted()
// 실행결과
// subscribed
// next(ABC)
// completed
// isDisposed

```

`publish` 라는 `Hot` 변환 연산자를 사이에 끼우는 것으로, Subscribe(구독)하는 이전에 스트림을 강제로 실행시킬 수 있다.

---

### 참고 자료

- [ReactiveX Document](https://reactivex.io/documentation/subject.html)
- [Rx의 Hot, Cold에 대해](https://tech.lonpeach.com/2019/09/29/UniRx-Hot-Cold/)
- [Cold, Hot 그리고 Subject](https://taehyungk.github.io/posts/android-RxJava2-Cold-Hot-Observable-and-Subject/)
- [Scan 예제-토미의 개발노트](https://jusung.github.io/scan/)
