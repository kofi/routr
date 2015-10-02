//
//  RouteDetailTableViewCell.swift
//  RoutR
//
//  Created by Kofi on 10/1/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit

class RouteDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!

    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var totalTimeTable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
	