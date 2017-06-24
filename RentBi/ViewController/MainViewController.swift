//
//  MainViewController.swift
//  RentBi
//
//  Created by mac on 6/24/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import GoogleMaps
import LiquidFloatingActionButton
import SnapKit
import SwiftIconFont
import Material
struct ButtonLayout {
    struct Fab {
        static let diameter: CGFloat = 48
    }
}

class MainViewController: UIViewController , GMSMapViewDelegate , CLLocationManagerDelegate , LiquidFloatingActionButtonDataSource , LiquidFloatingActionButtonDelegate {


    @IBOutlet var mapView: GMSMapView!
  
    var locationManager = CLLocationManager()
    
    @IBOutlet var btnUserLocation: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

     //   let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
       // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        // User Location
        

//        btnUserLocation.layer.cornerRadius = 0.5 * btnUserLocation.bounds.size.width
//        btnUserLocation.clipsToBounds = true
   
        setupLocationManager()
        setupMaterial()
        prepareFABButton()

        // Do any additional setup after loading the view.
    }
    
    func prepareFABButton() {
       
      //  btnUserLocation = FABButton(image: UIImage(named: <#T##String#>), tintColor: <#T##UIColor#>)
        btnUserLocation.backgroundColor = Color.white
 
    }
       
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    var userLocation : CLLocation!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
       // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        locationManager.stopUpdatingLocation()
   
        
    }

    
    @IBAction func invokeCurrentLocation(_ sender: Any) {
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public class CustomCell : LiquidFloatingCell {
        var name: String = "sample"
        
        init(icon: UIImage, name: String) {
            self.name = name
            super.init(icon: icon)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func setupView(_ view: UIView) {
            super.setupView(view)
            let label = UILabel()
            label.text = name
            label.textColor = UIColor.white
            label.font = UIFont(name: "Helvetica-Neue", size: 12)
            addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(self).offset(-80)
                make.width.equalTo(75)
                make.top.height.equalTo(self)
            }
        }
    }
    
    public class CustomDrawingActionButton: LiquidFloatingActionButton {
        
        override public func createPlusLayer(_ frame: CGRect) -> CAShapeLayer {
            
            let plusLayer = CAShapeLayer()
            plusLayer.lineCap = kCALineCapRound
            plusLayer.strokeColor = UIColor.white.cgColor
            plusLayer.lineWidth = 3.0
            
            let w = frame.width
            let h = frame.height
            
            let points = [
                (CGPoint(x: w * 0.25, y: h * 0.35), CGPoint(x: w * 0.75, y: h * 0.35)),
                (CGPoint(x: w * 0.25, y: h * 0.5), CGPoint(x: w * 0.75, y: h * 0.5)),
                (CGPoint(x: w * 0.25, y: h * 0.65), CGPoint(x: w * 0.75, y: h * 0.65))
            ]
            
            let path = UIBezierPath()
            for (start, end) in points {
                path.move(to: start)
                path.addLine(to: end)
            }
            
            plusLayer.path = path.cgPath
            
            return plusLayer
        }
    }
    

        
        var cells: [LiquidFloatingCell] = []
        var floatingActionButton: LiquidFloatingActionButton!
        
        func setupMaterial() {
   
            
            //        self.view.backgroundColor = UIColor(red: 55 / 255.0, green: 55 / 255.0, blue: 55 / 255.0, alpha: 1.0)
            // Do any additional setup after loading the view, typically from a nib.
            let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
                let floatingActionButton = CustomDrawingActionButton(frame: frame)
                floatingActionButton.animateStyle = style
                floatingActionButton.dataSource = self
                floatingActionButton.delegate = self
                return floatingActionButton
            }
            
            let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
                let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
                return cell
            }
            let customCellFactory: (String) -> LiquidFloatingCell = { (iconName) in
                let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconName)
                return cell
            }
            cells.append(cellFactory("iconden-5"))
            cells.append(cellFactory("iconden-4"))
            cells.append(cellFactory("iconden-3"))
            
            let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
            let bottomRightButton = createButton(floatingFrame, .left)
            
            let image = UIImage(named: "iconden-2")
            bottomRightButton.image = image
            bottomRightButton.color = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)

            
            self.view.addSubview(bottomRightButton)

        }
        
        func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
            return cells.count
        }
        
        func cellForIndex(_ index: Int) -> LiquidFloatingCell {
            return cells[index]
        }
        
        func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
            print("did Tapped! \(index)")
            liquidFloatingActionButton.close()
        }

    @IBAction func ToggleMenu(_ sender: UIButton) {
        navigationDrawerController?.toggleLeftView()
    }

}


//Material Button
//extension MainViewController  {
//    
//}
