//
//  ViewController.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 14/05/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Device {
    var periphName: String?
    var manufacturedID: String?
    var brandID: String?
    var isTagHeuer: Bool?
}

class ListOfBluetoothDevicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var manager: CBCentralManager!
    
    private var devices = [Device]()
    private let cellReuseIdentifier = "cell"
    private var appIsLaunchFirstTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBluetoothDeviceList))]
//                                                   UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopScanning))]
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        
        self.view.backgroundColor = .white
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        //tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

//    @objc private func stopScanning() {
//        print("stopScannigAction")
//        manager.stopScan()
//    }
    
    @objc private func refreshBluetoothDeviceList() {
        print("refreshingBluetoothDeviceList")
        
        devices.removeAll()
        self.tableView.reloadData()
        centralManagerDidUpdateState(manager)
    }
    
    @objc private func didBecomeActive() {
        print("did become active")
        !appIsLaunchFirstTime ? appIsLaunchFirstTime = true : centralManagerDidUpdateState(manager)
    }

    deinit {
        print("stopScannigAction")
        manager.stopScan()
    }

}

extension ListOfBluetoothDevicesViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        manager.stopScan()
        if central.state == .poweredOn {
            print("bluetooth Powered ON")
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            print("bluetooth Powered OFF")

            let alert = UIAlertController(title: "Attention", message: "Pour détecter un appareil bluetooth, le bluetooth doit être activer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                guard let url = URL(string: "App-Prefs:root=Bluetooth") else { return } //for bluetooth setting
                let app = UIApplication.shared
                app.open(url, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func prompt(_ device: Device) {
        // PROMPT
        print("number of id founded: \(devices.count)")
        print("name: \(device.periphName ?? "")")
        //print("idList: \(device.peripheral.identifier.uuidString)")
        print("manufacturedID: \(device.manufacturedID)")
    }
    
    /*func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var brandID: String?
        var deviceID: String?
        
        if let _ = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString,
            let data = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey) as? Data,
            let manufacturerID = String(data: data, encoding: .utf8) {
            
            var start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 0)
            var end = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
            var range = start..<end
            brandID = String(manufacturerID[range])

            if brandID != "0 " { // "0 " brand ID of TAG HEUER
                return
            }
            
            start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
            end = manufacturerID.index(manufacturerID.endIndex, offsetBy: 0)
            range = start..<end
            deviceID = String(manufacturerID[range])
        }
        
        if devices.filter({ $0.peripheral == peripheral }).count == 0 {
            let newDevice = Device(peripheral: peripheral, manufacturedID: deviceID, brandID: brandID, isTagHeuer: brandID == "0 " ? true : false)
            devices.append(newDevice)
            self.tableView.reloadData()
            self.prompt(newDevice)
        }
    }*/

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        guard let _ = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString else { return }
        guard let data = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey) as? Data else { return }
        guard let manufacturerID = String(data: data, encoding: .utf8) else { return }

        var start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 0)
        var end = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
        var range = start..<end
        let brandID = String(manufacturerID[range])
        
        if brandID != "0 " { // "0 " brand ID of TAG HEUER
            return
        }

        start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
        end = manufacturerID.index(manufacturerID.endIndex, offsetBy: 0)
        range = start..<end
        let deviceID = String(manufacturerID[range])
        
        if devices.filter({ $0.periphName == peripheral.name }).count == 0 {
            let newDevice = Device(periphName: peripheral.name, manufacturedID: deviceID, brandID: brandID, isTagHeuer: brandID == "0 " ? true : false)
            
            
            //-- List of fake users
            let newDevice2 = Device(periphName: "newDevice2", manufacturedID: "TEST A", brandID: "0 ", isTagHeuer: brandID == "0 " ? true : false)
            let newDevice3 = Device(periphName: "newDevice3", manufacturedID: "John Doe", brandID: "0 ", isTagHeuer: brandID == "0 " ? true : false)
            let newDevice4 = Device(periphName: "newDevice4", manufacturedID: "TEST B", brandID: "0 ", isTagHeuer: brandID == "0 " ? true : false)
            let newDevice5 = Device(periphName: "newDevice5", manufacturedID: "TEST Z", brandID: "0 ", isTagHeuer: brandID == "0 " ? true : false)

            devices.append(newDevice)
            devices.append(newDevice2)
            devices.append(newDevice3)
            devices.append(newDevice4)
            devices.append(newDevice5)
            //--
            
            self.tableView.reloadData()
            self.prompt(newDevice)
        }
    }
}

extension ListOfBluetoothDevicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let mainLabelAttributes = NSMutableAttributedString(string: "manufacturer data:   ",
                                                            attributes: MyAttributes.attributesContentLabel())
        mainLabelAttributes.append(NSMutableAttributedString(string: "\(self.devices[indexPath.row].manufacturedID ?? "--")",
                                                             attributes: MyAttributes.attributesContentValue()))

        let detailLabelAttributes = NSMutableAttributedString(string: "device name:              ",
                                                              attributes: MyAttributes.attributesContentLabel())
        detailLabelAttributes.append(NSMutableAttributedString(string: "\(self.devices[indexPath.row].periphName ?? "--")",
                                                               attributes: MyAttributes.attributesContentValue()))

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        
        cell.textLabel?.attributedText = mainLabelAttributes
        cell.detailTextLabel?.attributedText = detailLabelAttributes

        cell.backgroundColor = .clear

        return cell
    }
}

extension ListOfBluetoothDevicesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }

        if let chooseID = devices[indexPath.row].manufacturedID {
            FakeApiCalling().getModel(ofType: Response.self) { result in
                switch result {
                case .success(let model):
                    guard let userModel = model.list.filter( {$0.deviceID == chooseID} ).first else {
                        let alert = UIAlertController(title: "Attention", message: "Profil pas encore présent en base de données.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    vc.data = userModel
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print("getModel KO with error: \(error)")
                }
            }
        }
    }
}
