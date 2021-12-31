import UIKit
import RxSwift

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchedObservableBtn(_ sender: Any) {
        let vc = ObservableExViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func touchedSubjectBtn(_ sender: Any) {
        let vc = SubjectExViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

