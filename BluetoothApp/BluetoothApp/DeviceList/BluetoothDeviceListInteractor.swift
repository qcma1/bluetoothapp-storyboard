//
//  BluetoothDeviceListInteractor.swift
//  BluetoothApp
//
//  Created by Qi Chao on 7/6/21.
//

import Foundation
import UIKit
import CoreBluetooth
import Dispatch

protocol BluetoothDeviceListInteractorCallbackProtocol {
    func sendCBPeripheralObjectArray(_ peripheralArray: [CBPeripheral])
    func sendListOfDeviceLocalNamesArray(_ namesArray: [String])
    func sendConnectingPeripheralName() -> String
}

class BluetoothDeviceListInteractor: NSObject, CBCentralManagerDelegate {
    //MARK: Callback to presenter
    var callbackDelegateToPresenter: BluetoothDeviceListInteractorCallbackProtocol?
    
    //MARK:For list interactor -> detail interactor
    var callbackDelegateToDetailInteractor: DeviceDetailInteractorToDeviceListInteractorCallbackProtocol?
    var connectionStatus: String?
    var listInteractorAsDeviceDetailInteractorProtocol: DeviceDetailInteractorToDeviceListInteractorProtocol?
    var isSelectedPeripheralConnectable:Bool?
    
    
    //MARK:Services CBUUID
    let genericAudioService_CBUUID = CBUUID(string: "0x1203")
    let discover_CBUUID = CBUUID(string: "0x180A")
    let phone_alert_status_CBUUID = CBUUID(string: "0x180E")
    let BLE_heart_rate_service_CBUUID = CBUUID(string: "0x180D")
    let volumeControl_CBUUID = CBUUID(string: "0x1844")
    //var CBUUID_array = [genericAudioService_CBUUID, discover_CBUUID, phone_alert_status_CBUUID, volumeControl_CBUUID]
    
    //MARK: Connectability Array
    var discoveredPeripheralConnectabilityArray = [NSNumber]()
    
    //MARK: Bluetooth
    var bluetoothCentralManager: CBCentralManager?
    var detectedDevice: CBPeripheral?
    var connectedDevice: CBPeripheral?
    let centralQueue = DispatchQueue(label: "cq", attributes: .concurrent)
    var stoppedScanning = false
    var discoveredPeripherals = [CBPeripheral]()
    var namesOfDiscoveredPeripherals = [String]()
    let maxNoOfDetectedDevice = 20
    //let scanDuration : Double = 30*1000000000
    var start : DispatchTime?
        
