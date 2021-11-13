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
    
    @Published var isConnected = false
    @Published var distance: Float?
    var cancellables = Set<AnyCancellable>()
    
    struct Constants {
        static let serviceString = "exploreUWB"
        static let identityString = "com.jay.exploreUWB.service"
    }
    
    private override init() {
        super.init()
    }
    
    func start() {
        Logger.log(tag: .nearby, message: "Starting services...")
        nearbySession = NISession()
        nearbySession?.delegate = self
        
        peerConnectionManager = PeerConnectionManager(deviceName: deviceName,
                                                      serviceString: Constants.serviceString,
                                                      identityString: Constants.identityString)
        peerConnectionManager?.start()
        bindPublishers()
    }
    
    func stop() {
        Logger.log(tag: .nearby, message: "Stopping services...")
        nearbySession?.invalidate()
        peerConnectionManager?.invalidate()
        nearbySession = nil
        isConnected = false
    }
    
    func bindPublishers() {
        
        // Send token after establishing connection
        peerConnectionManager?.$connectionStatus.sink { [weak self] status in
            guard let status = status, status == .connected else { return }
            
            Logger.log(tag: .nearby, message: "Subcriber for connectionStatus...")
            self?.shareTokenToRemotePeers()
        }.store(in: &cancellables)
        
        // Run nearySession after receiving token from remote peer
        peerConnectionManager?.remotePeerSentToken.sink { [weak self] data in
            guard let peerToken = data.decode() else { return }
            
            Logger.log(tag: .nearby, message: "Subcriber for remotePeerSentToken...")
            self?.peerConnectionManager?.connectedRemoteDiscoveryToken = peerToken
            let config = NINearbyPeerConfiguration(peerToken: peerToken)
            self?.nearbySession?.run(config)
            self?.isConnected = true
        }.store(in: &cancellables)
        
        
    }
    
    func shareTokenToRemotePeers() {
        guard let myToken = nearbySession?.discoveryToken else { return }
        
        Logger.log(tag: .nearby, message: "shareTokenToRemotePeers...")
        let encodedToken = myToken.encode()
        peerConnectionManager?.sendData(data: encodedToken, mode: .reliable)
    }
    
}
