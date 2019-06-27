//
//  User.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 20/05/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

// MARK: - Result
struct Response: Codable {
    let status: Int
    let list: [UserModel]
}

// MARK: - List
struct UserModel: Codable {
    let firstname, lastname, deviceID, email: String
    let phone, loyaltyStatus, description: String
    let lifetimeValue, activity: Int
    let store: String
}
