//
//  LoadingView.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation
import UIKit

class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 36/255, alpha: 0.2)
        
        blurEffectView.frame = self.bounds
        insertSubview(blurEffectView, at: 0)
        
        inidicator.center = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )
        addSubview(inidicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var inidicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .systemRed
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.2
        
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
}
