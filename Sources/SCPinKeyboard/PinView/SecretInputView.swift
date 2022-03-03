//
//  SecretInputView.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 17/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

class SecretInputView: UIView, SecretView {
    
    private let tickPercentage: CGFloat = 0.5
    private let cornerRadius: CGFloat = 10.0
    
    private let tick: UIView
    
    private let theme: SCTheme
    
    // TODO: @IBInspectable -> see drawInputFrames
    //static var background: UIColor = .orange
    //static var circleBackground: UIColor = .blue
    //static var shadowColor: UIColor = .blue

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,
         theme: SCTheme = EdgedCornerTheme()) {
        
        tick = SecretInputView.circleView(with: cornerRadius * 0.75,
                                          color: theme.accentColor)
        self.theme = theme
        super.init(frame: frame)
        
        backgroundColor = theme.backgroundColor
        layer.cornerRadius = cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        addShadow(shadowColor: theme.backgroundColor )

        tick.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tick)
        
        NSLayoutConstraint.activate([
            tick.heightAnchor.constraint(equalTo: heightAnchor,
                                         multiplier: tickPercentage),
            tick.widthAnchor.constraint(equalTo: widthAnchor,
                                        multiplier: tickPercentage),
            tick.centerXAnchor.constraint(equalTo: centerXAnchor),
            tick.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        tick.layer.cornerRadius = frame.height / 4.0
//    }
    
    private static func circleView(with radius: CGFloat,
                                   color: UIColor) -> UIView {
        
        let circleView = UIView(frame: .zero)
        circleView.layer.cornerRadius = radius
        if #available(iOS 13.0, *) {
            circleView.layer.cornerCurve = .continuous
        }
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
    
    func toggle() {
        tick.isHidden = !tick.isHidden
    }
    
    var isOn: Bool {
        return !tick.isHidden
    }
    
    private func addShadow(shadowColor: UIColor,
                           shadowOffset: CGSize = CGSize(width: 1.0,
                                                         height: 2.0),
                           shadowOpacity: Float = 0.4,
                           shadowRadius: CGFloat = 2.0) {
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

#endif
