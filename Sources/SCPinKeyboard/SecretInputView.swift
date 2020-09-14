//
//  SecretInputView.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 17/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class SecretInputView: UIView {
    
    private let tick: UIView

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        let radius: CGFloat = 0.15 * min(frame.size.height, frame.size.width)
        tick = SecretInputView.circleView(with: radius, color: .blue)
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear

        tick.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tick)
        
        if let anAttribute = NSLayoutConstraint.Attribute(rawValue: 0) {
            addConstraint(NSLayoutConstraint(item: tick, attribute: .height,
                                             relatedBy: .equal, toItem: nil,
                                             attribute: anAttribute, multiplier: 1,
                                             constant: 2 * radius))
            addConstraint(NSLayoutConstraint(item: tick, attribute: .width,
                                             relatedBy: .equal, toItem: nil,
                                             attribute: anAttribute, multiplier: 1,
                                             constant: 2 * radius))
        }
        addConstraint(NSLayoutConstraint(item: tick, attribute: .centerY,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tick, attribute: .centerX,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    public override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(2.0)
            context.setStrokeColor(UIColor.purple.cgColor)
            context.move(to: CGPoint(x: 0, y: self.frame.height))
            context.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            context.strokePath()
        }
    }
    
    private static func circleView(with radius: CGFloat, color: UIColor) -> UIView {
        
        let circle = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
        
        let circleView = UIView(frame: circle)
        circleView.layer.cornerRadius = radius
        circleView.backgroundColor = color
        circleView.isHidden = true
        return circleView
    }
    
    func tickOn() {
        tick.isHidden = false
    }
    
    func tickOff() {
        tick.isHidden = true
    }
    
    func isOn() -> Bool {
        return !tick.isHidden
    }
}
#endif
