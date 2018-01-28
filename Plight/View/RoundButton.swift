//
//  RoundButton.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
