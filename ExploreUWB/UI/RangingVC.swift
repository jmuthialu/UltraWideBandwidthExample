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
    @IBOutlet weak var distanceLabel: UILabel!
    
    var nearbyService = NearbyService.shared
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStartStopUI(isConnected: nearbyService.isConnected)
        bindPublishers()
    }
    
    func bindPublishers() {
        
        nearbyService.$isConnected.sink { [weak self] isConnected in
            self?.updateStartStopUI(isConnected: isConnected)
        }.store(in: &cancellables)
        
        nearbyService.$distance.sink { [weak self] distance in
            self?.updateDistanceUI(distance: distance)
        }.store(in: &cancellables)
        
    }
    
    func startNearbyService() {
        nearbyService.start()
        updateStartStopUI(isConnected: true)
    }
    
    func stopNearbyService() {
        nearbyService.stop()
    }
    
    func updateDistanceUI(distance: Float?) {
        DispatchQueue.main.async { [weak self] in
            if let distance = distance {
                self?.distanceLabel.text = String(distance)
            } else {
                self?.distanceLabel.text = ""
            }
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

