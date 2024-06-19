//
//  ViewController.swift
//  PlanetPedia
//
//  Created by 루딘 on 5/7/24.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var planetCollectionView: UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = planetCollectionView.indexPath(for: cell){
            let selected = solarSystemPlanets[indexPath.item]
            
            if let vc = segue.destination as? PlanetDetailViewController{
                vc.planet = selected
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solarSystemPlanets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlanetCollectionViewCell
        
        let target = solarSystemPlanets[indexPath.item]
        
        cell.planetImageView.image = UIImage(named: "\(target.englishName.lowercased())-icon")
        cell.planetNameLabel.text = target.englishName
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        //소수점때문에 뷰가 망가지는 경우 방지
        let width = Int((collectionView.bounds.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2)
        
        return CGSize(width: width, height: width)
    }
}

