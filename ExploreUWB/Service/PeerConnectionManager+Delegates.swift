//
//  PeerConnectionManager+Delegates.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import Foundation
import MultipeerConnectivity

extension PeerConnectionManager: MCSessionDelegate {
    
    // session state changes  to `connected` after accepting invitation to `true`
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            Logger.log(tag: .nearby, message: ".connected to remote peer: \(peerID.displayName)")
            connectedRemotePeerID = peerID
            connectionStatus = state
        case .notConnected:
            Logger.log(tag: .nearby, message: ".notConnected")
        case .connecting:
            Logger.log(tag: .nearby, message: ".connecting")
            break
        @unknown default:
            Logger.log(tag: .nearby, message: "unknown state")
        }
    }
    
    /// Called when remote peer sends discovery token as response from local peer sending its token.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if connectedRemotePeerID == peerID {
            Logger.log(tag: .nearby, message: "session.didReceiveData from connectedPeer: \(peerID)")
            remotePeerSentToken.send(data)
        } else {
            Logger.log(tag: .nearby, message: "session.didReceiveData from UNCONNECTED peer. Igonring...")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // No-op
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // No-op
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // No-op
    }
}

extension PeerConnectionManager: MCNearbyServiceAdvertiserDelegate {
 
    /// called after receiving invitation from remote peer.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                             didReceiveInvitationFromPeer peerID: MCPeerID,
                             withContext context: Data?,
                             invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        Logger.log(tag: .nearby, message: "advertiser.didReceiveInvitationFromPeer: \(peerID)")
        
        // Incoming invitation request.  Call the invitationHandler block with YES
        // and a valid session to connect the inviting peer to the session.
        invitationHandler(true, peerSession)
    
    }
    
}

extension PeerConnectionManager: MCNearbyServiceBrowserDelegate {
    
    // Found a nearby advertising peer. Send invite to that peer.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        
        guard let identityValue = info?[Constants.identity],
                let peerSession = peerSession else { return }
        Logger.log(tag: .nearby, message: "browser:foundPeer: identityValue: \(identityValue) - identityString: \(identityString)")

        if identityValue == self.identityString {
            browser.invitePeer(peerID, to: peerSession, withContext: nil, timeout: 10)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // No-op
    }
    
}
