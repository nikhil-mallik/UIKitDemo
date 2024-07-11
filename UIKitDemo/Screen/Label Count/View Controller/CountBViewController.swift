//
//  CountBViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import UIKit

class CountBViewController: UIViewController {
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var navigateBtn: UIButton!
    let viewModel = LabelCountViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLbl.alpha = 0
        setButtonTitle()
    }
    
    @IBAction func incrementBtnAction(_ sender: Any) {
        viewModel.addCount()
    }
    @IBAction func decrementBtnAction(_ sender: Any) {
        viewModel.subtractCount()
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        let LabelCVC = CountCViewController.sharedIntance()
        LabelCVC.navigationItem.title = "Label Count C"
        self.navigationController?.pushViewController(LabelCVC, animated: true)
    }
    
    func setButtonTitle() {
        incrementButton.setTitle("", for: .normal)
        decrementButton.setTitle("", for: .normal)
    }
}

// MARK: - Extension for shared instance
extension CountBViewController {
    static func sharedIntance() -> CountBViewController {
        return CountBViewController.instantiateFromStoryboard("CountBViewController")
    }
}
