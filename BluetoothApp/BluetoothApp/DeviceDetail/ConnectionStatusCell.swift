//
//  ConnectionStatusCell.swift
//  BluetoothApp
//
//  Created by Qi Chao on 17/6/21.
//

import Foundation
import UIKit

class ConnectionStatusCell: UITableViewCell {


    @IBOutlet var connectionStatus: UITextField!
    
    
    func configure(Status status: String) {
        //label.text = "Status"
        connectionStatus.isUserInteractionEnabled = false
        connectionStatus.text = status
    }
}
