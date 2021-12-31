import UIKit
import RxSwift

class SubjectExViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private var observable = BehaviorSubject<Int>(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Subject Example"
        
        setupViews()
        
    }
    
    @objc func touchedRelaySubjectBtn() {
        
    }
    
    
    @objc func touchedSubjectEventBtn() {
        let subject = PublishSubject<Int>()
        
        // 구독하기 전에 방출된 이벤트에 대해서는 받을 수 없다.
        subject.onNext(-5)
        subject.onNext(-4)
        
        let subscriber1 = subject.subscribe(onNext: { (num) in
            print("subscriber 1️⃣: ", num)
        }, onError: { error in
            print("subscriber 1️⃣ Error: ", error.localizedDescription)
        }, onCompleted: {
            print("subscriber 1️⃣ onCompleted")
        }, onDisposed: {
            print("subscriber 1️⃣ onDisposed")
        })
        
        let subscriber2 = subject.subscribe(onNext: { (num) in
            print("subscriber 2️⃣: ", num)
        }, onError: { error in
            print("subscriber 2️⃣ Error: ", error.localizedDescription)
        }, onCompleted: {
            print("subscriber 2️⃣ onCompleted")
        }, onDisposed: {
            print("subscriber 2️⃣ onDisposed")
        })
        
        // input - subject는 값을 외부에서 넣어줄 수 있다.
        subject.onNext(1)
        subject.onNext(2)
        
        print("[input] subject complete")
        subject.onCompleted()
//        subject.onError()
        print("isDisposed: ",subject.isDisposed)
        
        //  가 되면, subject는 더이상 방출하지 않는다.
        subject.onNext(10)
        subject.onNext(20)
    }
    
    
    // MARK:- Private functions
    private func bindUI() {
        
        
    }
    
    /// Operator 를 Hot으로 변환해  Subscribe하기 이전에 발급 된 값을 처리하자
    @objc func touchedColdToHot() {
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
        // publish 라는 Hot 변환 연산자를 사이에 끼우는 것으로, Subscribe하는 이전에 스트림을 강제로 실행시킬 수 있다.
    }
    
    @objc func touchedCold() {
        let subject = PublishSubject<String>()
                
        // subject에서 생성된 Observable은 [Hot]
        let sourceObservable = subject.asObservable()

        // 스트림에 흘러 들어온 문자열을 연결하여 새로운 문자열로 만드는 스트림
        // Scan()은 [Cold]
        //scan: 이전에 방출된 아이템과 새로 방출된 아이템을 결합해 현재 아이템을 생성합니다.
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
        
        // 실행 결과
        // subscribed
        // Event next(C)
        // Event completed
        // isDisposed
        // "C" 가 결과값으로 나오는 것은, Scan 오퍼레이터가 Cold이기 때문에 Subscribe 전에 발행된 A 그리고 B 가 처리되지 않았기 때문.
        // “Subscribe하기 이전에 발급 된 값을 처리 했으면 좋겠다”는 경우는 어떻게 하면 좋을까요. 이 경우 Hot 변환 오퍼레이터를 끼워 Subscribe하기 이전에 스트림을 시작하면 된다.
    }
    
    private lazy var subjectEventButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Subject 이벤트 흐름", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(touchedSubjectEventBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var relaySubjectButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Relay Subject", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(touchedRelaySubjectBtn), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var coldOperatorButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Subject + Cold Operator", for: .normal)
        btn.backgroundColor = .purple
        btn.addTarget(self, action: #selector(touchedCold), for: .touchUpInside)
        return btn
    }()
    
    private lazy var coldOperatorToHotButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Subject + Cold Operator(->Hot Change)", for: .normal)
        btn.backgroundColor = .purple
        btn.addTarget(self, action: #selector(touchedColdToHot), for: .touchUpInside)
        return btn
    }()
    
    
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [subjectEventButton, relaySubjectButton, coldOperatorButton, coldOperatorToHotButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
}
