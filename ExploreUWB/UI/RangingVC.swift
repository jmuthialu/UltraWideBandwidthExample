//
//  RangingVC.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import UIKit
import NearbyInteraction
import MultipeerConnectivity
import Combine

class RangingVC: UIViewController {

    @IBOutlet weak var peerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIBarButtonItem!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var directionImageView: UIImageView!
    
    var nearbyService = NearbyService.shared
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStartStopUI(isConnected: nearbyService.isConnected)
        bindPublishers()
    }
    
    func bindPublishers() {
        
        nearbyService.$isConnected.sink { [weak self] isConnected in
            guard let self = self else { return }
            self.updateStartStopUI(isConnected: isConnected)
            self.updatePeerUI()
            isConnected ? nil: self.updateNearbyUI(for: nil)
        }.store(in: &cancellables)
        
        nearbyService.$nearbyObject.sink { [weak self] nearbyObject in
            self?.updateNearbyUI(for: nearbyObject)
        }.store(in: &cancellables)
        
    }
    
    func startNearbyService() {
        nearbyService.start()
        updateStartStopUI(isConnected: true)
    }
    
    func stopNearbyService() {
        nearbyService.stop()
        updatePeerUI()
        updateNearbyUI(for: nil)
    }

    
    func updatePeerUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.peerLabel.text = ""
            let remotePeerID = self.nearbyService.peerConnectionManager?.connectedRemotePeerID
            if let displayName = remotePeerID?.displayName, self.nearbyService.isConnected {
                self.peerLabel.text = displayName
            }
        }
    }
    
    func updateNearbyUI(for nearbyObject: NINearbyObject?) {
        DispatchQueue.main.async { [weak self] in
            // Update distance
            if let distance = nearbyObject?.distance {
                Logger.log(tag: .nearby, message: "nearbyObject distance: \(distance)")
                self?.distanceLabel.text = String(distance)
            } else {
                self?.distanceLabel.text = ""
            }
            
            // update azimuth, elevation
            guard let direction = nearbyObject?.direction else {
                self?.directionImageView.transform = .identity
                return
            }
            let azimuth = asin(direction.x)
            let elevation = atan2(direction.z, direction.y) + .pi / 2
            Logger.log(tag: .nearby, message: "azimuth: \(azimuth) - elevation: \(elevation)")
            self?.directionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(azimuth ))
            
        }
    }
        
    
    func updateStartStopUI(isConnected: Bool?) {
        guard let isConnected = isConnected else { return }
        
        DispatchQueue.main.async { [weak self] in
            if isConnected {
                self?.startStopButton.title = "Stop"
            } else {
                self?.startStopButton.title = "Start"
            }
        }
    }
    
    @IBAction func startStopTapped(_ sender: Any) {
        if startStopButton.title == "Start" {
            startNearbyService()
        } else {
            stopNearbyService()
        }
    }
    
}

