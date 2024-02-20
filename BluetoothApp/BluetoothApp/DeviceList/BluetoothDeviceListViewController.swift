//
//  BluetoothDeviceListViewController.swift
//  BluetoothApp
//
//  Created by Qi Chao on 31/5/21.
//

import UIKit

/*
 The template of all the callback functions that the presenter will use.
 */
protocol BluetoothDeviceListViewControllerCallbackProtocol {
    func reloadTableView()
    func tableEndRefresh()
}

//What does this view controller need from the presenter in order to present the view as I intended?
//Add the properties and functions here so that the presenter will have to conform to this
protocol BluetoothDeviceListViewControllerProtocol {
    
    var callbackDelegateToVc: BluetoothDeviceListViewControllerCallbackProtocol? { get set }
    var interactor: BluetoothDeviceListInteractor? {get set}
    var deviceListCellIdentifier: String { get }
    var namesOfDiscoveredDevices: [String] { get }
    
    func getNoOfRows() -> Int
    func connectToPeripheral(_ index: Int )
    func getListInteractorReference() -> DeviceDetailInteractorToDeviceListInteractorProtocol
    func refresh()
}


class BluetoothDeviceListViewController: UITableViewController {
    
    var presenter: BluetoothDeviceListViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.callbackDelegateToVc = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    @objc func refresh(){
        print("Refreshing")
        self.presenter?.refresh()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNoOfRows() ?? 1
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: presenter?.deviceListCellIdentifier ?? "deviceListTableCell", for: indexPath) as! DeviceListTableCell
        
        let vc = (WireframeProvider.shared.routerOf(genre: .bluetoothDeviceDetailRouter)?.createModule())! as! BluetoothDeviceDetailViewController
        vc.getReferenceToListInteractor(Reference: (self.presenter?.getListInteractorReference())!)
        
        cell.configure(nameOfDevice: presenter?.namesOfDiscoveredDevices[indexPath.row] ?? "placeholder") {
            print("connect button pressed")
            self.presenter?.connectToPeripheral(indexPath.row)
            vc.refreshTable()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        return cell
    }
    
}

extension BluetoothDeviceListViewController: BluetoothDeviceListViewControllerCallbackProtocol {
    
    func tableEndRefresh() {
        self.tableView.refreshControl?.endRefreshing()
    }
    
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
