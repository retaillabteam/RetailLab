//
//  PictureProfileTableViewCell.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 21/06/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

class PictureProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIRoundedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
