//
//  NIDiscoveryToken+Extensions.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/13/21.
//

import Foundation
import NearbyInteraction

extension NIDiscoveryToken {
    
    func encode() -> Data? {
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: self,
                                                            requiringSecureCoding: true)
        return encodedData

    }
    
}
