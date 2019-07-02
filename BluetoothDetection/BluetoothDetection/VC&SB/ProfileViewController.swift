//
//  ProfileViewController.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 17/05/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var data: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "PictureProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "PictureProfileTableViewCell")
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 300 : UITableView.automaticDimension
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    enum CellType {
        case profilePic(UIImage, UITableView)
        case personMainInfo(String, String, UITableView)
        
        var cell: UITableViewCell {
            switch self {
            case .profilePic(let image, let tableView):
                guard let cell: PictureProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PictureProfileTableViewCell") as? PictureProfileTableViewCell
                    else { return UITableViewCell() }
                cell.profilePic.image = image
                return cell
                
            case .personMainInfo(let header, let content, let tableView):
                guard let cell: ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell
                    else { return UITableViewCell() }
                cell.headerLabel.text = header
                cell.contentLabel.text = content
                return cell
            }
        }
    }
    
    func getImageBy(id: String) -> String { // FOR DEMO ONLY
        switch id {
        case "Jane Doe":
            return "profile"
        case "TEST A":
            return "profile3"
        case "John Doe":
            return "profile2"
        case "TEST B":
            return "profile4"
        default:
            return "defaultProfile"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return CellType.profilePic(UIImage(named: getImageBy(id: data?.deviceID ?? ""))!, tableView).cell
        case 1:
            return CellType.personMainInfo("Full name", "\(self.data?.firstname ?? "") \(self.data?.lastname ?? "")", tableView).cell
        case 2:
            return CellType.personMainInfo("Mail", "\(self.data?.email ?? "")", tableView).cell
        case 3:
            return CellType.personMainInfo("Phone", "\(self.data?.phone ?? "")", tableView).cell
        case 4:
            return CellType.personMainInfo("Loyalty status", "\(self.data?.loyaltyStatus ?? "")", tableView).cell
        case 5:
            return CellType.personMainInfo("Lifetime Value", "\(self.data?.lifetimeValue ?? 0)€", tableView).cell
        case 6:
            return CellType.personMainInfo("Store", "\(self.data?.store ?? "")", tableView).cell
        case 7:
            let rate: Int = self.data?.activity ?? 0
            var stars: String = rate == 0 ? "New customer" : ""
            if rate >= 1 {
                for _ in 1...rate {
                    stars.append("⭐️")
                }
            }
            return CellType.personMainInfo("Activity indicator", stars, tableView).cell
        case 8:
            return CellType.personMainInfo("Description", "\(self.data?.description ?? "")", tableView).cell
        default:
            return UITableViewCell()
        }
    }
}
