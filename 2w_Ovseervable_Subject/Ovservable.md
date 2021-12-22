### 1. Ovservable
1. Event를 검지하기 위한 Class
2. Event를 흘림 (Stream)
3. Observer가 통지하는 Event
    * onNext
       * 통상적인 Event를 발생
       * Event내에 값을 가짐
       * 몇 번이고 호출 가능
    * onError
       * Error Event
       * 한번 호출되면, 그 시점에서 종료 및 구독 폐기
    * onCompleted
       * 완료 Event
       * 한번 호출되면, 그 시점에서 종료 및 구독 폐기
```
public enum Event<Element> {
    case next(Element)
    case error(Swift.Error)
    case completed
}
```
4. 예시
- 상기의 3가지의 조합으로 여러가지 동작을 표현할 수 있다.
   * Ex1) URL로 무언가를 Download</br>
   통신 시작 -> onNext(통신결과) -> onCompleted

   * Ex2) Network 접속이 없는 경우</br>
   통신 시작 -> onError("no internet")

   * Ex3) Image을 Download 할 경우 먼저 Thumbnail -> Image Download의 경우</br>
   Download 시작 ->  onNext(Thumbnail Download) -> onNext(Image Download) -> onCompleted

### 2. Observable과 Observer
   * **Observable: Event 발생지**
   * **Observer: Event 처리**

```
//Code 1

let observable = textField.rx.text.asObservable()
let subscription = observable
    .subscribe(onNext: { string in
        print(string)
    })
```
- Observable: textField.rx.text.asObservable()
- Observer: { string in print(string) }

### 3. Subscribe
* Code 1에서 onNext는 Observable에서 onNext Event가 흘러들어온 시점에서의 처리로  { string in print(string) }을 등록하고 있다. 동일하게 onCompleted, onError도 등록 가능하다.
```
let observable = textField.rx.text.asObservable()
let subscription = observable
    .subscribe(onNext: { string in
        print(string)
    }, onError: { error in
        print(error)
    }, onCompleted: { _ in
        print("completed")
    })
```
위와 같이 등록된 처리를 **Observer** 라고 부른다.</br>
<mark>subscribe는 더 큰 의미의 HOT/CLOD가 있으며, 추후 Study 후 추가 예정</mark>

### 4. dispose
* subscribe 처리를 언제까지고 계속 할 수 없다. 때문에 정지를 위해 dispose를 호출한다.</br>
Code 1에서 아래와 같이 dispose 가능
```
subscription.dispose()
```
onCompleted나 onError이 발생하면 Observable는 더 이상 Event를 발생 할 수 없기 때문에 자동적으로 dispose된다. 즉 명시적으로 dispose 할 필요는 없다.
dispose는 적절하게 쓰지 않으면 Memory Leak가 발생한다. 하나하나 해제처리를 하면 bug 및 code가 지저분해지므로 DisposeBag를 사용하면 반자동적으로 해제한다.
### 5. DisposeBag
* disposeBag는 disposeBag object 자신이 개방되는 시점에 등록된 subscription을 dispose한다.
```
{
    let disposeBag = DisposeBag()
    Observable<Int>.never()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}()
```
Observable< Int >.never()은 onCompleted을 하지 않은 observable이다. 이것을 subscribe()만 한것 만으로도 dispose되지 않는다. disposeBag를 등록하면 closer가 끝나는 시점에 disposeBag()는 개방되고 구독 처리도 해지된다.
### 6. Observable < Element >
* Observable는 Generic로 정의되어 있다. 하나의 Observable가 다수의 onNext를 호출한다해도 반환값의 형식은 반드시 동일해야한다.</br>
Observable<String>라면 반드시 onNext Event에서는 String형의 값이 반환된다.</br>
인수에서 Element가 추측 가능하다면 형을 명시 할 필요는 없다.</br>
* 다수의 값을 반환하는 경우
   * 정리된 구조체를 만든다.
   * tuple로 만든다.

