//
//  BluetoothDeviceListRouter.swift
//  BluetoothApp
//
//  Created by Qi Chao on 14/6/21.
//

import Foundation
import UIKit

class BluetoothDeviceListRouter: Wireframe {
    
    override func createModule(withNavigation: Bool = false) -> UIViewController? {
        guard self.mainViewController == nil else {
            return withNavigation ? UINavigationController(rootViewController: self.mainViewController ?? UIViewController()) : self.mainViewController
        }
        
        if let vc = UIStoryboard(name: "Main", bundle: Bundle(for: BluetoothDeviceListViewController.self)).instantiateViewController(withIdentifier: "BluetoothDeviceListViewController") as? BluetoothDeviceListViewController {
            let presenter = BluetoothDeviceListPresenter()
            presenter.router = self
            vc.presenter = presenter
            
            self.mainViewController = vc
        }
        
        return withNavigation ? UINavigationController(rootViewController: self.mainViewController ?? UIViewController()) : self.mainViewController
    }
}
