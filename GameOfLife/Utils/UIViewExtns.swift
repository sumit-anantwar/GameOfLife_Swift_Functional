//
//  UIViewExtns.swift
//  GameOfLife
//
//  Created by Sumit Anantwar on 06/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    override func enable() {
        super.enable()
        self.isEnabled = true
    }
    
    override func disable() {
        super.disable()
        self.isEnabled = true
    }
}

extension UIView {
    func setBorder(rounded:Bool, borderWidth:CGFloat, borderColor:UIColor) {
        
        if rounded {
            let cornerRadius = min(self.frame.size.width, self.frame.size.height) * 0.5
            self.layer.cornerRadius = cornerRadius
        }
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    @objc func enable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1.0
    }
    
    @objc func disable() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
}
