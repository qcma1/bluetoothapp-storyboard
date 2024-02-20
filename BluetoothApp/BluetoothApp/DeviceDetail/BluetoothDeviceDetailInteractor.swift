//
//  BluetoothDeviceDetailInteractor.swift
//  BluetoothApp
//
//  Created by Qi Chao on 17/6/21.
//

import Foundation
import UIKit

//For device detail presenter to conform as we pass data or request something from it
protocol BluetoothDeviceDetailInteractorCallbackProtocol {
    func updateConnectionStatusSignal()
    func reloadTable()
}

//Establishing detail interactor -> list interactor relationship
protocol DeviceDetailInteractorToDeviceListInteractorProtocol{
    
    var callbackDelegateToDetailInteractor: DeviceDetailInteractorToDeviceListInteractorCallbackProtocol? {get set}
    var connectionStatus: String? {get set}
    var isSelectedPeripheralConnectable:Bool? {get set}
    
    func disconnectFromPeripheral()
    func getConnectingPeripheralName() -> String
}

//Establishing detail interactor <- list interactor relationship
protocol DeviceDetailInteractorToDeviceListInteractorCallbackProtocol{
    
    func updateConnectionStatusDetailSignal()
    func reloadTable()
    
    
}

class BluetoothDeviceDetailInteractor {
    
    var callbackDelegateToDetailPresenter: BluetoothDeviceDetailInteractorCallbackProtocol?
    
    var referenceToListInteractor: DeviceDetailInteractorToDeviceListInteractorProtocol? {didSet {referenceToListInteractor?.callbackDelegateToDetailInteractor = self}}
    
    /*
    init(){
        referenceToListInteractor?.callbackDelegateToDetailInteractor = self
    }
    */
    func getConnectionStatus() -> String {
        return referenceToListInteractor?.connectionStatus ?? "Connecting"
    }
    
    func getConnectingPeripheralName() -> String {
        return (referenceToListInteractor?.getConnectingPeripheralName())!
    }
    
    func getPeripheralConnectability() -> Bool{
        return (referenceToListInteractor?.isSelectedPeripheralConnectable)!
    }
    
}

extension BluetoothDeviceDetailInteractor: DeviceDetailInteractorToDeviceListInteractorCallbackProtocol{
    
    func reloadTable() {
        self.callbackDelegateToDetailPresenter?.reloadTable()
    }
    
    func updateConnectionStatusDetailSignal() {
        //print("receiveConnectionStatus called")
        callbackDelegateToDetailPresenter?.updateConnectionStatusSignal()
    }
    

}
