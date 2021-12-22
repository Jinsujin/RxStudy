# 2주차
**Observable과 Subject, 그리고 추가적으로 Traits 정리**
# 목차
- [2주차](#2주차)
- [목차](#목차)
- [Observable](#observable)
  - [Observable 이란?](#observable-이란)
  - [Observable의 생명 주기](#observable의-생명-주기)
  - [HotObservable, ColdObservable](#hotobservable-coldobservable)
    - [share](#share)
- [Subject](#subject)
  - [PublishSubject](#publishsubject)
  - [BehaviorSubject](#behaviorsubject)
  - [AsyncSubject](#asyncsubject)
  - [ReplaySubject](#replaysubject)
- [Traits](#traits)
  - [RxSwift의 Traits](#rxswift의-traits)
    - [Completable](#completable)
    - [Single](#single)
    - [Maybe](#maybe)
    - [Infallible](#infallible)
  - [RxCocoa의 Traits](#rxcocoa의-traits)
    - [Driver](#driver)
    - [Signal](#signal)
  - [RxCocoa의 Relay](#rxcocoa의-relay)
- [자료 출처](#자료-출처)
# Observable
## Observable 이란?
* RxSwift에서 가장 기본이되는 단위
  * RxSwift는 비동기적 프로그래밍 API라는 전제
* 관찰자(=구독자)는 함수, 메소드를 호출하는 대신, `Observable`을 호출하여 사용
* 병렬 처리인 만큼, 작업을 기다리는 동안 동시에 모든 작업을 시작할 수 있음
* [`ReactiveX`]([http](http://reactivex.io/documentation/observable.html)) 문서에 따라, `관찰자`는 `Observable`을 `구독`한다고 표현함.
* `함수형 프로그래밍`논리에 포함하여 함수를 포함한 모든 `값`을 가질 수 있음.
* `error`, `complete`가 되어 `Observable`이 종료된 상황이 아니라면, 언제든 해당 `Observable`의 상황에 따라 항상 값이 `emit(방출)`될것을 염두
* `Observable`의 모델을 일반적으로 [`Reactor Pattern(반응기 패턴)`](https://en.wikipedia.org/wiki/Reactor_pattern)이라고 명명

## Observable의 생명 주기
* `emit(방출)`의 구분은 세가지로 나뉘어 짐
  * `next`
    * `Observable`이 항목을 방출할 때 마다 호출되는 메서드
    * `Observable`이 내보낸 `값`을 매개변수로 이용
  * `error`
    * 데이터 생성에 실패하거나, 다른 오류가발생했을 때 방출
    * 방출을 끝으로, 더이상의 `next`를 호출하지 않음
    * 해당 에러를 매개변수로 이용
  * `complete`
    * 마지막 호출이후 더이상 호출할 일이 없을 때 방출
    * `error`와 마찬가지로 더이상의 `next`를 호출하지 않음
    * 매개변수를 가지지 않음
  * `disposed`
    * RxSwift6에서 새롭게 추가된 개념.
    * `Complete` or `Error`의 경우 `Observable`에서 관리를 하지만, `Observable`이 아닌 외부(`DisposeBag`같은)에서 중지를 시켰을때 작동됨.
    * `compete`와 마찬가지로 매개변수를 가지지 않음

```Swift
import RxSwift

// 아래 항목들은 정확히 클로저 변수라고 표현해야 하지만,
// Swift가 아닌, ReactiveX자체에서 일급 함수의 개념적 표현으로 함수라고 이름을 붙여줌.
let nextFunction: (Int) -> Void = { entity in
  // TODO: entity에 따른 작업
    print(entity)
}
let errorFunction: (Error) -> Void = { error in
  // TODO: 에러 처리
}

let completedFunction: () -> Void = {
  // TODO: 완료 후 작업
}

let disposedFunction: () -> Void = {
    // TODO: Disposed 이후 작업
}


let observable = Observable<Int>.just(1)

observable
    .subscribe(
        onNext: nextFunction,
        onError: errorFunction,
        onCompleted: completedFunction,
        onDisposed: disposedFunction
    )
```

## HotObservable, ColdObservable
* `Observable`의 시퀀스를 방출하기 시작한 시점에 따른 구분
* `Observable`이 생긴 시점부터 방출을 하게된다면, `Hot Observable`
* `Subscriber(구독자)`가 생긴 시점부터 방출을 하게 된다면, `Cold Observable`
* 대부분 `Cold Observable`의 성격을 띄고 있으나, 대표적으로 `share` 연산을 사용하는 `Observable`들 같은 경우에는 `Hot Observable`의 성격을 띄고 있음

### share
* `Observable`은 구독하기 전까지는 작동하지 않음
* 다만 구독을 할때마다 새로운 생성(`create`)을 호출해 새로운 `Observable`을 생성
* share는 이 `Observable`을 매번 새로생성하지 않고, 값을 공유하기 위한 함수
* 기본값은 `shared(replay: 1, scope: .whileConnected)`
  * replay: 해당 Observable의 버퍼 크기
  * scope: 유지 방식
    * `whileConnected` -> 하나라도 연결되어 있따면 버퍼가 유지됨
    * `forever` -> 한번이라도 버퍼가 생성되었다면, 버퍼가 유지됨

# Subject
* `Observable`의 변형으로, 시퀀스가 아닌, `상태값(Status)`을 가지고 있는 `변수`
* Publisher인 동시에, Observer가 될 수 있음
* 종류는 대표적으로 네가지가 있음
  * PublishSubject
  * BehaviorSubject
  * AsyncSubject
  * ReplaySubject

## PublishSubject
![](resources/publishsubject.png)
* 구독자들에게, 구독 이후의 데이터들만 방출
* 생성 즉시 방출을 시작할수 있음
  * 하지만 구독자들에겐 구독시점의 데이터들만 방출되기에, 적절한 조치가 필요함

```Swift
import RxSwift

let disposeBag = DisposeBag()

let publishsubject = PublishSubject<String>()

publishsubject.onNext("PublishSubject1")

publishsubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)

publishsubject.onNext("PublishSubject2")

// "PublishSubject2"만을 결과로 받아볼 수 있음.
```
## BehaviorSubject
![](resources/behaviorsubject.png)
* 구독자들에게, 구독을 시작하는 시점에 최근 `값`을 방출
* 생성자에 기본 `값`이 필요
* 기본값 = 최근값
```Swift
import RxSwift

let disposeBag = DisposeBag()

let behaviorSubject = BehaviorSubject<String>(value: "BehaviorSubject")

behaviorSubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)

behaviorSubject.onNext("BehaviorSubject2")

behaviorSubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)

// 구독을 두번 진행하였음
// 첫번째 구독자는 이전 값인 "BehaviorSubject"와, 최신값인 "BehaviorSubject2"를 수신하지만,
// 두번째 구독자는 이미 구독시점에 이전 값이 "BehaviorSubject2"가 되어있으므로, "BehaviorSubject2"만 수신함.
```
## AsyncSubject
![](resources/asyncsubject.png)
* 몇개를 방출하냐와 상관 없이, `Complete`이후 가장 마지막 값을 방출
* `Error`가 나오거나, `Disposed`가 되면 어떠한 값도 방출하지 않음.
```Swift
import RxSwift

let disposeBag = DisposeBag()

let asyncSubject = AsyncSubject<String>()
asyncSubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
asyncSubject.onNext("PublishSubject")
asyncSubject.onNext("BehaviorSubject")
asyncSubject.onNext("ReplaySubject")
asyncSubject.onNext("AsyncSubject")
//disposeBag = DisposeBag()
//asyncSubject.onError(RxError.argumentOutOfRange)
asyncSubject.onCompleted()
// Completed가 난 이후에 가장 마지막 값을 방출.
// 위 상황처럼 주석되어진 disposed or error를 방출하게 된다면, Subscriber는 어떠한 값도 받아볼 수 없음.
```
## ReplaySubject
![](resources/replaysubject.png)
* `BehaviorSubject`와 유사한 기능을 가졌으나, 최근 값이 아닌, `버퍼 사이즈 만큼의 값`을 가지는 `Subject`
* 버퍼 사이즈가 1이라면 `BehaviorSubject`와 동일
* 버퍼 사이즈가 0이라면 `PublishSubject`와 동일

```Swift
import RxSwift

let disposeBag = DisposeBag()

let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)

replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")

replaySubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
// 첫 구독자는 1, 2, 3이 출력되며
// 두번째 구독자는 버퍼사이즈가 2이기 때문에 구독을 시작하는 순간 2, 3이 출력됨.
```
# Traits
* 상황에 맞게끔 `Observable`을 변형한 객체
* `Subject`들도 Trait에 포함됨
 
## RxSwift의 Traits
### Completable
* 어떠한 요소도 방출하지 않음
* `Complete` 혹은 `Error`만을 방출

### Single
* `Observable`의 Next와 다르게 단일의 요소를 딱 한번만 방출 후 종료
* `success`, `error`의 이벤트로 구성되어 있음

### Maybe
* `Completable`과 `Single`의 합성
* `success`, `complete`, `error` 세가지중 한가지만 방출 후 종료
  
### Infallible
* `RxSwift6`에서 [새롭게 추가된 `Trait`](https://dev.to/freak4pc/what-s-new-in-rxswift-6-2nog#-raw-infallible-endraw-)
* error을 방출하지 않음
* Driver, Signal과 비슷한 특성을 가짐
  * `Driver`, `Signal` -> `RxCocoa`
  * `Infallible` -> `RxSwift`
  * MainSchedular를 사용하지 않음.
  * `share`를 기본으로 사용하지 않음.

## RxCocoa의 Traits
### Driver
* `Complete`, `Error`가 없으며, 오직 `next`와 `disposed`만 존재
* MainScheduler에서 작동
* share(replay: 1, scope: .whileConnected)를 기본으로 사용

### Signal
* `Driver`의 변형으로, 새로운 구독자에게 replay를 해주지 않음
  * = `share(replay: 0)`
* `drive` 대신, `emit`를 사용 (기능적 차이는 없음)

## RxCocoa의 Relay
* RxCocoa용 Subject와 비슷함
* `Complete`가 되지 않음
* `Error`를 방출하지 않음
* 따라서 `AsyncRelay`는 존재하지 않음

# 자료 출처
* Observable - [ReactiveX 공식 사이트](http://reactivex.io/documentation/observable.html)
* Subject - [ReactiveX 공식 사이트](http://reactivex.io/documentation/subject.html)
* Traits - [RxSwift Github Document](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
* 그 외 - [예전 공부 자료](https://herohjk.com/54)와, [PT](https://youtu.be/RQYonDUqjfs)