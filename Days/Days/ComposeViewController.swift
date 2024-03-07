//
//  ComposeViewController.swift
//  Days
//
//  Created by 루딘 on 3/7/24.
//

import UIKit

class ComposeViewController: UIViewController {

    let colors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemPurple,
        .systemPink,
        .systemTeal,
        .systemIndigo,
        .systemGray,
        .black,
        .white
    ]
    
    @IBOutlet weak var backgroundColorCollectionView: UICollectionView!
    @IBOutlet weak var textColorCollectionView: UICollectionView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBAction func save(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ComposeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColorCollectionViewCell.self), for: indexPath) as! ColorCollectionViewCell
        
        if indexPath.item == colors.count {
            cell.colorImageView.image = UIImage(named: "color-picker")
            cell.colorImageView.tintColor = nil
        } else {
            let target = colors[indexPath.item]
            cell.colorImageView.image = UIImage(named: "color-picker")?.withRenderingMode(.alwaysTemplate)
            cell.colorImageView.tintColor = target
        }
        
        return cell
    }
    
    
}
