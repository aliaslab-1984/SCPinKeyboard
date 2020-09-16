//
//  SecretInputView.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 17/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class SecretInputDot: UIView {
    
    public var theme: SCTheme
    
    private (set) var isOn = false
    
    public init(frame: CGRect, theme: SCTheme = DefaultTheme()) {
        self.theme = theme
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        
        if self.isOn {
            theme.accentColor.setFill()
        } else {
            UIColor.clear.setFill()
        }
        theme.accentColor.setStroke()

        let circlePath = UIBezierPath(ovalIn: CGRect(x: 2, y: 2, width: rect.width - 2*2, height: rect.height - 2*2))
        circlePath.lineWidth = 2

        circlePath.stroke()
        circlePath.fill()
    }
    
    public func toggle(_ to: Bool) {
        self.isOn = to
        self.setNeedsDisplay()
    }
    
}

public class SecretInputView: UIView {
    
    private let tick: UIView

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        let radius: CGFloat = 0.15 * min(frame.size.height, frame.size.width)
        tick = SecretInputView.circleView(with: radius, color: .blue)
        super.init(frame: frame)
        
        backgroundColor = UIColor.red
        tick.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tick)
        
        if let _ = NSLayoutConstraint.Attribute(rawValue: 0) {
            
            NSLayoutConstraint.activate(
                [
                    tick.heightAnchor.constraint(equalToConstant: radius * 2),
                    tick.widthAnchor.constraint(equalToConstant: radius * 2)
                ]
            )
        }
        
        NSLayoutConstraint.activate([
            tick.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tick.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
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
