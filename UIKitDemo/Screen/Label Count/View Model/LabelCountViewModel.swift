//
//  LabelCountViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import Foundation

import Foundation

class LabelCountViewModel {
    var counts: LabelCountModel? {
        didSet {
            if counts == nil {
                counts = LabelCountModel(labelCount: 0)
            }
        }
    }
    
    func addCount() {
        counts?.labelCount += 1
        NotificationCenter.default.post(name: .countDidChange, object: nil, userInfo: ["newCount": counts?.labelCount ?? 0])
        print("Count =>> \(counts?.labelCount ?? 0)")
    }
    
    func subtractCount() {
        counts?.labelCount -= 1
        NotificationCenter.default.post(name: .countDidChange, object: nil, userInfo: ["newCount": counts?.labelCount ?? 0])
        print("Count =>> \(counts?.labelCount ?? 0)")
    }
}
extension Notification.Name {
    static let countDidChange = Notification.Name("countDidChange")
}

