//
//  RouteStopsTableViewCell.swift
//  RoutR
//
//  Created by Kofi on 10/1/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit

class RouteStopsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceToLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
