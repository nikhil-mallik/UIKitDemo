//
//  MapsButtonViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 24/07/24.
//

import UIKit

class MapsButtonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func appleMapBtnAction(_ sender: Any) {
        let mapVC = AppleMapViewController.sharedInstance()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func googleMapBtnAction(_ sender: Any) {
//        let mapVC = GooglePlaceMapViewController.sharedInstance()
        let mapVC = googleMapViewController.sharedInstance()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    @IBAction func socailAccount(_ sender: Any) {
        let socailVC = SocialAccountViewController.sharedIntance()
        self.navigationController?.pushViewController(socailVC, animated: true)
    }
    
    
    @IBAction func bioMetricBtnAction(_ sender: Any) {
        let biometricVC = PhoneBiometricViewController.sharedInstance()
        self.navigationController?.pushViewController(biometricVC, animated: true)
    }
    
}

// MARK: - Extension for shared instance
extension MapsButtonViewController {
    static func sharedInstance() -> MapsButtonViewController {
        return MapsButtonViewController.instantiateFromStoryboard("MapsButtonViewController")
    }
}
