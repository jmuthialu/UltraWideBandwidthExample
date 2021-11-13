//
//  Data+Extensions.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/13/21.
//

import Foundation
import NearbyInteraction

extension Data {
    
    func decode() -> NIDiscoveryToken? {
        let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: self)
        return token

    }
    
}
