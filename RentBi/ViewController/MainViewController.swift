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

class MainViewController: UIViewController, CLLocationManagerDelegate {
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var btnUserLocation: UIButton!
    var locationManager = CLLocationManager()
    var userLocation : CLLocation!
    var polyline: GMSPolyline?
    
    var delegate: MainPulleyViewController?
    var shops: [Shop] = []
    var markers: [CustomMarker] = []
    var filterSetting = [ "park": true, "gas": true, "rent": true ]

    override func viewDidLoad() {
        super.viewDidLoad()
   
        mapView.delegate = self
        setupLocationManager()
        setupMaterial()
        prepareFABButton()
        API.getNearbyShops(x: 0, y: 0) { shops in
            self.shops = shops
            for shop in shops {
//                print("\(shop.x) \(shop.y)")
                let marker = CustomMarker(position: CLLocationCoordinate2D(latitude: shop.y, longitude: shop.x))
                switch shop.type {
                case "park": marker.icon = UIImage(named: "icon-marker-park")
                case "rent": marker.icon = UIImage(named: "icon-marker-rent")
                case "gas": marker.icon = UIImage(named: "icon-marker-gas")
                default: break
                }
                marker.shop = shop
                marker.map = self.mapView
                self.markers.append(marker)
            }
            self.updateMarkersVisibility()
        }
    }
    
    fileprivate func updateMarkersVisibility() {
        for marker in markers {
            if filterSetting[marker.shop.type] == true {
                marker.opacity = 1
            } else {
                marker.opacity = 0
            }
        }
    }
       
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func resetCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 14.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        resetCamera()
//        print("\(userLocation!.coordinate.latitude) \(userLocation!.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func invokeCurrentLocation(_ sender: Any) {
        resetCamera()
    }
    @IBAction func ToggleMenu(_ sender: UIButton) {
        navigationDrawerController?.toggleLeftView()
    }
}

extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let marker = marker as? CustomMarker {
            let shop = marker.shop
            delegate?.onShopSelected(shop!, userLocation!.coordinate.latitude, userLocation!.coordinate.longitude)
        }
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        delegate?.onShopDeselected()
    }
    func drawPath(_ path: GMSMutablePath) {
        polyline = GMSPolyline(path: path)
        polyline?.strokeColor = .blue
        polyline?.strokeWidth = 5.0
        polyline?.map = mapView
    }
    func removePath() {
        polyline?.map = nil
    }
}

extension MainViewController: LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    func prepareFABButton() {
        btnUserLocation.backgroundColor = Color.white
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
    
    func setupMaterial() {
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            floatingActionButton.rotationDegrees = 0.0
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        cells.append(cellFactory("icon-rent"))
        cells.append(cellFactory("icon-park"))
        cells.append(cellFactory("icon-gas"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 36, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .left)
        
        let image = UIImage(named: "icon-filter")
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
        let cell = cells[index]
        switch index {
        case 0:
            let bool = !filterSetting["rent"]!
            filterSetting["rent"] = bool
            cell.imageView.image = bool == true ? UIImage(named: "icon-rent") : UIImage(named: "icon-rent-disabled")
        case 1:
            let bool = !filterSetting["park"]!
            filterSetting["park"] = bool
            cell.imageView.image = bool == true ? UIImage(named: "icon-park") : UIImage(named: "icon-park-disabled")
        case 2:
            let bool = !filterSetting["gas"]!
            filterSetting["gas"] = bool
            cell.imageView.image = bool == true ? UIImage(named: "icon-gas") : UIImage(named: "icon-gas-disabled")
        default: break
        }
        updateMarkersVisibility()
    }
}
