# 3주차
**Observable 실습**

간단한 스탑워치를 구현해 보았습니다.

Check 기능을 넣고, 밑에 리스트를 추가하려고 했는데, 

시간이 조금 걸려서 그냥 여기에서 마무리 하려고 합니다.

보조 라이브러리로 [SnapKit](https://github.com/SnapKit/SnapKit), [Then](https://github.com/devxoul/Then)을 사용하였습니다.

핵심 코드는 [`MainViewController`](testApp/MainViewContgroller.swift)에 모두 작성하였습니다.

`timerSubject`에서 시간을 받아 textLabel로 표현합니다.

```Swift
// 38번 라인
        timerSubject 
            .filter { _ in !self.paused }
            .map { doubleToTimeString($0) }
            .bind(to: timerTextLabel.rx.text)
            .disposed(by: self.disposeBag)


// Util.swift
// https://stackoverflow.com/a/28872601
func doubleToTimeString(_ timeDouble: Double) -> String {
    let timeInt = Int(timeDouble)
    let ms = Int((timeDouble.truncatingRemainder(dividingBy: 1)) * 100) // 2자리만 표기하므로 100을 곱함.
    
    let hours = (timeInt / 3_600) == 0 ? "" : String(format: "%0.2d:", timeInt / 3_600)
    let minutes = (timeInt / 60) % 60 == 0 ? "" : String(format: "%0.2d:", (timeInt / 60) % 60)
    let seconds = String(format: "%0.2d.%0.2d", timeInt % 60, ms)

    return hours + minutes + seconds
}

```

버튼에 대한 상호작용은 `startButtonTap()`함수에 작성하였습니다.

`ready`상태일 때, 버튼을 누르면
0.01초의 간격을 둔 timer가 실행됩니다.
timer에서는 시작시간부터의 시간차를 기록하여 `timerSubject`로 데이터를 보냅니다.

<br>

disposed 될 시에, 초기화값인 `0.0`을 보내는데요,

disposed는 `clearButton`을 탭하였을 때, 적용됩니다.

```Swift
// 타이머 작동 함수 (108번 라인)
case .ready:
            timerStatus = .start
            startTime = CFAbsoluteTimeGetCurrent()
            startButton.setTitle("PAUSE", for: .normal)
            
            Observable<Int>.timer(
                .milliseconds(10),
                period: .milliseconds(10),
                scheduler: MainScheduler.instance
            )
                .filter { _ in self.timerStatus != .ready }
                .subscribe(
                    with: self,
                    onNext: { owner, _ in
                        if owner.timerStatus == .start, let startTime = owner.startTime {
                            owner
                                .timerSubject
                                .onNext(CFAbsoluteTimeGetCurrent() - startTime)
                        }
                    },
                    onDisposed: { owner in owner.timerSubject.onNext(0.0) }
                )
                .disposed(by: timerDisposeBag)
```

```Swift
// clear버튼 함수 (91번 라인)

$0.rx.tap.bind(with: self) { owner, _ in
                owner.timerStatus = .ready
                owner.startButton.setTitle("START", for: .normal)
                owner.timerDisposeBag = DisposeBag()
            }
            .disposed(by: self.disposeBag)
```