    override init() {
        super.init()
        listInteractorAsDeviceDetailInteractorProtocol = self
        self.bluetoothCentralManager = CBCentralManager(delegate: self, queue: self.centralQueue)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            //start = DispatchTime.now()
            //print(Double((start?.uptimeNanoseconds)!))
            startOperation()
            
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            namesOfDiscoveredPeripherals.append("Bluetooth is off")
            callbackDelegateToPresenter?.sendListOfDeviceLocalNamesArray(namesOfDiscoveredPeripherals)
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")

        }
    }
    func restartOperation(){
        namesOfDiscoveredPeripherals.removeAll()
        discoveredPeripherals.removeAll()
        discoveredPeripheralConnectabilityArray.removeAll()
        self.stoppedScanning = false
        startOperation()
    }
    
    func startOperation(){
        self.bluetoothCentralManager?.scanForPeripherals(withServices: [], options: [:])
        print("scanning started")
        
        let stopScanAfterSomeTime = DispatchWorkItem {
            if (self.stoppedScanning == false){
                self.bluetoothCentralManager?.stopScan()
                print("Has stopped scanning after 30s!")
                self.callbackDelegateToPresenter?.sendListOfDeviceLocalNamesArray(self.namesOfDiscoveredPeripherals)
            }
        }
        let timeDuration = DispatchTime(uptimeNanoseconds: UInt64(DispatchTime.now().uptimeNanoseconds + 30000000000))
        DispatchQueue.main.asyncAfter(deadline: timeDuration, execute: stopScanAfterSomeTime)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //let end = DispatchTime.now()
        //let interval = end.uptimeNanoseconds - (start?.uptimeNanoseconds)!
        print("Detected a peripheral!")
        print("Device's local name is: \(String(describing: advertisementData[CBAdvertisementDataLocalNameKey]))")
        print("Peripheral's services: \(String(describing: advertisementData[CBAdvertisementDataServiceDataKey]))")
        print("Is peripheral connectable: \(String(describing: advertisementData[CBAdvertisementDataIsConnectable]))")
        print(advertisementData[CBAdvertisementDataIsConnectable]!)   //returns 0 if not connectable, and 1 if connectable
        print(type(of: advertisementData[CBAdvertisementDataIsConnectable]!))
        //print(advertisementData)
        print(peripheral.name ?? "Device has no name")
 
        
        if (discoveredPeripherals.count <= maxNoOfDetectedDevice - 1 ) {
            //print(discoveredPeripherals.count)
            discoveredPeripherals.append(peripheral)
            //localNamesOfDiscoveredPeripherals.append(advertisementData["CBAdvertisementDataLocalNameKey"] as? String ?? "Nil")
            //namesOfDiscoveredPeripherals.append(String(describing: advertisementData[CBAdvertisementDataLocalNameKey]))
            namesOfDiscoveredPeripherals.append(peripheral.name ?? "Nil")
            discoveredPeripheralConnectabilityArray.append(advertisementData[CBAdvertisementDataIsConnectable]! as! NSNumber)
        }
        else {
            self.bluetoothCentralManager?.stopScan()
            self.stoppedScanning = true
            print("Central manager has stopped scanning after \(maxNoOfDetectedDevice) devices have been discovered")
            DispatchQueue.main.async {
                //self.callbackDelegateToPresenter?.sendCBPeripheralObjectArray(self.discoveredPeripherals)
                self.callbackDelegateToPresenter?.sendListOfDeviceLocalNamesArray(self.namesOfDiscoveredPeripherals)
            }
        }
            
    }
    
    func stopBluetoothScan() {
        self.bluetoothCentralManager?.stopScan()
    }
    
    func connectToDevice(_ peripheral: CBPeripheral) {
        self.bluetoothCentralManager?.connect(peripheral)
        self.connectedDevice = peripheral
        
    }
    
    func disconnectFromDevice(_ peripheral: CBPeripheral) {
        self.bluetoothCentralManager?.cancelPeripheralConnection(peripheral)
        self.connectedDevice = nil
        
    }
    
    //Invoked only when a connection is successfully created
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if (peripheral == self.connectedDevice){
            self.connectionStatus = "Connected"
            self.updateConnectionStatus()
            
            print("Peripheral connected!")
        }
        
    }
    
    //Invoked when central manager failed to connect to device
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.connectionStatus = "Connection failed, reconnecting now"
        self.updateConnectionStatus()
        print("failed to connect")
        self.connectToDevice(peripheral)
    }
    
    //Invoked only when disconnection from peripheral is successful.
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (self.connectedDevice == nil){
            print("Disconnected from peripheral successfully!")
            self.connectionStatus = "Connecting"
        }
    }
    
    func updateConnectionStatus(){
        //print("updateConnectionStatus called")
        callbackDelegateToDetailInteractor?.updateConnectionStatusDetailSignal()
    }
 
}

extension BluetoothDeviceListInteractor: DeviceDetailInteractorToDeviceListInteractorProtocol{
    
    func getConnectingPeripheralName() -> String {
        return (self.callbackDelegateToPresenter?.sendConnectingPeripheralName())!
    }
    
    
    func disconnectFromPeripheral() {
        disconnectFromDevice(self.connectedDevice!)
    }
    

}

