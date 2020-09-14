//
//  PinView.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 20/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

protocol PinValidator: class {
    func validate()
}

class PinView: UIView {
    
    private let spaceBetweenPinViews: CGFloat = 8
    
    private var inputViews = [SecretInputView]()
    private var pinBuffer = ""
    
    private weak var delegate: PinValidator?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        drawInputFrames()
    }
    
    private func drawInputFrames() {
        
        let sideWidth = (frame.width - spaceBetweenPinViews * CGFloat(PIN_LENGTH - 1)) / CGFloat(PIN_LENGTH)
        let sideLength = floor(min(sideWidth, frame.height))        // floor avoids border on some devices
        let dy = (frame.height - sideLength) / 2.0
        
        inputViews.removeAll()
        
        for i in 0 ..< PIN_LENGTH {
            let iView = SecretInputView(frame: CGRect(x: (sideLength + spaceBetweenPinViews) * CGFloat(i),
                                                      y: dy, width: sideLength, height: sideLength))
            inputViews.append(iView)
            addSubview(iView)
        }
    }
    
    private func changeStatusOfInputViews(_ marked: Int) {
        
        if marked >= 0 && marked < inputViews.count {
            
            let toChange = inputViews[marked]
            if toChange.isOn() {
                toChange.tickOff()
            } else {
                toChange.tickOn()
            }
        }
    }
    
    func setDelegate(_ delegate: PinValidator?) {
        self.delegate = delegate
    }
    
    func reset() {
        
        pinBuffer = ""
        for pinView in inputViews {
            pinView.tickOff()
        }
    }
    
    func pinCounter() -> Int {
        return pinBuffer.count
    }
    func getPin() -> String {
        return pinBuffer
    }
    
    func errorAnimation() {
        
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
    
    func userDidPressKey(keyValue: Int) {
        
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
            if marked < PIN_LENGTH {
                pinBuffer += String(format: "%ld", Int(keyValue))
                changeStatusOfInputViews(marked)
            }
        }
        
        delegate?.validate()
    }
}
#endif
