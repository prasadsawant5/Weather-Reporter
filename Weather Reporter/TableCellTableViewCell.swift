//
//  TableCellTableViewCell.swift
//  Weather Reporter
//
//  Created by Prasad Sawant on 1/27/16.
//  Copyright © 2016 Prasad Sawant. All rights reserved.
//

import UIKit

class TableCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelDewPoint: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
