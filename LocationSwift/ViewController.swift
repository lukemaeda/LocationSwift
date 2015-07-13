//
//  ViewController.swift
//  LocationSwift
//
//  Created by MAEDAHAJIME on 2015/07/13.
//  Copyright (c) 2015年 MAEDA HAJIME. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var ivCompass: UIImageView!
    
    @IBOutlet var lbLatLong: [UILabel]!
    
    // LocationManagerオブジェクト
    var _mgr:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 準備処理
        doReady()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 準備処理
    func doReady(){
        
        // 情報の更新を開始すれば、位置情報を取得
        if self._mgr == nil {
            // 現在地の取得.
            self._mgr = CLLocationManager()
        }
        
        self._mgr.delegate = self
        
        // 承認されていない場合はここで認証ダイアログを表示します.
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            
            println("didChangeAuthorizationStatus:\(status)");
            // NSLocationWhenInUseUsageDescriptionに設定したメッセージでユーザに確認
            self._mgr.requestWhenInUseAuthorization()
            // NSLocationAlwaysUsageDescriptionに設定したメッセージでユーザに確認
            self._mgr.requestAlwaysAuthorization()
        }
        
        // 設定（精度：最高精度（iOS4-））望まれている精度
        _mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation // iOS4以降がベスト
        // 設定（移動の閾値(m)：指定なし）
        _mgr.desiredAccuracy = kCLDistanceFilterNone
        
        // 情報更新の開始（位置）
        self._mgr.startUpdatingLocation()
        // 情報更新の開始（方角）
        self._mgr.startUpdatingHeading()
    }
    
    // 位置情報の更新時（iOS6-）
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!) {
        
        // 位置情報の取得
        let loc:CLLocation = locations.last! as! CLLocation
        let lat:CLLocationDegrees = loc.coordinate.latitude // 緯度
        let lng:CLLocationDegrees = loc.coordinate.longitude // 経度
        
        // lbLatLong
        println("緯度:%f\(lat) 経度:%f \(lng)")
        self.lbLatLong[0].text = NSString(format: "緯度：%.2f", lat) as String
        self.lbLatLong[1].text = NSString(format: "経度：%.2f", lng) as String
    }
    
    // 位置情報の更新時（iOS5-）
    func locationManager(manager: CLLocationManager!,
        didUpdateToLocation newLocation: CLLocation!,
        fromLocation oldLocation: CLLocation!) {
        
        // 位置情報の取得
        let lat:CLLocationDegrees = newLocation.coordinate.latitude // 緯度
        let lng:CLLocationDegrees = newLocation.coordinate.longitude // 経度
        
        self.lbLatLong[0].text = NSString(format: "緯度：%.2f", lat) as String
        self.lbLatLong[1].text = NSString(format: "経度：%.2f", lng) as String
    }
    
    // 方角情報の更新時
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        // コンパス画像の回転 CGFloatとの演算は常にCGFloatにコンバージョンして演算する
        var ang:CGFloat = CGFloat(-newHeading.magneticHeading) * CGFloat(M_PI) / CGFloat(100)
        self.ivCompass.transform = CGAffineTransformMakeRotation(ang)
    }

}

