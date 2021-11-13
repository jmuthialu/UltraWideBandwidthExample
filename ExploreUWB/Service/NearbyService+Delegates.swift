//
//  NearbyService+Delegates.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import Foundation
import NearbyInteraction

extension NearbyService: NISessionDelegate {
    
    // Called whenever remote peer has any updates in terms of distance
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        self.nearbyObject = nearbyObjects.first
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        stop()
    }
}
