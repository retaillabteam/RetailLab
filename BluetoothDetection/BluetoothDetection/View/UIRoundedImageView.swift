//
//  UIRoundedImageView.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 25/06/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

@IBDesignable
class UIRoundedImageView: UIImageView {
    
    @IBInspectable var isRoundedCorners: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isRoundedCorners {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(ovalIn:
                CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height
            )).cgPath
            layer.mask = shapeLayer
        }
        else {
            layer.mask = nil
        }
    }
}
