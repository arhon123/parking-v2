//
//  SingleMapTableViewController.swift
//  FreeFood
//
//  Created by 김종현 on 2017. 11. 22..
//  Copyright © 2017년 김종현. All rights reserved.
//
////////////////////////////////////////////////
// DetailsInfo item name
// idx : 일련번호
// name : 시설명        : title
// loc :  급식장소
// target : 급식대상     : 2 cell
// mealDay : 급식일     : 1 cell
// time : 급식시간
// startDay : 운영시작일
// endDay : 운영종료일
// manageNm : 운영기관명  : 3 cell
// phone : 연락처        : 4 cell
// addr : 지번주소
// lng : 경도
// lat : 위도
// gugun : 구군
////////////////////////////////////////////////////

import UIKit
import MapKit
import CoreLocation

class SingleMapTableViewController: UITableViewController, CLLocationManagerDelegate {

    var sItem:[String:String] = [:]
    var locationManager: CLLocationManager!
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var singleMapView: MKMapView!
    @IBOutlet weak var sMealDay: UITableViewCell!
    @IBOutlet weak var sTarget: UITableViewCell!
    @IBOutlet weak var sManageNm: UITableViewCell!
    @IBOutlet weak var sPhone: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        // 지도에 현재 위치 마크를 보여줌
        singleMapView.showsUserLocation = true
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(sItem["addrRoad"]! , completionHandler: { placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let myPlacemarks = placemarks {
                let myPlacemark = myPlacemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = self.sItem["parkingName"]!
                
                if let myLocation = myPlacemark.location {
                    annotation.coordinate = myLocation.coordinate
                    self.annotations.append(annotation)
                }
            }
            self.singleMapView.showAnnotations(self.annotations, animated: true)
            self.singleMapView.addAnnotations(self.annotations)
            
        })
        
        self.title = sItem["parkingName"]!
        sMealDay.textLabel?.text = "유무료 여부"
        sMealDay.detailTextLabel?.text = sItem["chargeInfo"]! /*+ "  " + sItem["basicTime"]! + "분 당 " + sItem["basicCharge"]! + "원"*/
        sTarget.textLabel?.text = "운영시간"
        sTarget.detailTextLabel?.text = sItem["satStartTime"]! + " ~ " + sItem["satEndTime"]!
        sManageNm.textLabel?.text = "운영기간"
        sManageNm.detailTextLabel?.text = sItem["runDate"]
        sPhone.textLabel?.text = "전화번호"
        sPhone.detailTextLabel?.text = sItem["tel"]
    }
    
    
    // 콘솔(print)로 현재 위치 변화 출력
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let coor = manager.location?.coordinate
//        print("latitute" + String(describing: coor?.latitude) + "/ longitude" + String(describing: coor?.longitude))
//    }

}
