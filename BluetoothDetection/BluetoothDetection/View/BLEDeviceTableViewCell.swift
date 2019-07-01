//
//  BLEDeviceTableViewCell.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 01/07/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

class BLEDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var customerIDLabel: UILabel!
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
