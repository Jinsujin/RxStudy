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
        print("isDisposed: ",subject.isDisposed)
        
        // completed 가 되면, subject는 더이상 방출하지 않는다.
        subject.onNext(10)
        subject.onNext(20)
    }
    
    
    // MARK:- Private functions
    private func bindUI() {
        
        
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
    
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [subjectEventButton, relaySubjectButton])
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
