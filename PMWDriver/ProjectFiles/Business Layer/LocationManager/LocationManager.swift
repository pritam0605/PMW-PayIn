//
//  LocationManager.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 07/11/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MyLocationManager: NSObject {
    static let share = MyLocationManager() //single tone class
   
    var internalTimer: Timer?
    var myCurrentLocaton:CLLocationCoordinate2D?
     let manager = CLLocationManager()
    
    //MARK: - Location Permission
    func requestForLocation(){
        //Code Process
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        print("Location granted")
    }
    
    func configManager()  {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
        
    }
    
    
    
    
}

extension MyLocationManager:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    myCurrentLocaton = manager.location?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension MyLocationManager {

    func startTimer(){
        guard self.internalTimer == nil else {
            return
           // fatalError("Timer already intialized, how did we get here with a singleton?!")
        }
        self.internalTimer = Timer.scheduledTimer(timeInterval: 120.0 /*1800 seconds = 30min*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer(){
        guard self.internalTimer != nil else {
            return
           // fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
        self.internalTimer = nil
    }
    
    @objc func fireTimerAction(sender: AnyObject?){
      self.updateCurrentLocationToServer()
        debugPrint("Timer Fired! \(String(describing: sender))")
    }
}

 //MARK: - Extension for Api call
extension  MyLocationManager {
    
    struct LocationStatus : Codable {
        let status : Int?
        let message : String?
        enum CodingKeys: String, CodingKey {
            case status = "status"
            case message = "message"
          
        }
    }
    
    //MARK: - Call api to update location to server
    func updateCurrentLocationToServer(){
        let apiManager = ServerRequestHandler()
        guard let token =  UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) else {
          return
        }
        guard   let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID) else {
            return
        }
        
        guard   let carID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) else {
            return
        }
        let lat:Double  = self.myCurrentLocaton?.latitude ?? 0.00
        let long:Double  = self.myCurrentLocaton?.longitude ?? 0.00
        
        let paramiter =   [
            "device_type": "1",
            "token_key": token,
            "shift_id": shiftID,
            "car_id": carID,
            "lat": lat,
            "lon": long
            ] as [String : Any]
        apiManager.callWebServiceApi(url: API.UpdateLocation.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: LocationStatus.self, success: { (status, message, dict) -> (Void) in
            
        }, failed: { (message) in
          debugPrint(message)
        })
    }
}
