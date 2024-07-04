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


extension RoutesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes?.routes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteTableViewCell.self), for: indexPath) as! RouteTableViewCell
        
        if let route = routes?.routes[indexPath.row]{
            cell.timeLabel.text = route.expectedTravelTime.timeString
            cell.distanceLabel.text = route.distance.distanceString
            if #available(iOS 16.0, *) {
                cell.tollStackView.isHidden = !route.hasTolls
            } else {
                cell.tollStackView.isHidden = true
            }
        }
        return cell
    }
    
    
}
