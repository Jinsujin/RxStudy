//
//  AddTodoController.swift
//  RxTodo
//
//  Created by jsj on 2022/01/05.
//

import UIKit

class AddTodoViewController: UIViewController {

    var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.title = "투두 만들기"
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    
    @objc func touchedConfirmButton() {
        guard let title = titleTextField.text else {
            return
        }
        completion?(title)
        navigationController?.popViewController(animated: false)
    }

    private func setupViews() {
        self.navigationItem.rightBarButtonItem = self.confirmButton
        
        self.view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            titleTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(self.view.bounds.height * 0.2))
        ])
    }
    

    private lazy var titleTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "타이틀을 입력해 주세요"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        textField.delegate = self
        return textField
    }()
    
    
    private lazy var confirmButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchedConfirmButton))
        return button
    }()
}


