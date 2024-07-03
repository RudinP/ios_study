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
    
    var routes = [MKRoute]()
    
    @IBAction func closeViewController(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routesTableView.reloadData()
    }

}


extension RoutesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteTableViewCell.self), for: indexPath) as! RouteTableViewCell
        
        let route = routes[indexPath.row]
        cell.timeLabel.text = route.expectedTravelTime.formatted()
        cell.distanceLabel.text = route.distance.formatted()
        if #available(iOS 16.0, *) {
            cell.tollStackView.isHidden = !route.hasTolls
        } else {
            cell.tollStackView.isHidden = true
        }
        
        return cell
    }
    
    
}