### 7. Observable 생성
* RxSwift에는 많은 생성 Method가 있디만 가장 기본적인 것은 **create**이다.</br>

**create**</br>
```
Observable<Int>.create { observer in
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    return Disposables.create()
}
```
subscribe()하면 onNext(1) -> onNext(2) -> onCompleted 순으로 Event를 발생하는 Observable이다.</br>
<mark>Disposable에 대해서는 추후 Study 후 추가</mark></br>

</br>

**just**</br>
1회 onNext(value) 직후 onCompleted를 발행
```
Observable.just(1)
```
onNext(1) -> onCompleted
아래와 같이 실행을 한다.
```
Observable<Int>.create { observer in
    observer.onNext(1)
    observer.onCompleted
    return Disposables.create()
}
```
형태는 값에서 유추되기 때문에 Observable<Int>.just(1)이라고 쓸 필요는 없다.</br>

</br>

**empty**</br>
```
Observable<Int>.empty()
```
onCompleted
아래와 같이 실행을 된다.
```
Observable<Int>.create { observer in
    observer.onCompleted
    return Disposables.create()
}
```
empty라면 형태가 추정되지 않기 때문에 형이 반드시 필요</br>

</br>

**never**</br>
어떠한 Event도 발생하지 않는다.
```
Observable<Int>.never()
```

</br>

**from** </br>
Array 등을 Observable로 변환 할 수 있다. </br>
array
```
Observable.from([1,2,3,4,5])
```
onNext(1) -> onNext(2) -> onNext(3) -> onNext(4) -> onNext(5) -> onCompleted
위와 같이 Event가 진행된다.</br>
create로 하면 아래와 같은 느낌이다.
```
Observable<Int>.create { observer in
    [1,2,3,4,5].forEach { i in
        observer.onNext(i)
    }
    observer.onCompleted()
    return Disposables.create()
}
```

</br>

**optional**
```
let a: Int? = nil
Observable.from(optional: a)
```
<mark>a가 nil이면 Observable.empty(), 값이 있으면 Observable.just(a!)와 같은 동작을 함</mark></br>
onCompleted() 또는 onNext(a!) -> onCompleted()</br>

</br>

**filter**</br>
```
let observable: Observable<Int> = Observable.from([1,2,3,4,5])
let filteredObservable: Observable<Int> = observable
    .filter { value in value > 3 }
```
원래의 observable를 onNext로 전달받은 값에 대해 조건이 true의 요소만 Observable로 변환</br>
onCompleted나 onError은 그대로 흐름</br>
onNext(4) -> onNext(5) -> onCompleted()

</br>

**map** </br>
```
let observable: Observable<Int> = Observable.from([1,2,3,4,5])
let mappedObservable: Observable<Int> = observable
    .map { value in value * 2 }
```
map은 onNext로 흐르는 값을 변환한다. onError이나 onCompleted등은 그대로 흘린다.
onNext(2) -> onNext(4) -> onNext(8) -> onNext(10) -> onCompleted()</br>
내부 구현에 따라 형이 변화는 경우도 있음
```
let observable: Observable<Int> = Observable.from([1,2,3,4,5])
let mappedObservable: Observable<String> = observable
    .map { value in "\(value)" }
```
이 경우 원래 observable는 Observable<Int>이지만 map에 의해 Observable<String>로 변환되었다.</br>

</br>

**flatMap** </br>
flapMap은 가장 많이 쓰는 Operator로써, 비 동기 처리를 계속 붙이는 것이 가능하다.
값으로 설명하면 아래와 같다.
```
let observable: Observable<Int> = Observable.from([1,2,3,4,5])
let flatMappedObservable: Observable<Int> = observable
    .flatMap { value in Observable.from(0..<value) }
```
0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4 이후 onCompleted가 흐른다.

