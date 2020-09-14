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

class ViewController: UIViewController, MKMapViewDelegate {
    /// ロケーションマネージャ
    var locationManager: CLLocationManager!
    
    //更新を止めるFlag
    var pause: Bool = false

    //位置情報
    var location: CLLocation?
    
    //ひとつ前の位置情報
    var previousLocation: CLLocation?
    // 緯度
    var latitude: CLLocationDegrees?
    // 経度
    var longitude: CLLocationDegrees?
    
    //ピンを格納するStack
    var pinStack = StackPin()
    
    //polyを格納するStack
    var polyStack = StackPoly()
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        
        map.delegate = self
        
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
    
    @IBAction func pause(_ sender: Any) {
        if pause == false{
            self.pause = true
            (sender as AnyObject).setTitle("再開", for: .normal)
        }else{
            self.pause = false
            (sender as AnyObject).setTitle("一時停止", for: .normal)
        }
    }
    
    //位置情報を更新する関数
    func updatelocation() {
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            self.printLatitude.text = String(self.latitude!)
            self.printLongitude.text = String(self.longitude!)
            //mapにピンを追加
            pinOnMap()
            //ピンを結んで軌跡を生成
            addTrajectory()
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
            
            //ピンをプッシュ
            pinStack.push(pinPush: pin)
            
            //緯度経度を中心に半径20mの範囲を表示
            self.map.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 20.0, longitudinalMeters: 20.0)
            
        }
        
        
    }
    
    func addTrajectory(){
        if let targetCoordinate = self.location?.coordinate{
                print("#####targetの中")
                print("target\(targetCoordinate)")
                if let previousTargetCoordinate = self.previousLocation?.coordinate{
                    print("######\(previousTargetCoordinate)")
                    print("####previousの中")
                    let coordinates = [targetCoordinate, previousTargetCoordinate]
                    let polyLine = MKPolygon(coordinates: coordinates, count: coordinates.count)
                    self.map.addOverlay(polyLine)
                    //スタックにプッシュ
                    polyStack.push(polyPush: polyLine)
                
                }
        }
        print("$$$$$$リターン")
    }
    
    //リセットボタン(ピンを削除)
    @IBAction func reset(_ sender: Any) {

        for _ in pinStack.stackArray{
            if let pin = pinStack.pop() {
                self.map.removeAnnotation(pin)
            }
        }
        for _ in polyStack.stackArray{
            if let poly = polyStack.pop(){
                self.map.removeOverlay(poly)
            }
        }
        
    }

    //マップ
    @IBOutlet weak var map: MKMapView!
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        print("###overlay: \(overlay)")
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .blue
        polylineRenderer.lineWidth = 2.0
        print("mapViewの中の方")
        return polylineRenderer
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {

    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.previousLocation = location ?? nil
        self.location = locations.first
        self.latitude = location?.coordinate.latitude
        self.longitude = location?.coordinate.longitude
        
        //位置情報の更新をするかどうか
        if pause == false{
        //位置情報を更新
        updatelocation()
            
        }
    }
}

