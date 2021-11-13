//
//  NearbyService.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity
import Combine

class NearbyService: NSObject {
    
    static var shared = NearbyService()

    var deviceName = UIDevice.current.name
    var nearbySession: NISession?
    var peerConnectionManager: PeerConnectionManager?
    
    var cancellables = Set<AnyCancellable>()
    
    struct Constants {
        static let serviceString = "exploreUWB"
        static let identityString = "com.jay.exploreUWB.service"
    }
    
    private override init() {
        super.init()
        bindPublishers()
    }
    
    func start() {
        nearbySession = NISession()
        nearbySession?.delegate = self
        
        peerConnectionManager = PeerConnectionManager(deviceName: deviceName,
                                                      serviceString: Constants.serviceString,
                                                      identityString: Constants.identityString)
        peerConnectionManager?.start()
    }
    
    func bindPublishers() {
        
        // Send token after establishing connection
        peerConnectionManager?.$connectionStatus.sink { [weak self] status in
            guard let status = status, status == .connected else { return }
            self?.shareTokenToRemotePeers()
        }.store(in: &cancellables)
        
        // Run nearySession after receiving token from remote peer
        peerConnectionManager?.remotePeerSentToken.sink { [weak self] data in
            guard let peerToken = data.decode() else { return }
            self?.peerConnectionManager?.connectedRemoteDiscoveryToken = peerToken
            let config = NINearbyPeerConfiguration(peerToken: peerToken)
            self?.nearbySession?.run(config)
        }.store(in: &cancellables)
        
        
    }
    
    func shareTokenToRemotePeers() {
        guard let myToken = nearbySession?.discoveryToken else { return }
        let encodedToken = myToken.encode()
        peerConnectionManager?.sendData(data: encodedToken, mode: .reliable)
    }
    
}
