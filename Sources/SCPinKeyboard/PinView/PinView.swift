//
//  PinView.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 20/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol PinValidator: AnyObject {
    func validate()
}

@IBDesignable
public class PinView: UIView {
    
    private var theme: SCTheme = EdgedCornerTheme()
    
    private let spaceBetweenPinViews: CGFloat = 8
    private let verticalPadding: CGFloat = 8
    
    private var inputViews = [SecretInputDot]()
    private var pinBuffer = ""
    
    private var pinLength = 6
    
    private weak var delegate: PinValidator?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawInputFrames()
    }
    
    // Preview in Interface Builder
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawInputFrames()
    }
    
    public func setTheme(_ scTheme: SCTheme) {
        self.theme = scTheme
        drawInputFrames()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let floatLenght = CGFloat(pinLength)
        let subdivision = frame.width - spaceBetweenPinViews * floatLenght
        let sideWidth = subdivision / floatLenght
        let sideLength = floor(min(sideWidth, frame.height - verticalPadding)) // floor avoids border on some devices
        let filledSpace = (spaceBetweenPinViews / 2) + (sideLength + spaceBetweenPinViews) * floatLenght
        let remaningSpace = frame.width - filledSpace
        let dy = (frame.height - sideLength) / 2.0
        inputViews.enumerated().forEach { i, view in
            let xValue = (remaningSpace / 2) + (spaceBetweenPinViews / 2) + (sideLength + spaceBetweenPinViews) * CGFloat(i)
            view.frame = CGRect(x: xValue,
                                y: dy,
                                width: sideLength,
                                height: sideLength)
        }
    }
    
    public func setPinLength(_ length:Int) {
        pinLength = length
        drawInputFrames()
    }
    
    private func drawInputFrames() {
    
        inputViews.forEach { $0.removeFromSuperview() }
        inputViews.removeAll()
        
        for _ in 0 ..< pinLength {
            let iView = SecretInputDot(frame: .zero, theme: theme)
            inputViews.append(iView)
            addSubview(iView)
        }
    }
    
    private func changeStatusOfInputViews(_ marked: Int) {
        
        if marked >= 0 && marked < inputViews.count {
            let toChange = inputViews[marked]
            toChange.toggle()
        }
    }
    
    public func setDelegate(_ delegate: PinValidator?) {
        self.delegate = delegate
    }
    
    public func reset() {
        pinBuffer = ""
        inputViews.forEach { $0.tickOff() }
    }
    
    public var pinCount: Int { return pinBuffer.count }
    
    public var pin: String { return pinBuffer }
    
    public func errorAnimation() {
        
        let origin = frame.origin
        frame.origin = CGPoint(x: origin.x - 12, y: origin.y)
        UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.075,
                       initialSpringVelocity: 6.0, options: .curveEaseInOut, animations: {
                        self.frame.origin = origin
        }, completion: { _ in
            self.reset()
        })
    }
}

extension PinView: SCKeyboardDelegate {
    
    public func userDidPressKey(keyValue: Int) {
        
        //printDebug("Pressed: \(keyValue)")
        
        let marked = pinBuffer.count
        if keyValue < 0 {
            if keyValue == -1 {
                // backspace button
                if marked > 0 {
                    pinBuffer = String(pinBuffer.dropLast())
                    changeStatusOfInputViews(marked - 1)
                }
            }
            // keyboard can handle another key with value -2. Here is not needed
        } else {
            if marked < pinLength {
                pinBuffer += String(format: "%ld", Int(keyValue))
                changeStatusOfInputViews(marked)
            }
        }
        
        delegate?.validate()
    }
}
#endif
