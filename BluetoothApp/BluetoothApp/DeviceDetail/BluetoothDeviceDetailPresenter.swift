//
//  BluetoothDeviceDetailPresenter.swift
//  BluetoothApp
//
//  Created by Qi Chao on 17/6/21.
//

import Foundation
import UIKit

class BluetoothDeviceDetailPresenter: Presenter, BluetoothDeviceDetailViewControllerProtocol {
        
    var interactor: BluetoothDeviceDetailInteractor?
    var callbackDelegateToVc: BluetoothDeviceDetailViewControllerCallbackProtocol?
    //MARK: For TableView
    var noOfRows = 3
    var connectionStatus = "Connecting"
    var cellIdentifier = { (index: Int) -> String in
        if (index == 0) {return "peripheralNameCell"}
        else if (index == 1) {return "connectionStatusCell"}
        else {return "disconnectButtonCell"}
    }
    
    override init() {
        super.init()
        interactor = BluetoothDeviceDetailInteractor()
        interactor?.callbackDelegateToDetailPresenter = self
    }
    
    func disconnectFromPeripheral() {
        self.interactor?.referenceToListInteractor?.disconnectFromPeripheral()
    }
    
    func getName() -> String {
        return (self.interactor?.getConnectingPeripheralName())!
    }
    
    func getConnectionStatusVc() -> String {
        return self.interactor?.getConnectionStatus() ?? "Connecting"
    }
    
    func getPeripheralConnectability() -> Bool {
        return (self.interactor?.getPeripheralConnectability())!
    }
    
}

extension BluetoothDeviceDetailPresenter: BluetoothDeviceDetailInteractorCallbackProtocol{

    func updateConnectionStatusSignal() {
        //print("receivingConnectionStatus called")
        DispatchQueue.main.async {
            self.callbackDelegateToVc?.reloadTable()
        }
    }
    func reloadTable(){
        callbackDelegateToVc?.reloadTable()
    }
    
    
}

