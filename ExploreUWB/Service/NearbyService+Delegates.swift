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
        guard let nearbyObject = nearbyObjects.first else { return }

        Logger.log(tag: .nearby, message: "didUpdate nearbyObjects: \(String(describing: nearbyObject.distance))")
        distance = nearbyObject.distance
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        stop()
    }
}
