//
//  ExampleViewController.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import UIKit

import KarrotFlex
import RxDataSources
import RxSwift
import RxCocoa
import ReactorKit

class ExampleViewController: UIViewController, View {
    
    // MARK: Init
    typealias Reactor = ExampleReactor
    
    var disposeBag: DisposeBag
    
    private var tableView: UITableView {
        return self.view as! UITableView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tableView = UITableView(frame: .zero)
        
        ExampleCells.allCases.forEach {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.identifier)
        }
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = ExampleReactor()
    }
}

extension ExampleViewController {
    
    // MARK: Bind
    func bind(reactor: ExampleReactor) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<GithubSection> { dataSource, tableView, indexPath, item in
            guard let license = item.license?.name,
                  let kind = ExampleCells(rawValue: license.rawValue)
            else { return UITableViewCell() }
            
            return self.emitCell(kind: kind, indexPath: indexPath)
        }
        
        reactor.state
            .map(\.repos)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func emitCell(kind: ExampleCells, indexPath: IndexPath) -> UITableViewCell {
        switch kind {
        case .apacheLicense20:
            let cell: ApacheLicense20Cell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .gnuGeneralPublicLicenseV30:
            let cell: GnuGeneralPublicLicenseV30Cell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .microsoftPublicLicense:
            let cell: MicrosoftPublicLicenseCell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .mitLicense:
            let cell: MitLicenseCell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .mozillaPublicLicense20:
            let cell: MozillaPublicLicense20Cell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .other:
            let cell: OtherCell = kind.dequeue(tableView: tableView, for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
}
