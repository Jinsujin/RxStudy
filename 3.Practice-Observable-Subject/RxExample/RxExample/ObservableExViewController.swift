import UIKit
import RxSwift

/**
 참고 사이트:
 - https://github.com/ReactiveX/RxSwift/blob/main/Documentation/GettingStarted.md
 - https://reactivex.io/documentation/observable.html
 - https://github.com/iamchiwon/RxSwift_In_4_Hours
 - delay operator: https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=mym0404&logNo=221590409497
 */

class ObservableExViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var fetchImgDisposable: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Observable Example"
        setupViews()
        
        justOb(123)
            .subscribe(onNext: {n in
                print(n)
            })
    }
    
    // MARK:- Button Events
    @objc func touchedFromBtn() {
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
    }
    

    @objc func touchedImgDisposeBtn() {
        print("touched 이미지 가져오기 취소버튼 클릭")
        fetchImgDisposable?.dispose()
    }
    
    @objc func touchedFetchImgBtn() {
        print("--touched fetchImage button--")
        self.imageView.image = nil
        
        self.fetchImgDisposable = fetchImage()
        .subscribe(onNext: { img in
            print("subscribe onNext")
            self.imageView.image = img
        }, onError: { err in
            print("onError:", err.localizedDescription)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
// 이미지 가져오기 성공했을떄:
//        subscribe onNext
//        onCompleted
//        onDisposed
        
// 이미지 가져오기 실패했을떄:
//        onError: The file “800.600” couldn’t be opened.
//        onDisposed
        
// 이미지 가져오기 취소버튼 눌렀을떄:
//        onDisposed
    }
    
    
    // MARK:- Views
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var fromButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("From subscribe", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(touchedFromBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var imgDisposeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("이미지 가져오기 취소(dispose)", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(touchedImgDisposeBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var fetchImgButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("이미지 서버에서 가져오기", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(touchedFetchImgBtn), for: .touchUpInside)
        return btn
    }()
    


    // MARK:- Private functions
    /// size : "800x600"
    private func fetchImage(_ size: String = "800x600") -> Observable<UIImage?> {
        return Observable.just(size)
//            .delay(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
    }
    
    
    private func justOb<E>(_ element: E) -> Observable<E> {
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    
    private func setupViews() {
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0)
        ])
        
        let stackButtons1 = UIStackView(arrangedSubviews: [fromButton])
        stackButtons1.distribution = .equalSpacing
        let stackButtons2 = UIStackView(arrangedSubviews: [fetchImgButton])
        let stackButtons3 = UIStackView(arrangedSubviews: [imgDisposeButton])
        
        let stack = UIStackView(arrangedSubviews: [stackButtons1, stackButtons2, stackButtons3])
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
