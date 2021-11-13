//
//  PeerConnectionManager.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity
import Combine

class PeerConnectionManager: NSObject {

    var peerSession: MCSession?
    var localPeerID: MCPeerID?
    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?
    
    var identityString = ""
    var serviceString = ""
    
    var connectedRemotePeerID: MCPeerID?
    var connectedRemoteDiscoveryToken: NIDiscoveryToken?
    
    @Published var connectionStatus: MCSessionState?
    var remotePeerSentToken = PassthroughSubject<Data, Never>()
    var cancellables = Set<AnyCancellable>()
    
    struct Constants {
        static let identity = "identity"
    }
    
    // Creates mcSession, advertiser and browser
    // serviceString: "exploreUWB",
    // identityString: "com.jay.exploreUWB.service"
    // peerID: \(DeviceName)
    
    init(deviceName: String, serviceString: String, identityString: String) {
        
        self.serviceString = serviceString
        self.identityString = identityString
        localPeerID = MCPeerID(displayName: deviceName)
        
        guard let localPeerID = localPeerID else {
            super.init()
            return
        }
        
        // create multi connect session
        peerSession = MCSession(peer: localPeerID,
                            securityIdentity: nil,
                            encryptionPreference: .required)
        
        // create advertiser
        let discoveryInfo = [Constants.identity: identityString]
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID,
                                               discoveryInfo: discoveryInfo,
                                               serviceType: serviceString)
        
        // create browser
        browser = MCNearbyServiceBrowser(peer: localPeerID,
                                         serviceType: serviceString)
        
        super.init()
        peerSession?.delegate = self
        advertiser?.delegate = self
        browser?.delegate = self
        
    }

    func start() {
        Logger.log(tag: .nearby, message: "Starting peerConnectionManager...\(String(describing: advertiser)) - \(String(describing: browser))")
        advertiser?.startAdvertisingPeer() 
        browser?.startBrowsingForPeers()
    }

    func suspend() {
        Logger.log(tag: .nearby, message: "Suspending peerConnectionManager...")
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
    }

    func invalidate() {
        Logger.log(tag: .nearby, message: "Invalidating peerConnectionManager...")
        suspend()
        peerSession?.disconnect()
    }
    
    func sendData(data: Data?, mode: MCSessionSendDataMode) {
        guard let data = data, let connectedPeers = peerSession?.connectedPeers else { return }
        do {
            Logger.log(tag: .nearby, message: "sending data to remote peers...")
            try peerSession?.send(data, toPeers: connectedPeers, with: mode)
        } catch let error {
            Logger.log(tag: .nearby, message: "Error sending data to peers: \(error)")
        }
    }
    
}

