//
//  RangingVC.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import UIKit
import NearbyInteraction
import MultipeerConnectivity

class RangingVC: UIViewController {

    var nearbyService = NearbyService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startup()
    }
    
    func startup() {
        nearbyService.start()
    }

}

