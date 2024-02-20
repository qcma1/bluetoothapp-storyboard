//
//  DeviceListTableCell.swift
//  BluetoothApp
//
//  Created by Qi Chao on 13/6/21.
//

import Foundation
import UIKit

class DeviceListTableCell: UITableViewCell {
    
    @IBOutlet var connectToBluetoothDeviceButton: UIButton!
    @IBOutlet var nameOfDiscoveredDevice: UITextField!

    typealias ConnectButtonAction = () -> Void
    private var connectButtonAction: ConnectButtonAction?
    
    @IBAction func connectButtonPressed(_ sender: UIButton) {
        connectButtonAction?()
    }
    
    func configure(nameOfDevice name: String, connectButtonAction: @escaping ConnectButtonAction) {
        nameOfDiscoveredDevice.isUserInteractionEnabled = false
        nameOfDiscoveredDevice.text = name
        self.connectButtonAction = connectButtonAction
    }
}
