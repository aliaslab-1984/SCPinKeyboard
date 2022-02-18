//
//  SCKeyboard.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 14/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol SCKeyboardDelegate: AnyObject {
    
    func userDidPressKey(keyValue: Int)
}

@IBDesignable
public class SCKeyboard: UIView, NibLoadable {

    private weak var delegate: SCKeyboardDelegate?
    
    @IBInspectable
    public var buttonsColor: UIColor = .lightGray {
        didSet {
            buttonsBgColor(color: buttonsColor)
        }
    }
    
    @IBInspectable
    public var buttonsTextColor: UIColor = .blue {
        didSet {
            buttonsText(color: buttonsTextColor)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public func setDelegate(_ delegate: SCKeyboardDelegate?) {
        self.delegate = delegate
    }

    @IBAction public func didPressedButton(_ sender: UIButton) {
        delegate?.userDidPressKey(keyValue: sender.tag)
    }
    
    public override func prepareForInterfaceBuilder() {
        setupUI()
    }
    
    private func setupUI() {
        
        setupFromNib(border: 6.0)
        roundedBorder()
        buttonsBgColor(color: buttonsColor)
        buttonsText(color: buttonsTextColor)
    }
    
    private func roundedBorder() {
        
        backgroundColor = .clear
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { button in
            button.layer.cornerRadius = 16.0
            
            if button.tag == -2 {
                button.backgroundColor = .clear
                button.isUserInteractionEnabled = false
                button.alpha = 0
            }
            if button.tag == -1 {
                if #available(iOS 15.0, *) {
                    let backImage = UIImage(systemName: "delete.backward")
                    button.setImage(backImage, for: .normal)
                }
            }
        }
            
        let stacks = subviews(ofType: UIStackView.self)
        stacks.forEach { $0.spacing = 8 }
    }
    
    private func buttonsBgColor(color: UIColor) {
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { $0.backgroundColor = color }
    }
    
    private func buttonsText(color: UIColor) {
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { button in
            button.setTitleColor(color, for: .normal)
            button.tintColor = buttonsTextColor
        }
    }
}

extension UIView {
    
    func subviews<T: UIView> (ofType type: T.Type) -> [T] {
        
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType: type))
        }
        return result
    }
}

#endif
