//
//  ViewController.swift
//  EverlandMap
//
//  Created by 루딘 on 6/27/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuContainerView.layer.cornerRadius = 20
        menuContainerView.clipsToBounds = true
        
        let center = CLLocationCoordinate2D(latitude: 37.294259, longitude: 127.2039509)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: false)
    }


}