### 9. Hot과 Cold
**<mark>Hot Observable는 원래 있었던 것에 대한 Observable, Cold Observable는 subscribe한 순간에 처음으로 처리가 실행되는 Observable이다.</mark>**</br>
ex) API Request는 Cold Obsrvable, textfield값은 Hot Observable이다.




</br>

### 10. Subject
Subject는 Obverver로써도 Observable로써도 동작하는 것</br>
Event를 받아 처리/Event를 발생 시키는 것이 가능</br>
1. PublishSubject<br>
   * 초기값이 없는 상태에서 시작하고, subscriber에는 subscribe하고 새롭게 방출되는 요소만을 전달하는 Subject이다.</br> (단, completed/error은 방출된 후에 subscribe한 subscriber에도 전달한다.)
```
let publishSubject = PublishSubject<String>()
publishSubject.onNext("1")
let subscriber1 = publishSubject
    .subscribe{ event in
        print("subscriber1:" , event.element ?? event)
}
publishSubject.onNext("2")
let subscriber2 = publishSubject
    .subscribe{ event in
        print("subscriber2:" , event.element ?? event)
}
publishSubject.onNext("3")
publishSubject.onCompleted()
let subscriber3 = publishSubject
    .subscribe{ event in
        print("subscriber3:" , event.element ?? event)
}

//출력
subscriber1: 2
subscriber1: 3
subscriber2: 3
subscriber1: completed
subscriber2: completed
subscriber3: completed
```

2. BehaviorSubject</br>
PublishSubject에 replay(최신 Event를 scuscriber에 전달하는 것) 개념을 추가한 것</br>
**초기값이 없으면 replay가 불가하고 error가 된다.** </br>
**초기값를 갖게 할것인지 element를 optional로 설정할지 필수 항목이다.**

```
let behaviorSubject = BehaviorSubject<String>(value: "1")
let subscriber1 = behaviorSubject
    .subscribe{ event in
        print("subscriber1:" , event.element ?? event)
}
behaviorSubject.onNext("2")
let subscriber2 = behaviorSubject
    .subscribe{ event in
        print("subscriber2:" , event.element ?? event)
}
behaviorSubject.onNext("3")
behaviorSubject.onCompleted()
let subscriber3 = behaviorSubject
    .subscribe{ event in
        print("subscriber3:" , event.element ?? event)
}

// 출력
subscriber1: 1
subscriber1: 2
subscriber2: 2
subscriber1: 3
subscriber2: 3
subscriber1: completed
subscriber2: completed
subscriber3: completed

```

3. ReplySubject</br>
BehaviorSubject에서는 최신 Event만을 subscriber에 전달했지만, **ReplaySubjcet는 BufferSize에 지정한 수만큰 Event를 전달하는 것이 가능하다.**</br>
단, BufferSize을 크게 하거나 영상 같은 Data가 큰 것을 많이 사용하면 메모리 문제가 발생 할 수 있다.

```
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("1")
replaySubject.onNext("2")
let subscriber1 = replaySubject
    .subscribe { event in
        print("subscriber1:", event.element ?? event)
}
replaySubject.onNext("3")

출력
subscriber1: 1
subscriber1: 2
subscriber1: 3
```

4. AsyncSubject</br>
completed가 발생했을 때 마지막 값을 subscriber에 전달
```
let asyncSubject = AsyncSubject<String>()
asyncSubject.onNext("1")
let subscriber1 = asyncSubject
    .subscribe { event in
        print("subscriber1:", event.element ?? event)
}
asyncSubject.onNext("2")
let subscriber2 = asyncSubject
    .subscribe { event in
        print("subscriber2:", event.element ?? event)
}
asyncSubject.onNext("3")
asyncSubject.onCompleted()

출력
subscriber1: 3
subscriber2: 3
subscriber1: completed
subscriber2: completed
```

<출처></br>
* https://qiita.com/_ha1f/items/e16ddc6017c4ad807c3c </br>
* https://qiita.com/_Masa_asaM_/items/02c7ecc9c4c1c88d76e1 </br>