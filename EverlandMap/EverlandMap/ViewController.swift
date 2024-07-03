//
//  ViewController.swift
//  EverlandMap
//
//  Created by 루딘 on 6/27/24.
//

import UIKit
import MapKit
import CoreLocation

extension String: Error {}

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var facilityButton: UIButton!
    
    var geoJsonObjects = [MKGeoJSONObject]()
    
    lazy var locationManager: CLLocationManager = { [weak self] in
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    func fetchMap() async throws -> [MKGeoJSONObject] {
        guard let url = URL(string: "https:kxapi.azurewebsites.net/geojson?apiKey=Vlma2ThXYk968FCuLLEy") else {
            throw "invalid url"
        }
        
        //dataTask 요청. response 사용하지 않으므로 생략(_)
        let (data, _) = try await URLSession.shared.data(from: url)
        //GeoJSONDecoder. 사용법 동일.
        let decoder = MKGeoJSONDecoder()
        let results = try decoder.decode(data)
        
        return results
    }
    
    @IBAction func showAttractions(_ sender: Any) {
        show(category: .attraction)
    }
    
    @IBAction func showPerformance(_ sender: Any) {
        show(category: .performance)
    }
    
    @IBAction func showAmenities(_ sender: Any) {
        show(category: .amenity)
    }
    
    @IBAction func showGiftshops(_ sender: Any) {
        show(category: .giftshop)
    }
    
    @IBAction func showRestaurants(_ sender: Any) {
        show(category: .restaurant)
    }
    @IBAction func showRoute(_ sender: Any) {
        let start = mapView.userLocation.coordinate
        let dest = CLLocationCoordinate2D(latitude: 37.294259, longitude: 127.2030509) //선택한 어노테이션
        
        //지점의 placemark 생성
        let startPlacemark = MKPlacemark(coordinate: start)
        let destPlacemark = MKPlacemark(coordinate: dest)
        
        //mapItem 생성
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let destMapItem = MKMapItem(placemark: destPlacemark)
        
        //경로는 애플 서버로 요청을 보내서 생성한다.
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = destMapItem
        //경로를 이동하는 수단 설정
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in //응답 객체, 에러
            guard let response else {
                if let error {
                    print(error)
                }
                return
            }
            
            let route = response.routes[0] //routes는 배열로, 여러 경로가 나올 수 있기 때문.
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let region = MKCoordinateRegion(route.polyline.boundingMapRect)
            self.mapView.setRegion(region, animated: true)
            
            self.performSegue(withIdentifier: "routeSegue", sender: response.routes)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RoutesViewController{
            vc.routes = sender as? [MKRoute] ?? []
        }
    }
    
    
    func show(category: Category){
        //어노테이션 삭제 방법
        mapView.removeAnnotations(mapView.annotations)
        
        for obj in geoJsonObjects {
            guard let feature = obj as? MKGeoJSONFeature else {continue}
            let jsonDecoder = JSONDecoder()
            
            guard let pdata = feature.properties,
                  let properties = try? jsonDecoder.decode(Property.self, from: pdata) else {continue}
            
            guard let objCategory = Category(rawValue: properties.category) else {continue}
            //포인트면 위치 마킹
            if let pointAnnotation = feature.geometry.first as? MKPointAnnotation {
                if category == objCategory {
                    //이부분 변경
                    let annotation = EverlandAnnotation(coordinate: pointAnnotation.coordinate, properties: properties)
                    //지도에 마킹
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    @IBAction func addOverlay(_ sender: Any){
        mapView.removeOverlays(mapView.overlays)
        
        for obj in geoJsonObjects {
            guard let feature = obj as? MKGeoJSONFeature else {continue}
            let jsonDecoder = JSONDecoder()
            
            guard let pdata = feature.properties,
                  let properties = try? jsonDecoder.decode(Property.self, from: pdata) else {continue}
            
            if let section = feature.geometry.first as? MKPolygon {
                section.title = properties.name
                mapView.addOverlay(section)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = locationManager //lazy여서
        
        menuContainerView.layer.cornerRadius = 20
        menuContainerView.clipsToBounds = true
        
        let center = CLLocationCoordinate2D(latitude: 37.294259, longitude: 127.2039509)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: false)
        
        Task{
            geoJsonObjects = try await fetchMap()
            
        }
        
        let list = [Category.aed, .restroom, .firstaid, .locker, .atm, .ticketing, .babyfeeding, .missingchild, .charge, .publicphone, .smoking]
        
        var actions = [UIAction]()
        for category in list{
            let action = UIAction(title: category.rawValue.capitalized, image: UIImage(named: category.rawValue)) { _ in
                self.show(category: category)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(children: actions)
        facilityButton.menu = menu
        facilityButton.showsMenuAsPrimaryAction = true
        
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay{
        case is MKPolyline:
            let r = MKPolylineRenderer(overlay: overlay)
            r.strokeColor = .systemRed //색
            r.lineWidth = 10 //라인 두께
            return r
        case is MKCircle:
            let r = MKCircleRenderer(overlay: overlay)
            r.strokeColor = .blue
            r.lineWidth = 10
            return r
        case is MKPolygon:
            let r = MKPolygonRenderer(overlay: overlay)
            switch overlay.title {
            case "유러피안 어드벤처":
                r.fillColor = .systemGreen
            case "매직랜드":
                r.fillColor = .systemRed
            case "아메리칸 어드벤처":
                r.fillColor = .systemBlue
            case "글로벌페어":
                r.fillColor = .systemPurple
            case "주토피아":
                r.fillColor = .systemOrange
            default:
                r.fillColor = .systemYellow
            }
            
            r.alpha = 0.2
            return r
        default:
            return MKOverlayRenderer()
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //사용자의 현재 위치를 표시하는 경우 기본뷰를 표시하도록 nil 리턴
        guard !(annotation is MKUserLocation) else {return nil}
        //어노테이션이 포인트 어노테이션이면 마커 뷰를 표시
        //pointannotation에는 title, subtitle, 좌표 세 가지가 저장된다.
        //따라서 우리가 설정한 카테고리에 접근하려면 커스텀 어노테이션을 만들고 어노테이션에 프로퍼티를 함께 저장해야 함.
        if let everlandAnnotation = annotation as? EverlandAnnotation {
            let marker = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            //마커의 그리프이미지 변경
            marker.glyphImage = everlandAnnotation.image
            marker.markerTintColor = nil
            marker.glyphTintColor = nil
            //마커 추가 시 바운스애니메이션 추가
            marker.animatesWhenAdded = true
            if everlandAnnotation.category == .restroom{
                marker.markerTintColor = .black
                if everlandAnnotation.properties.accessibleToDisabled ?? false{
                    marker.glyphTintColor = .systemGreen
                } else {
                    marker.glyphTintColor = .white
                }
            }
            return marker
        }
        
        return nil
    }
}

