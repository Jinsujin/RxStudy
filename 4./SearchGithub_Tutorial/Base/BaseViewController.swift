//
//  BaseViewController.swift
//  SearchGithub_Tutorial
//
//  Created by 송형욱 on 2022/01/10.
//

import Foundation
import UIKit

class BaseViewController<View: UIView>: UIViewController {

  let body: View

  convenience init() {
    self.init(view: View())
  }

  init(view: View) {
    self.body = view
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = self.body
  }
  
}
