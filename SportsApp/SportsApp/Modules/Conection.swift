//
//  Conection.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/6/21.
//  Copyright © 2021 Walaa. All rights reserved.
//

import Foundation
import Alamofire
struct Conection {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
}
}
