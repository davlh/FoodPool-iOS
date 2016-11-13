//
//  OrderCellTableViewCell.swift
//  FoodPool
//
//  Created by David Lee-Heidenreich on 11/12/16.
//  Copyright © 2016 David Lee-Heidenreich. All rights reserved.
//

import UIKit

class OrderCellTableViewCell: UITableViewCell {
    
    @IBOutlet var nameAndPhoneNumberLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var orderLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
