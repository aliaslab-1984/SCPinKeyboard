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

public enum BioName: String {
    case Fingerprint
    case FaceID
}

@IBDesignable
public class SCKeyboard: UIView, NibLoadable {

    private weak var delegate: SCKeyboardDelegate?
    
    private var enabled = true
    
    private var withBioButton: BioName?
    
    @IBInspectable
    public var buttonsColor: UIColor = .lightGray {
        didSet {
            applyButtonsBgColor()
        }
    }
    
    @IBInspectable
    public var buttonsTextColor: UIColor = .blue {
        didSet { applyButtonsText() }
    }
    
    @IBInspectable
    public var buttonsFont = UIFont.systemFont(ofSize: 30) {
        didSet {
            applyFont()
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
    
    public static func biometricImage(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle.module, compatibleWith: nil)
    }
    public static func biometricImage(type: BioName) -> UIImage? {
        return biometricImage(named: type.rawValue)
    }
    
    public func setBioButton(type: BioName?) {
        
        withBioButton = type
        let buttons = subviews(ofType: UIButton.self)
        if let bio = buttons.first(where: { $0.tag == -2 }) {
            bioButton(bio)
        }
    }
    
    public var isEnabled: Bool {
        get { enabled }
        set {
            enabled = newValue
            let buttons = subviews(ofType: UIButton.self)
            buttons.forEach { $0.isEnabled = enabled }
        }
    }
}
 
private extension SCKeyboard {
    
    func setupUI() {
        
        setupFromSCNib(border: 6.0)
        roundedBorder()
        applyFont()
        applyButtonsBgColor()
        applyButtonsText()
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach {
            $0.setTitleColor(.gray.withAlphaComponent(0.5), for: .disabled)
        }
    }
    
    func roundedBorder() {
        
        backgroundColor = .clear
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { button in
            button.layer.cornerRadius = 16.0
            if #available(iOS 13.0, *) {
                button.layer.cornerCurve = .continuous
            }
            
            if button.tag == -2 {
                bioButton(button)
            }
            if button.tag == -1 {
                if #available(iOS 15.0, *) {
                    let backImage = UIImage(systemName: "delete.backward")
                    // button.contentHorizontalAlignment = .right
                    button.setImage(backImage, for: .normal)
                }
            }
        }
            
        let stacks = subviews(ofType: UIStackView.self)
        stacks.forEach { $0.spacing = 8 }
    }
    
    func bioButton(_ button: UIButton) {
        
        if let bioType = withBioButton {
            let image = SCKeyboard.biometricImage(type: bioType)
            button.setImage(image, for: .normal)
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        } else {
            button.backgroundColor = .clear
            button.isUserInteractionEnabled = false
            button.alpha = 0.0
        }
    }
    
    func applyFont() {
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { button in
            button.titleLabel?.font = buttonsFont
        }
    }
    
    func applyButtonsBgColor() {
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { $0.backgroundColor = buttonsColor }
    }
    
    func applyButtonsText() {
        
        let buttons = subviews(ofType: UIButton.self)
        buttons.forEach { button in
            button.setTitleColor(buttonsTextColor, for: .normal)
            button.tintColor = buttonsTextColor
        }
    }
}

extension UIView {
    
    func subviews<T: UIView> (ofType levelType: T.Type) -> [T] {
        
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType: levelType))
        }
        return result
    }
}

#endif
