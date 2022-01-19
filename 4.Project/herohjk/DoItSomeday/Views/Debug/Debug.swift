// swiftlint:disable:this file_name
//
//  Debug.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/17.
//


import Foundation

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ViewRepresentable: UIViewRepresentable {
    let view: UIView

    func makeUIView(context: Context) -> UIView {
        view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

@available(iOS 13.0, *)
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

#endif
