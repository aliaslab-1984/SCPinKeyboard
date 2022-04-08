//
//  SecretInputDot.swift
//  
//
//  Created by Enrico on 18/02/22.
//

#if canImport(UIKit)
import UIKit

class SecretInputDot: UIView, SecretView {
    
    private var theme: SCPinTheme
    
    private(set) var isOn = false
    
    public init(frame: CGRect,
                theme: SCPinTheme = BasicPinTheme()) {
        self.theme = theme
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        
        if self.isOn {
            theme.fullColor.setFill()
        } else {
            theme.emptyColor.setFill()
        }

        let padding = CGFloat(theme.padding)
        let width = max(rect.width - padding * 2, 4.0)
        let height = max(rect.height - padding * 2, 4.0)
        let padded = CGRect(x: padding, y: padding,
                            width: width, height: height)
        let circlePath = UIBezierPath(ovalIn: padded)
        circlePath.lineWidth = 2

        if let border = theme.borderColor {
            border.setStroke()
            circlePath.stroke()
        }
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
