//
//  SecretInputDot.swift
//  
//
//  Created by Enrico on 18/02/22.
//

#if canImport(UIKit)
import UIKit

class SecretInputDot: UIView, SecretView {
    
    private var theme: SCTheme
    
    private(set) var isOn = false
    
    private let padding: CGFloat = 2
    
    public init(frame: CGRect,
                theme: SCTheme = EdgedCornerTheme()) {
        self.theme = theme
        super.init(frame: .zero)
        self.backgroundColor = .clear
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

        let padded = CGRect(x: padding, y: padding,
                            width: rect.width - padding * 2,
                            height: rect.height - padding * 2)
        let circlePath = UIBezierPath(ovalIn: padded)
        circlePath.lineWidth = 2

        circlePath.stroke()
        circlePath.fill()
    }
    
    func toggle() {
        isOn.toggle()
        self.setNeedsDisplay()
    }
    
    func tickOn() { setOn(true) }
    
    func tickOff() { setOn(false) }
    
    private func setOn(_ status: Bool) {
        isOn = status
        self.setNeedsDisplay()
    }
    
}

#endif
