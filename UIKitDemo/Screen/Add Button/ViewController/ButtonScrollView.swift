//
//  ButtonScrollView.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import UIKit

class ButtonScrollView: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var generateNumberLbl: UILabel!
    @IBOutlet weak var enterNumberTxt: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var test1BtnOutlet: UIButton!
    @IBOutlet weak var test2BtnOutlet: UIButton!
    
    
    
    // MARK: - Variables
    private var viewModel = AddButtonViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action
    @IBAction func submitBtnAction(_ sender: Any) {
        guard let numberText = enterNumberTxt.text, !numberText.isEmpty else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Please enter a number.", from: self)
            return
        }
        guard let number = Int(numberText), number >= 1 else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Invalid input. Please enter a valid number.", from: self)
            return
        }
        viewModel.updateButtonCount(to: number)
        print("Button count updated to: \(number)")
        setupButtons()
    }
    
    // Method to handle button clicks
    @objc func buttonClicked(_ sender: UIButton) {
        
        let buttonIndex = sender.tag
        print("Button Index -> \(buttonIndex)")
        let buttonTitle = sender.title(for: .normal) ?? "Unknown"
        sender.isEnabled = false
        sender.alpha = 0.5 // indicate that the button is disabled
        
        // Check if all buttons are disabled after disabling the current button
        let allButtonsDisabled = scrollViewOutlet.subviews.compactMap({ $0 as? UIButton }).allSatisfy({ !$0.isEnabled })
        
        // If all buttons are disabled after clicking the current button
        if allButtonsDisabled {
            AlertHelper.showAlert(withTitle: "Alert", message: "All buttons are disabled.", from: self)
        } else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Button '\(buttonTitle)' is disabled.", from: self)
        }
    }
}


// Extension for shared instance creation
extension ButtonScrollView {
    static func sharedIntance() -> ButtonScrollView {
        return ButtonScrollView.instantiateFromStoryboard("ButtonScrollView")
    }
    
    // Method to setup buttons in the scroll view
    //    private func setupButtons() {
    //        // Remove existing buttons
    ////        scrollViewOutlet.subviews.forEach { $0.removeFromSuperview() }
    //
    //        // Calculate button size and spacing
    //        let totalWidth = UIScreen.main.bounds.width - 60 // (leading -> 10 + trailing -> 10) and 40 for spacing between buttons (10 * 4)
    //        let buttonWidth = totalWidth / 5
    //        let buttonHeight: CGFloat = 50
    //        let horizontalSpacing: CGFloat = 10
    //        let verticalSpacing: CGFloat = 20
    //
    //        // Find the lowest Y position among existing subviews to start adding new buttons
    //        let maxY = scrollViewOutlet.subviews.map({ $0.frame.maxY }).max() ?? 0
    //        var currentX: CGFloat = horizontalSpacing // Start with horizontal spacing
    //        var currentY: CGFloat = maxY + verticalSpacing // Start below the lowest subview and vertical spacing
    //
    //        for (index, buttonModel) in viewModel.totalButton.enumerated() {
    //            let button = UIButton(type: .system)
    //            button.setTitle("\(buttonModel.count)", for: .normal)
    //            button.backgroundColor = .systemIndigo
    //            button.setTitleColor(.white, for: .normal)
    //            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
    //            button.layer.cornerRadius = buttonHeight / 4
    //            button.tag = index // Set tag to identify the button index
    //            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    //            scrollViewOutlet.addSubview(button)
    //
    //            currentX += buttonWidth + horizontalSpacing // Add button width and horizontal spacing
    //
    //            // Check if the next button will exceed the width of the scroll view
    //            if currentX + buttonWidth > UIScreen.main.bounds.width - horizontalSpacing {
    //                currentX = horizontalSpacing // Reset X position for the next row
    //                currentY += buttonHeight + verticalSpacing // Move to the next row
    //            }
    //        }
    //
    //        // Adjust content size of scroll view based on the last button position
    //        let contentHeight = currentY + buttonHeight + verticalSpacing
    //        scrollViewOutlet.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
    //
    //    }
    
    private func setupButtons() {
        // Remove previously added buttons
        scrollViewOutlet.subviews.forEach { view in
            if view is UIButton {
                view.removeFromSuperview()
            }
        }
     
        let button1Height = test1BtnOutlet.frame.height
        let button2Height = test2BtnOutlet.frame.height
        
        // Calculate total button height
        let totalButtonHeight = max(button1Height, button2Height)  // buttons are aligned horizontally, using the maximum height

        // Calculate button size and spacing
        let totalWidth = UIScreen.main.bounds.width - 60 // (leading -> 10 + trailing -> 10) and 40 for spacing between buttons (10 * 4)
        let buttonWidth = totalWidth / 5
        let buttonHeight: CGFloat = 50
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 20
        let topSpacing: CGFloat = 30
        
        // Find the lowest Y position among existing subviews to start adding new buttons
        let minY = scrollViewOutlet.subviews.map({ $0.frame.minY }).min() ?? 0
        print(" minY -> \(minY)")
        var currentX: CGFloat = horizontalSpacing // Start with horizontal spacing
        var currentY: CGFloat = minY + totalButtonHeight + topSpacing

        for (index, buttonModel) in viewModel.totalButton.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(buttonModel.count)", for: .normal)
            button.backgroundColor = .systemIndigo
            button.setTitleColor(.white, for: .normal)
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = buttonHeight / 4
            button.tag = index // Set tag to identify the button index
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            scrollViewOutlet.addSubview(button)
            
            print("Button \(index) added at (\(currentX), \(currentY))")
            
            currentX += buttonWidth + horizontalSpacing // Add button width and horizontal spacing
            
            // Check if the next button will exceed the width of the scroll view
            if currentX + buttonWidth > UIScreen.main.bounds.width - horizontalSpacing {
                currentX = horizontalSpacing // Reset X position for the next row
                currentY += buttonHeight + verticalSpacing // Move to the next row
            }
        }
        
        // Adjust content size of scroll view based on the last button position
        let contentHeight = currentY + buttonHeight + verticalSpacing
        scrollViewOutlet.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        print("Scroll view content size adjusted to: \(scrollViewOutlet.contentSize)")
    
    }
    
}
