//
//  ViewController.swift
//  useGPS
//
//  Created by Daichi Yoshikawa on 2020/09/14.
//  Copyright © 2020 Daichi Yoshikawa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    /// ロケーションマネージャ
    var locationManager: CLLocationManager!
    
    //位置情報
    var location: CLLocation?
    // 緯度
    var latitude: CLLocationDegrees?
    // 経度
    var longitude: CLLocationDegrees?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        
    }
    
    /// ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            // 位置情報取得を開始
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    //緯度を表示
    @IBOutlet weak var printLatitude: UILabel!
    
    //経度を表示
    @IBOutlet weak var printLongitude: UILabel!
    
    //位置情報を表示するボタン
    @IBAction func location(_ sender: Any) {
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            self.printLatitude.text = String(self.latitude!)
            self.printLongitude.text = String(self.longitude!)
            pinOnMap()
        }
        
    }
    
    /// アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func pinOnMap(){
        
        if let targetCoordinate = self.location?.coordinate{
        
            let pin = MKPointAnnotation()
            
            //ピンの奥歯遺書に緯度経度を設定
            pin.coordinate = targetCoordinate
            
            self.map.addAnnotation(pin)
            
            //緯度経度を中心に半径500mの範囲を表示
            self.map.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
            
        }
        
        
    }
    
    //リセットボタン
    @IBAction func reset(_ sender: Any) {
        self.printLatitude.text = "ここに緯度を表示します"
        self.printLongitude.text = "ここに経度を表示します"
    }

    //マップ
    @IBOutlet weak var map: MKMapView!
    
    
}

extension ViewController: CLLocationManagerDelegate {

    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        self.latitude = location?.coordinate.latitude
        self.longitude = location?.coordinate.longitude
    }
}

