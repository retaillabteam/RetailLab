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
    var periphUUID: String?
    var manufacturedID: String?
    var brandID: String?
    var isTagHeuer: Bool?
}

class ListOfBluetoothDevicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var manager: CBCentralManager!
    
    private var devices = [Device]()
//    private let cellReuseIdentifier = "cell"
    private var appIsLaunchFirstTime: Bool = false
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
    private let tagHeuerID: String = "0 "

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBluetoothDeviceList)),
                                                   UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopScanning)),
                                                   UIBarButtonItem(customView: activityIndicator)]

        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(UINib.init(nibName: "BLEDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "BLEDeviceTableViewCell")

    }

    @objc private func stopScanning() {
        print("stopScannigAction")
        manager.stopScan()
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
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

    private func buildAlertControllerWithoutAction(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
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
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            //-- List of fake users - FOR DEMO ONLY
//            let newDevice2 = Device(periphName: "newDevice2", manufacturedID: "TEST A", brandID: tagHeuerID, isTagHeuer: true)
//            let newDevice3 = Device(periphName: "newDevice3", manufacturedID: "John Doe", brandID: tagHeuerID, isTagHeuer: true)
//            let newDevice4 = Device(periphName: "newDevice4", manufacturedID: "TEST B", brandID: tagHeuerID, isTagHeuer: true)
//            let newDevice5 = Device(periphName: "newDevice5", manufacturedID: "TEST Z", brandID: tagHeuerID, isTagHeuer: true)
//
//            devices.append(newDevice2)
//            devices.append(newDevice3)
//            devices.append(newDevice4)
//            devices.append(newDevice5)
//
            //--
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
        print("number of id founded: \(devices.count)")
        print("name: \(device.periphName ?? "")")
        print("manufacturedID: \(device.manufacturedID)")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var brandID: String?
        var deviceID: String?
        
        if let _ = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString,
            let data = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey) as? Data,
            let manufacturerID = String(data: data, encoding: .utf8), manufacturerID.count > 2 {
            
            var start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 0)
            var end = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
            var range = start..<end
            brandID = String(manufacturerID[range])

//            if brandID != "0 " { // "0 " brand ID of TAG HEUER
//                return
//            }
            
            start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
            end = manufacturerID.index(manufacturerID.endIndex, offsetBy: 0)
            range = start..<end
            deviceID = String(manufacturerID[range])
        }
        
        if devices.filter({ $0.periphUUID == peripheral.identifier.debugDescription }).count == 0 {
            let newDevice = Device(periphName: peripheral.name, periphUUID: peripheral.identifier.description,
                                   manufacturedID: deviceID, brandID: brandID, isTagHeuer: brandID == "0 " ? true : false)
            devices.append(newDevice)
            self.tableView.reloadData()
            self.prompt(newDevice)
        }
    }

   /* Add device only with data and manufacturerID, so Device component are not optionals
     func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        guard let _ = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString else { return }
        guard let data = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey) as? Data else { return }
        guard let manufacturerID = String(data: data, encoding: .utf8), manufacturerID.count > 2 else { return }

        var start = manufacturerID.startIndex
        var end = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
        var range = start..<end
        let brandID = String(manufacturerID[range])
        
//        if brandID != "0 " { // "0 " brand ID of TAG HEUER
//            return
//        }

        start = manufacturerID.index(manufacturerID.startIndex, offsetBy: 2)
        end = manufacturerID.endIndex
        range = start..<end
        let deviceID = String(manufacturerID[range])
        
        if devices.filter({ $0.periphName == peripheral.name }).count == 0 {
            let newDevice = Device(periphName: peripheral.name, manufacturedID: deviceID, brandID: brandID, isTagHeuer: brandID == "0 " ? true : false)

            devices.append(newDevice)
            self.tableView.reloadData()
            self.prompt(newDevice)
        }
    }*/
}

extension ListOfBluetoothDevicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customerID = NSMutableAttributedString(string: "customer id:     ",
                                                   attributes: MyAttributes.attributesContentLabel())
        customerID.append(NSMutableAttributedString(string: "\(self.devices[indexPath.row].manufacturedID ?? "--")",
                                                    attributes: MyAttributes.attributesContentValue()))

        let deviceIDAttributes = NSMutableAttributedString(string: "device id:          ",
                                                           attributes: MyAttributes.attributesContentLabel())
        deviceIDAttributes.append(NSMutableAttributedString(string: "\(self.devices[indexPath.row].periphName ?? "--")",
                                                            attributes: MyAttributes.attributesContentValue()))

        let bluetoothIDAttributes = NSMutableAttributedString(string: "bluetooth id:    ",
                                                              attributes: MyAttributes.attributesContentLabel())
        bluetoothIDAttributes.append(NSMutableAttributedString(string: "\(self.devices[indexPath.row].periphUUID ?? "--")",
                                                               attributes: MyAttributes.attributesContentValue()))

//        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
//        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
//
//        cell?.textLabel?.attributedText = mainLabelAttributes
//        cell?.detailTextLabel?.attributedText = detailLabelAttributes
//        cell?.accessoryType = self.devices[indexPath.row].brandID == self.tagHeuerID ? .checkmark : .none
        
        
        guard let cell: BLEDeviceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BLEDeviceTableViewCell") as? BLEDeviceTableViewCell
            else { return UITableViewCell() }

        cell.customerIDLabel.attributedText = customerID
        cell.deviceIDLabel.attributedText = deviceIDAttributes
        cell.uuidLabel.attributedText = bluetoothIDAttributes
        cell.accessoryType = self.devices[indexPath.row].brandID == self.tagHeuerID ? .checkmark : .none

        return cell //?? UITableViewCell()
    }
}

extension ListOfBluetoothDevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }

        if let manufacturedID = devices[indexPath.row].manufacturedID {
            FakeApiCalling().getModel(ofType: Response.self) { result in
                switch result {
                case .success(let model):
                    guard let userModel = model.list.filter( {$0.deviceID == manufacturedID} ).first else {
                        let message = self.devices[indexPath.row].brandID == self.tagHeuerID ? "Missing profile" : "Not a TAG HEUER device."
                        self.buildAlertControllerWithoutAction(title: "Attention", message: message)
                        return
                    }
                    vc.data = userModel
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print("getModel KO with error: \(error)")
                    self.buildAlertControllerWithoutAction(title: "Error network", message: error.localizedDescription)
                }
            }
        }
        else {
            self.buildAlertControllerWithoutAction(title: "Attention", message: "Not a TAG HEUER device.")
        }
    }
}
