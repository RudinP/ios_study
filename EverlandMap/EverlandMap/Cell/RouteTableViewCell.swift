//
//  RouteTableViewCell.swift
//  EverlandMap
//
//  Created by 루딘 on 7/3/24.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tollStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerStackView.setCustomSpacing(10, after: distanceLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
