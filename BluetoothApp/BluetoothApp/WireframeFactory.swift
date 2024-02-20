//
//  WireframeFactory.swift
//  BluetoothApp
//
//  Created by Qi Chao on 14/6/21.
//

import Foundation

enum ProductID : String {
    case Default
}
class WireframeFactory {
    static let shared : WireframeFactory = WireframeFactory()
    
    func routerOf(productID: ProductID = .Default, genre: Presenter.Genre) -> Wireframe? {
        switch productID{
        case .Default:
            return WireframeProvider.shared.routerOf(genre: genre)

        }
    }
    fileprivate init() {}
}
