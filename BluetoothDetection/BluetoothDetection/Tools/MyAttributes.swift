//
//  MyAttributes.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 25/06/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

class MyAttributes {
    
    static func attributesContentLabel() -> [NSAttributedString.Key : Any] {
        let attributesContentLabel: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.lightGray]
        return attributesContentLabel
    }

    static func attributesContentValue() -> [NSAttributedString.Key : Any] {
        let attributesContentValue: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black]
        return attributesContentValue
    }
}
