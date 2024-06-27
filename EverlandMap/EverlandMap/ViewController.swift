//
//  ViewController.swift
//  EverlandMap
//
//  Created by 루딘 on 6/27/24.
//

import UIKit
import MapKit

extension String: Error {}

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuContainerView: UIView!
    
    var geoJsonObjects = [MKGeoJSONObject]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuContainerView.layer.cornerRadius = 20
        menuContainerView.clipsToBounds = true
        
        let center = CLLocationCoordinate2D(latitude: 37.294259, longitude: 127.2039509)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: false)
        
        Task{
            geoJsonObjects = try await fetchMap()
            
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //사용자의 현재 위치를 표시하는 경우 기본뷰를 표시하도록 nil 리턴
        guard !(annotation is MKUserLocation) else {return nil}
        //어노테이션이 포인트 어노테이션이면 마커 뷰를 표시
        if let everlandAnnotation = annotation as? EverlandAnnotation {
            let marker = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            //마커의 그리프이미지 변경
            marker.glyphImage = everlandAnnotation.image
            //마커 추가 시 바운스애니메이션 추가
            marker.animatesWhenAdded = true
            //pointannotation에는 title, subtitle, 좌표 세 가지가 저장된다.
            //따라서 우리가 설정한 카테고리에 접근하려면 커스텀 어노테이션을 만들고 어노테이션에 프로퍼티를 함께 저장해야 함.
            return marker
        }
        
        return nil
    }
}
