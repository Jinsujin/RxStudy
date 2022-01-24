//
//  BicycleModel.swift
//  MyBiCycle
//
//  Created by chalie on 2022/01/03.
//

import Foundation
import MapKit
import RxCocoa
import RxSwift

typealias completionHandler = (_ Success: Bool) -> ()

protocol BicycleModelProtocol {
    //func getCoordinateFromAddress(_ getAddress: String) -> [Double]
    func getCoordinateFromAddress(_ getAddress: String)
}

class BicycleModel: BicycleModelProtocol {

    private let coordinateSub = PublishSubject<[Double]>()
    var coordinateObs: Observable<[Double]> {
        return coordinateSub
    }
    
    private let latBeSub = PublishSubject<Double>()
    var latitudeObservable: Observable<Double> {
        return latBeSub
    }
    
    private let lonBeSub = PublishSubject<Double>()
    var longitudeObservable: Observable<Double> {
        return lonBeSub
    }
    
    private let annotation = PublishSubject<MKAnnotation>()
    var annotationObs: Observable<MKAnnotation> {
        return annotation
    }
    
    private let disposeBag = DisposeBag()
    
    //Convert Coordinate[Double] from String Address
//    func getCoordinateFromAddress(_ getAddress: String) -> [Double] {
//        print("Get Coordinate")
//        let latitudeSubject = PublishSubject<CLLocationDegrees>()
//        let longitudeSubject = PublishSubject<CLLocationDegrees>()
//        var resultLat: Observable<CLLocationDegrees> { return latitudeSubject }
//        var resultLon: Observable<CLLocationDegrees> { return longitudeSubject }
//
//        CLGeocoder().geocodeAddressString(getAddress) {
//            placeMarks, error in
//            print("Geo")
//            if let lat = placeMarks?.first?.location?.coordinate.latitude {
//                latitudeSubject.onNext(lat)
//            }
//            if let lon = placeMarks?.first?.location?.coordinate.longitude {
//                longitudeSubject.onNext(lon)
//            }
//        }
//        Observable.zip(latitudeSubject, longitudeSubject) {
//            lat, lon in
//            var coordinateArray: [Double] = []
//            coordinateArray = [lat, lon]
//            //returnArrObservable.bind(onNext: coordinateArray)
//            self.returnArrObservable.subscribe(onNext: {
//                arr in
//                //Call Annotation from coordinate [double]
//                print("Call Annotation")
//            })
//            returnArrObservable.onNext(returnArray)
//        }
//
//        return returnArray
//    }
    
    func getCoordinateFromAddress(_ getAddress: String) {
        CLGeocoder().geocodeAddressString(getAddress) { [self]
            placeMarks, error in
            if let lat = placeMarks?.first?.location?.coordinate.latitude {
                self.latBeSub.onNext(lat)
                print(lat)
            }
            if let lon = placeMarks?.first?.location?.coordinate.longitude {
                self.lonBeSub.onNext(lon)
                print(lon)
            }
            Observable.zip(latitudeObservable, longitudeObservable) {
                lat, lon in
                print("ZIP")
                self.coordinateSub.onNext([lat, lon])
                self.getAnnotation(lat: lat, lon: lon)
            }
        }
    }
    
    func getAnnotation(lat: Double, lon: Double) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        annotation.onNext(pin)
    }
    
    
    
    //Create Annotation from Coordinate[Double]
    
    
}//End Of The Class


