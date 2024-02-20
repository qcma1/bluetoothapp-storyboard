//
//  BluetoothDeviceDetailViewController.swift
//  BluetoothApp
//
//  Created by Qi Chao on 31/5/21.
//

import UIKit

protocol BluetoothDeviceDetailViewControllerCallbackProtocol{
    func reloadTable()
}

protocol BluetoothDeviceDetailViewControllerProtocol {
    var callbackDelegateToVc: BluetoothDeviceDetailViewControllerCallbackProtocol? {get set}
    var noOfRows: Int {get}
    var connectionStatus: String {get set}
    var interactor: BluetoothDeviceDetailInteractor? {get set}
    
    typealias CellIdentifierForDetailTableView = (_ index: Int) -> String
    
    var cellIdentifier : CellIdentifierForDetailTableView { get }
    
    func getConnectionStatusVc() -> String
    func disconnectFromPeripheral()
    func getName() -> String
    func getPeripheralConnectability() -> Bool

}

class BluetoothDeviceDetailViewController: UITableViewController {
    
    var presenter: BluetoothDeviceDetailViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.callbackDelegateToVc = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.noOfRows)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: (self.presenter?.cellIdentifier(indexPath.row))!, for: indexPath) as! DeviceNameCell
            cell.configure((self.presenter?.getName())!)
            
            return cell
        }
        else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: (self.presenter?.cellIdentifier(indexPath.row))!, for: indexPath) as! ConnectionStatusCell
            //print("Status check")
            cell.configure(Status: self.presenter?.getConnectionStatusVc() ?? "Connecting")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: (self.presenter?.cellIdentifier(indexPath.row))!, for: indexPath) as! DisconnectButtonCell
            /*
            cell.configure(disconnectButtonAction: {
                self.presenter?.disconnectFromPeripheral()
                print((self.presenter?.getPeripheralConnectability())!)
                self.navigationController?.popToRootViewController(animated: true)
            }, isPeripheralConnectable: (self.presenter?.getPeripheralConnectability())!
            )
 */
            cell.configure(disconnectButtonAction: {
                self.presenter?.disconnectFromPeripheral()
                print((self.presenter?.getPeripheralConnectability())!)
                self.navigationController?.popToRootViewController(animated: true)
            })
            if (self.presenter?.getPeripheralConnectability() == false){
                cell.disconnectButton.isEnabled = false
            } else {
                cell.disconnectButton.isEnabled = true
            }
            return cell
        }
    }
    
    func getReferenceToListInteractor(Reference reference: DeviceDetailInteractorToDeviceListInteractorProtocol){
        self.presenter?.interactor?.referenceToListInteractor = reference
    }
    func refreshTable(){
        tableView.reloadData()
    }
}

extension BluetoothDeviceDetailViewController: BluetoothDeviceDetailViewControllerCallbackProtocol  {
    
    func reloadTable() {
        tableView.reloadData()
    }
}
