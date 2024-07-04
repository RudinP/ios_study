//
//  RoutesViewController.swift
//  EverlandMap
//
//  Created by 루딘 on 7/3/24.
//

import UIKit
import MapKit

class RoutesViewController: UIViewController {
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var routesTableView: UITableView!
    
    var routes: Routes?
    var selectedIndex = 0
    
    @IBAction func startNavigation(_ sender: UIButton) {
        print(sender.tag)
        guard let coordinate = routes?.dest?.location?.coordinate else {return}
        
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = routes?.dest?.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        // 지도앱으로 목적지를 전달
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let start = routes?.start?.name, let dest = routes?.dest?.name{
            destinationLabel.text = "\(start) -> \(dest)"
        } else {
            destinationLabel.text = "경로"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routesTableView.reloadData()
    }

}


extension RoutesViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return routes?.routes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedRoute = routes?.routes[section] else {return 0}
        
        if selectedIndex == section{
            return selectedRoute.steps.count + 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteTableViewCell.self), for: indexPath) as! RouteTableViewCell
            
            cell.navigationButton.tag = indexPath.section
            
            if let route = routes?.routes[indexPath.section]{
                cell.timeLabel.text = route.expectedTravelTime.timeString
                cell.distanceLabel.text = route.distance.distanceString
                if #available(iOS 16.0, *) {
                    cell.tollStackView.isHidden = !route.hasTolls
                } else {
                    cell.tollStackView.isHidden = true
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "step", for: indexPath)
            
            if let step = routes?.routes[indexPath.section].steps[indexPath.row - 1] { //이미 경로에서 1번째 인덱스를 표시하므로 세부경로는 테이블뷰 셀 상 2번째 인덱스부터 위치함. 따라서 indexPath.row - 1
                
                if step.distance == 0 && step.instructions.isEmpty {
                    cell.textLabel?.text = "출발"
                    cell.detailTextLabel?.text = routes?.start?.name
                } else {
                    cell.textLabel?.text = step.distance.distanceString
                    cell.detailTextLabel?.text = step.instructions
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var indexSet = IndexSet(integer: selectedIndex)
        selectedIndex = indexPath.section
        indexSet.insert(indexPath.section)
        tableView.reloadSections(indexSet, with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        guard let selectedRoute = routes?.routes[indexPath.section], indexPath.row == 0 else {return} //MKRoute
        
        NotificationCenter.default.post(name: .routeDidSelect, object: nil, userInfo: ["route": selectedRoute])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //nil을 리턴하면 선택되지 않음
        guard indexPath.row == 0 else {return nil}
        return indexPath
    }
}

extension Notification.Name{
    static let routeDidSelect = Notification.Name("routeDidSelect")
}
