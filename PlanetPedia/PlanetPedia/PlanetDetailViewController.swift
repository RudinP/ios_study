//
//  PlanetDetailViewController.swift
//  PlanetPedia
//
//  Created by 루딘 on 6/19/24.
//

import UIKit

class PlanetDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    private let planet: Planet
    
    init?(planet: Planet, coder: NSCoder){
        self.planet = planet
        
        super.init(coder: coder)
    }
    
    //failable initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: planet.englishName.lowercased())
        backgroundImageView.image = img
        
    }

}

extension PlanetDetailViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return planet.satellites.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlanetSummaryCollectionViewCell.self), for: indexPath) as! PlanetSummaryCollectionViewCell
            
            cell.korNameLabel.text = planet.koreanName
            cell.engNameLabel.text = planet.englishName
            cell.descriptionLabel.text = planet.description
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlanetInfoCollectionViewCell.self), for: indexPath) as! PlanetInfoCollectionViewCell
            
            cell.titleLabel.text = "거리"
            cell.valueLabel.text = "1만"
            cell.unitLabel.text = "km"
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SatelliteCollectionViewCell.self), for: indexPath) as! SatelliteCollectionViewCell
            
            let target = planet.satellites[indexPath.item]
            cell.satelliteNameLabel.text = target.koreanName
            cell.satelliteSummaryLabel.text = target.description
            
            return cell
        default:
            fatalError("check section count")
        }
    }
}
