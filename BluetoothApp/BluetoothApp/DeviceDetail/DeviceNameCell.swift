//
//  DeviceNameCell.swift
//  BluetoothApp
//
//  Created by Qi Chao on 18/6/21.
//

import Foundation
import UIKit

class DeviceNameCell: UITableViewCell{
    
    @IBOutlet var deviceName: UITextField!
    
    func configure(_ name: String){
        deviceName.allowsEditingTextAttributes = false
        deviceName.text = name
    }
}
