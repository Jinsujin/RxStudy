//
//  ViewController.swift
//  MyBiCycle
//
//  Created by chalie on 2022/01/03.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class PlayBicycleVC: UIViewController {

    @IBOutlet weak var startTxtFld: UITextField!
    @IBOutlet weak var endTxtFld: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    //var viewModel: PlayBicycleVM = PlayBicycleVM()
    var locationManager = CLLocationManager()
    var startPin: MKAnnotation?
    var endPin: MKPointAnnotation?
    var startLocation2D: CLLocationCoordinate2D?
    var endLocation2D: CLLocationCoordinate2D?
    
    //Diliver user's input to viewmodel
    private lazy var viewModel = PlayBicycleVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self
        startTxtFld.delegate = self
        endTxtFld.delegate = self
        //mapView.delegate = self
        
        //Display the user position after load the viewcontroller
        //viewModel.currentPosition(mapView)
        //validTxtFld(textField: startTxtFld)
        
        //allElementBind()
        
    }
    
    //TextFld Bind to ViewModel
    private func subscribeOn() {
        print("Subscribe ON")
        
            startTxtFld.rx.text.orEmpty.asObservable()
                .subscribe { [weak self] in
                    guard let value = $0.element else {return}
                    self?.viewModel.txtFldChanged(text: value, sort: "start")
                }
                .disposed(by: disposeBag)
            
            endTxtFld.rx.text.orEmpty.asObservable()
                .subscribe { [weak self] in
                    guard let value = $0.element else {return}
                    self?.viewModel.txtFldChanged(text: value, sort: "end")
                }
                .disposed(by: disposeBag)
            
            viewModel.annotationObs.asObservable()
                .subscribe { [weak self] in
                    self?.startPin = $0.element
                    self!.mapView.addAnnotation(self!.startPin!)
                }
                .disposed(by: disposeBag)
    }
    
    private func subscribeOff() {
        print("Subscribe OFF")
        let refreshDisposeBag = DisposeBag()
        
        startTxtFld.rx.text.orEmpty.asObservable()
            .subscribe {
                [weak self] in
                print("StartField Empty")
                self?.viewModel.txtFldChanged(text: "", sort: "start")
            }
            .disposed(by: refreshDisposeBag)
        endTxtFld.rx.text.orEmpty.asObservable()
            .subscribe {
                [weak self] in
                print("EndField Empry")
                self?.viewModel.txtFldChanged(text: "", sort: "end")
            }
            .disposed(by: refreshDisposeBag)
    }
    
    
    @IBAction func pressedStartBtn(_ sender: UIButton) {
        print("Start Button Pressed")
//        mapView.userTrackingMode = .none
//        if (startPin != nil) && (endPin != nil) {
//            if (startLocation2D != nil) && (endLocation2D != nil) {
//                viewModel.drawTheRoute(mapview: mapView, start: startLocation2D!, end: endLocation2D!)
//            }
//        } else {
//
//        }
    }
    
//    func validTxtFld(textField: UITextField) {
//        textField.rx.text.subscribe(onNext: {
//            _ in
//            print("TextFld Changed")
//            if (self.startTxtFld != nil) && (self.endTxtFld != nil) {
//                if (self.startLocation2D != nil) && (self.endLocation2D != nil) {
//                    self.viewModel.drawTheRoute(mapview: self.mapView, start: self.startLocation2D!, end: self.endLocation2D!)
//                }
//            } else {
//                return
//            }
//        }).disposed(by: disposeBag)
//    }

} //End Of The Class

//extension PlayBicycleVC: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        viewModel.updateCurrentPosition(mapview: mapView, coordinate: (locations.last?.coordinate)!)
//        //아래와 같이 하는게 위의 Code보다 안정적으로 위치를 표기함 (까딱까딱이지 않음)
//        //mapView.userTrackingMode = .follow
//
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch locationManager.authorizationStatus {
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.startUpdatingLocation()
//            break
//        case .notDetermined, .denied, .restricted:
//            break
//        default:
//            break
//        }
//    }
//}
//
//extension PlayBicycleVC: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let myPolyLineRenderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
//        myPolyLineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.5)
//        myPolyLineRenderer.lineWidth = 7
//        print("Render OK")
//        return myPolyLineRenderer
//    }
//}

extension PlayBicycleVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        subscribeOn()
        //Move to Start Pin when startTextfield was typed
//        if textField == startTxtFld && startTxtFld.text != "" {
//            viewModel.getcoordinateFromAddress(startTxtFld.text!, mapview: mapView) {
//                success in
//                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                let coordinate = CLLocationCoordinate2DMake(self.viewModel.resultLatitude!, self.viewModel.resultLongtitude!)
//                self.startLocation2D = coordinate
//                let region = MKCoordinateRegion(center: coordinate, span: span)
//                self.viewModel.generateAnnotation(pinStr: "start", lat: self.viewModel.resultLatitude!, lon: self.viewModel.resultLongtitude!) {
//                    success in
//                    self.startPin = self.viewModel.startPin
//                    self.mapView.userTrackingMode = .none
//                    self.mapView.region = region
//                    self.startPin?.coordinate = coordinate
//                    self.mapView.addAnnotation(self.startPin!)
//                }
//            }
//        }
//
//        //Move to End Pin when endTextfield was typed
//        if textField == endTxtFld && endTxtFld.text != "" {
//            viewModel.getcoordinateFromAddress(endTxtFld.text!, mapview: mapView) {
//                success in
//                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                let coordinate = CLLocationCoordinate2DMake(self.viewModel.resultLatitude!, self.viewModel.resultLongtitude!)
//                self.endLocation2D = coordinate
//                let region = MKCoordinateRegion(center: coordinate, span: span)
//                self.viewModel.generateAnnotation(pinStr: "end", lat: self.viewModel.resultLatitude!, lon: self.viewModel.resultLongtitude!) {
//                    success in
//                    self.endPin = self.viewModel.endPin
//                    self.mapView.userTrackingMode = .none
//                    self.mapView.region = region
//                    self.endPin?.coordinate = coordinate
//                    self.mapView.addAnnotation(self.endPin!)
//                }
//            }
//        }
        subscribeOff()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.startTxtFld.isFirstResponder || self.endTxtFld.isFirstResponder) {
            self.startTxtFld.resignFirstResponder()
            self.endTxtFld.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == startTxtFld {
//            startTxtFld.text = ""
//            if self.startPin != nil {
//                mapView.removeAnnotation(startPin!)
//                viewModel.startPin = nil
//            }
//        }
//        if textField == endTxtFld {
//            endTxtFld.text = ""
//            if endPin != nil {
//                mapView.removeAnnotation(endPin!)
//            }
//        }
    }
}
