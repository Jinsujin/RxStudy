//
//  MainPageNode.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import Then
import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class MainPageView: UIView {
    var topView: MainPageTopView?
    var tableView = UITableView()
    var addButton = UIButton()
    var disposeBag = DisposeBag()
    var viewModel: TODOViewModel?
    var hide = false
    
    convenience init(viewModel: TODOViewModel) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.viewModel = viewModel
        uiBuild()
        bind()
    }
    
    func uiBuild() {
        addSubviews(tableView, addButton)
        
        guard let viewModel = self.viewModel else { fatalError("viewModel Error") }
        
        topView = MainPageTopView(viewModel: viewModel).then {
            insertSubview($0, at: 0)
            $0.snp.makeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(50)
            }
            
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            
            $0.register(
                TodoTableViewCell.self,
                forCellReuseIdentifier: TodoTableViewCell.identifier
            )
            
            $0.snp.makeConstraints {
                guard let topView = topView else { fatalError("topView Optional Error") }
                $0.top.equalTo(topView.snp.bottom)
                $0.left.right.equalToSuperview().inset(5)
                $0.bottom.equalToSuperview()
            }
        }
        
        addButton.do {
            let size: CGFloat = 50
            $0.titleLabel?.font = .base(.bold, 50)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("+", for: .normal)
            $0.backgroundColor = .white
            
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.cornerRadius = size / 2
            $0.layer.shadowRadius = 5
            
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 3, height: 3)
            
            $0.snp.makeConstraints {
                $0.width.height.equalTo(size)
                $0.right.bottom.equalToSuperview().inset(5)
            }
        }
    }
    
    func bind() {
        
        viewModel?.todoObservable
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: TodoTableViewCell.identifier,
                    cellType: TodoTableViewCell.self
                )
            ) { _, element, cell in
                guard let title = element.title, let dDayDate = element.dday else { return }
                
                cell.titleText.text = title
                cell.dDayText.text = String("D\(getDDay(date: dDayDate))")
            }
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset.subscribe(with: self, onNext: { owner, point in
            let height = owner.tableView.contentSize.height - owner.tableView.frame.height
            
            if point.y >= height * 0.95, !owner.hide {
                UIView.animate(
                    withDuration: 5.0,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        owner.addButton.snp.updateConstraints {
                            $0.bottom.equalTo(100)
                        }
                    }, completion: { _ in
                        owner.hide = true
                    }
                )
            } else if point.y < height * 0.95, owner.hide {
                UIView.animate(
                    withDuration: 5.0,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        owner.addButton.snp.updateConstraints {
                            $0.bottom.equalTo(5)
                        }
                    }, completion: { _ in
                        owner.hide = false
                    }
                )
            }
        }
        )
            .disposed(by: disposeBag)
        
    }
}

extension MainPageView: UITableViewDelegate {
// swiftlint:disable line_length
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // swiftlint:enable line_length
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, result in
            if let todo = self.viewModel?.get(at: indexPath.row) {
                self.viewModel?.removeTODO(todo: todo)
                result(true)
            } else { result(false) }
            
        }
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    // swiftlint:disable line_length
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // swiftlint:enable line_length
        let noti = viewModel?.get(at: indexPath.row)?.noti ?? false
        
        let notiAction = UIContextualAction(
            style: .normal,
            title: noti ? "알림 끔" : "알림 켬"
        ) { _, _, result in
            if let todo = self.viewModel?.get(at: indexPath.row) {
                self.viewModel?.noti(todo, on: !noti)
                result(true)
            } else { result(false) }
        }
        notiAction.backgroundColor = .blue
        
        let modifyAction = UIContextualAction(style: .normal, title: "수정") { _, _, result in
            // 페이징
            result(true)
            
        }
        modifyAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [modifyAction, notiAction])
    }
}
