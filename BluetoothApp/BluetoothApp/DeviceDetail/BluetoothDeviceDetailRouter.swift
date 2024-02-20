//
//  BluetoothDeviceDetailRouter.swift
//  BluetoothApp
//
//  Created by Qi Chao on 17/6/21.
//

import Foundation
import UIKit

class BluetoothDeviceDetailRouter: Wireframe {
    
    override func createModule(withNavigation: Bool = false) -> UIViewController? {
        guard self.mainViewController == nil else {
            return withNavigation ? UINavigationController(rootViewController: self.mainViewController ?? UIViewController()) : self.mainViewController
        }
        
        if let vc = UIStoryboard(name: "Main", bundle: Bundle(for: BluetoothDeviceDetailViewController.self)).instantiateViewController(withIdentifier: "BluetoothDeviceDetailViewController") as? BluetoothDeviceDetailViewController {
            let presenter = BluetoothDeviceDetailPresenter()
            presenter.router = self
            vc.presenter = presenter
            
            self.mainViewController = vc
        }
        
        return withNavigation ? UINavigationController(rootViewController: self.mainViewController ?? UIViewController()) : self.mainViewController
    }
    
}
