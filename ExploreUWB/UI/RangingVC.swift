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

    @IBOutlet weak var startStopButton: UIBarButtonItem!
    
    var nearbyService = NearbyService.shared
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(isConnected: nearbyService.isConnected)
        bindPublishers()
    }
    
    func bindPublishers() {
        nearbyService.$isConnected.sink { [weak self] isConnected in
            self?.updateUI(isConnected: isConnected)
        }.store(in: &cancellables)
        
    }
    
    func startNearbyService() {
        nearbyService.start()
        updateUI(isConnected: true)
    }
    
    func stopNearbyService() {
        nearbyService.stop()
    }
    
    func updateUI(isConnected: Bool?) {
        guard let isConnected = isConnected else { return }
        if isConnected {
            startStopButton.title = "Stop"
        } else {
            startStopButton.title = "Start"
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

