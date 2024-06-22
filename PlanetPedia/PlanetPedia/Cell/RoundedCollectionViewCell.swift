//
//  RoundedCollectionViewCell.swift
//  PlanetPedia
//
//  Created by 루딘 on 6/22/24.
//

import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.subviews.first?.layer.cornerRadius = 20
        contentView.subviews.first?.clipsToBounds = true
    }
}
