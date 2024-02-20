//
//  WireframeProvider.swift
//  BluetoothApp
//
//  Created by Qi Chao on 14/6/21.
//

import Foundation

class WireframeProvider {
    static let shared: WireframeProvider = WireframeProvider()
    
    private let bluetoothDeviceListRouter: BluetoothDeviceListRouter
    private let bluetoothDeviceDetailRouter: BluetoothDeviceDetailRouter
    
    init(bluetoothDeviceListRouter: BluetoothDeviceListRouter = BluetoothDeviceListRouter(),
         bluetoothDeviceDetailRouter: BluetoothDeviceDetailRouter = BluetoothDeviceDetailRouter()) {
        self.bluetoothDeviceListRouter = bluetoothDeviceListRouter
        self.bluetoothDeviceDetailRouter = bluetoothDeviceDetailRouter
    }
    
    func routerOf(genre: Presenter.Genre) -> Wireframe? {
        switch genre {
        case .bluetoothDeviceListRouter:
            return self.bluetoothDeviceListRouter
        case .bluetoothDeviceDetailRouter:
            return self.bluetoothDeviceDetailRouter
        }
    }
}
