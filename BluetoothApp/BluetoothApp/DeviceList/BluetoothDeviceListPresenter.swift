//
//  BluetoothDeviceListPresenter.swift
//  BluetoothApp
//
//  Created by Qi Chao on 7/6/21.
//

import Foundation
import UIKit
import CoreBluetooth

class BluetoothDeviceListPresenter: Presenter, BluetoothDeviceListViewControllerProtocol {
    
    var interactor: BluetoothDeviceListInteractor?
    
    var callbackDelegateToVc: BluetoothDeviceListViewControllerCallbackProtocol?
    
    
    var namesOfDiscoveredDevices = [String]()
    var indexOfSelectedCell: Int?
    
    var deviceListCellIdentifier = "deviceListTableCell"
    
    override init() {
        super.init()
        namesOfDiscoveredDevices.append("Discovering")
        self.interactor = BluetoothDeviceListInteractor()
        self.interactor?.callbackDelegateToPresenter = self
    }
    
    func getNoOfRows() -> Int {
        return namesOfDiscoveredDevices.count
    }
    
    func connectToPeripheral(_ index: Int) {
        indexOfSelectedCell = index
        if (interactor?.discoveredPeripheralConnectabilityArray[index].intValue == 1){
            self.interactor?.connectToDevice((interactor?.discoveredPeripherals[index])!)
            self.interactor?.isSelectedPeripheralConnectable = true
        }
        else {
            //Peripheral is not connectable, so need to update status
            self.interactor?.connectionStatus = "Peripheral not connectable"
            self.interactor?.isSelectedPeripheralConnectable = false

        }
        //self.interactor?.callbackDelegateToDetailInteractor?.reloadTable()
        //Detail Interactor has not been instantiated at this point
    }
    
    func getListInteractorReference() -> DeviceDetailInteractorToDeviceListInteractorProtocol {
        return (interactor?.listInteractorAsDeviceDetailInteractorProtocol)!
    }
    
    func refresh() {
        namesOfDiscoveredDevices.removeAll()
        namesOfDiscoveredDevices.append("Discovering")
        self.interactor?.restartOperation()
        callbackDelegateToVc?.reloadTableView()
        callbackDelegateToVc?.tableEndRefresh()
    }
}

extension BluetoothDeviceListPresenter: BluetoothDeviceListInteractorCallbackProtocol {
    
    func sendConnectingPeripheralName() -> String{
        return namesOfDiscoveredDevices[self.indexOfSelectedCell!]
    }
    
    func sendCBPeripheralObjectArray(_ peripheralArray: [CBPeripheral]) {

    }
    
    func sendListOfDeviceLocalNamesArray(_ namesArray: [String]) {
        if (namesArray.isEmpty){
            let text = "No detected BLE devices"
            namesOfDiscoveredDevices[0] = text
            callbackDelegateToVc?.reloadTableView()
        }
        else if(namesArray[0] == "Bluetooth is off"){
            namesOfDiscoveredDevices[0] = namesArray[0]
            callbackDelegateToVc?.reloadTableView()
        }
        else {
            namesOfDiscoveredDevices.remove(at: 0)
            for deviceLocalName in namesArray{
                namesOfDiscoveredDevices.append(deviceLocalName)
            }
            callbackDelegateToVc?.reloadTableView()
        }
    }
}
