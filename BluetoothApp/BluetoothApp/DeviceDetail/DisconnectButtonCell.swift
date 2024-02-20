//
//  DisconnectButtonCell.swift
//  BluetoothApp
//
//  Created by Qi Chao on 17/6/21.
//

import Foundation
import UIKit

class DisconnectButtonCell: UITableViewCell {
    
    @IBOutlet var disconnectButton: UIButton!
    
    typealias DisconnectButtonAction = () -> Void
    private var disconnectButtonAction: DisconnectButtonAction?
    
    
    @IBAction func disconnectButtonPressed(_ sender: UIButton) {
        disconnectButtonAction?()
        
    }
    func configure(disconnectButtonAction: @escaping DisconnectButtonAction) {
        self.disconnectButtonAction = disconnectButtonAction

    }
}
