# Observable & Subject

## 1. Observable

```
Observer 는 Observable 을 구독한다.
Observable 은 하나 또는 연속된 항목을 방출하고, Observer 는 이에 반응한다. (옵저버 패턴)
```

Observable 과 이를 구독하는 Observer 의 구현은 다음과 같은 순서로 이루어 진다:

1. Observable 안에서 데이터를 처리하는 매커니즘을 정의한다.
2. Observable 을 구독하는 Observer 를 구현한다.
3. Observable 이 이벤트를 발생시킨다.
4. Observer 가 그 순간을 감지해 수신한 데이터로 결과를 반환한다.

> Note:
>
> Observer 는 다른 문서에서 구독자, 관찰자, 리액터로 불려지기도 한다.

<aside>
💡 observable, observable sequence, sequence 는 모두 다 같은 말이다.
</aside>

<br/>
<br/>

### 구독하기(subscribe)

**Observable** 이 데이터를 방출(emit) 하면, 이를 **Observer** 가 구독(subscribe)한다. 그리고 방출된 데이터를 이용해 할 행동을 정의한다.

예를들어 방출된 데이터를 이용해 뷰를 업데이트 하는 작업을 할 수 있다.

> Observable 을 정의한 것만으로는 데이터가 방출되지 않는다. (정의만 된것.)
> 구독을 해야 비로소 실행되어 이벤트를 Observer 에게 보내게 된다.

Observable 을 구현하고 이를 구독하는 코드를 구현해 보자.

`from` 연산자를 이용해 array 의 각각의 요소를 방출하도록 정의한다:

```swift
let observable = Observable.from([10,20,30])
```

이 `Observerble` 에 `subscibe` 를 사용해 구독한 다음, 출력하면 다음과 같은 결과값을 확인할 수 있다:

```swift
observable.subscribe(onNext: { element in
	print(element)
})
// 10
// 20
// 30
```

`subscribe` 메서드의 정의를 찾아 보면, 4가지의 인자를 가지는 것을 확인해 볼 수 있다:

```swift
extension ObservableType {
	public func subscribe(onNext: ((Element) -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil)
      -> Disposable {
		....
			return Disposables.create(
        self.asObservable().subscribe(observer),
        disposable
    )
	}
```

subscribe(onNext, onError, onCompleted, onDisposed:):

- onNext
  - observable sequence 에서 각 element 가 방출되었을때 호출
- onError
  - observable sequence 에서 에러가 발생했을때 호출
- onCompleted
  - observable sequence 가 정상적으로 종료되었을때 호출
- onDisposed
  - 모든 유형의 sequence 종료시 호출
  - 예) completed, error, 구독을 삭제해 취소할때
- return Disposable
  - 구독을 취소하는데 사용하는 객체(Subscription object) 반환
  - Disposable class 는 구독의 정상적인 해지를 돕는다.

그리고 subscribe 메서드가 하나 더 정의되어 있는 것을 확인할 수 있었다:

```swift
public func subscribe(_ on: @escaping (Event<Element>) -> Void)
    -> Disposable {
        let observer = AnonymousObserver { e in
            on(e)
        }
        return self.asObservable().subscribe(observer)
}
```

`subscribe(on:)` 메서드는 `Event` 를 인자로 가지는 함수가 정의되어 있다.

<br/>

### Event

`(Event<Element>) -> Void` 가 on 의 타입으로 정의되어 있다.

`Event` 가 어떤 타입인지 찾아 보니, 다음과 같았다:

```swift
// Event.swift
public enum Event<Element> {
    /// Next element is produced.
    case next(Element)

    /// Sequence terminated with an error.
    case error(Swift.Error)

    /// Sequence completed successfully.
    case completed
}
```

`Event` 는 enum 으로 정의 되어 있었고, `.next`, `.error`, `.completed` 의 경우가 있었다.

만약, 이 메서드를 사용해 Observable 을 구독한다면 다음과 같이 구현할 수 있다:

```swift
Observable.just(["Hello", "World"])
    .subscribe { event in // event == Event<[String]>
        switch event {
        case .next(let str):
            print(str)
        case .completed:
            print("completed")
        case .error(let err):
            print(err)
        }
    }
```

Observable 이 element(데이터)를 방출한 후, 3가지의 이벤트를 전달한다:

- next:
  - element(데이터) 의 방출을 알린다. 이벤트가 어떤 element 인스턴스를 가지고 있는지 확인할 수 있다.
- completed:
  - 모든 element 의 방출이 완료되었음을 알린다. 아무런 인스턴스를 가지지 않고 단순히 이벤트를 종료 시킨다.
- error:
  - 오류가 발생했음을 알린다. Swift.Error 인스턴스를 가진다.

<br/>
<br/>

## 2. Subject

```swift
Subject = Observable + Observer
```

Subject 는 Observable 인 동시에 Observer 이다.

실시간으로 Observable에 새로운 값을 추가하고, subscriber(Observer) 들에게 방출한다.

<br/>

### Hot & Cold

Observable 은 2가지 종류로 나누어 진다:

- Hot (Subject)
  - 구독자의 여부에 관계없이 데이터를 방출한다.
  - 예) 터치 이벤트, 시스템 이벤트
- Cold
  - 구독하기전에는 데이터를 방출하지 않는다(Lazy)
  - 예) 웹 요청, 데이터베이스 쿼리, 파일 읽기

**Subject** 는 대표적인 **Hot Observable** 이다.

**Subject** 는 **Cold Observable**을 **Hot Observable**로 변환해주고, Observable 속성과 구독자의 속성을 모두 가지고 있다.

따라서 **Observable** 처럼 데이터를 발행할 수 있고, **Observer**(구독자)처럼 방출된 데이터를 처리할 수도 있다.

**Subject** 중의 하나인 **PublishSubject** 의 코드를 살펴보자:

```swift
// PublishSubject.swift
public final class PublishSubject<Element>
    : Observable<Element>
    , SubjectType
    , Cancelable
    , ObserverType
    , SynchronizedUnsubscribeType {

// Observable.swift
public class Observable<Element> : ObservableType {}
// ObserverType.swift
public protocol ObserverType {}
```

`Observable<Element>` 을 상속하고 `ObserverType` 프로토콜을 채택해 구현하고 있다.

여기서 **Subject**가 **Observable** 이자 **Observer** 라는 것을 확인 할 수 있다.

### Subject 종류

1. PublishSubject
   - 빈 상태로 시작한다. 오직 새로운 값(element) 만을 subscriber 에게 방출한다.
   - 구독된 순간, 새로운 이벤트를 subscriber 에게 알리고 싶을때 유용하다.
2. BehaviorSubject
   - 초기값을 가진채로 시작한다. 초기값이나 가장 최신값을 새로운 subscriber 에게 방출한다.
   - 가장 최신의 데이터로 뷰를 먼저 구성하고 싶을때 유용하다.
3. ReplaySubject
   - buffer size 로 시작한다. 그동안 방출한 이벤트 중 최근의 것들을 특정 사이즈(buffer size) 만큼 캐시 시켜 놓는다. 이것들을 새로운 구독자에게 재방출 한다.
   - 검색 화면에서 가장 최신의 값들을 여러개 보여주고 싶을때 유용하다.
4. AsyncSubject
   - Subject가 completed 되면 가장 마지막 값(element)를 새로운 subscriber 에게 넘겨준다.
