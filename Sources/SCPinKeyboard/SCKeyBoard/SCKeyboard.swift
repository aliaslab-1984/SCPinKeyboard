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
    
    private static let backTag = -1
    private static let bioTag = -2

    private weak var delegate: SCKeyboardDelegate?
    
    private var enabled = true
    private var withBioButton: BioName?
    
    var cornerRadius: CGFloat = 16
    
    private var circularWidthConstraints = [Int: NSLayoutConstraint]()
    private var rectangularWidthConstraints = [Int: NSLayoutConstraint]()
    
    /// circular buttons
    public var circular: Bool = false {
        didSet {
            applyWidthConstraint()
            setNeedsLayout()
            //layoutIfNeeded()
        }
    }
    
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
    
    public var buttonsBorder: UIColor = .clear {
        didSet {
            applyButtonsBorder()
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
        if let bio = buttons.first(where: { $0.tag == SCKeyboard.bioTag }) {
            bioButton(bio)
        }
    }
    
    public func setFont(_ font: UIFont) {
        buttons.forEach {
            $0.titleLabel?.font = font
        }
    }
    
    public func fluidColors(highlighted: UIColor) {
        buttons.forEach {
            $0.fluidColors(normal: buttonsColor, highlighted: highlighted)
        }
    }
    
    public var isEnabled: Bool {
        get { enabled }
        set {
            enabled = newValue
            buttons.forEach { $0.isEnabled = enabled }
        }
    }
    
    public var backHidden: Bool {
        get {
            return buttons.first { $0.tag == SCKeyboard.backTag }?.isHidden ?? true
        }
        set {
            buttons.first { $0.tag == SCKeyboard.backTag }?.isHidden = newValue
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateCgColors()
        setNeedsDisplay()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        roundedBorder()
    }
}
 
private extension SCKeyboard {
    
    var buttons: [FluidButton] {
        return subviews(ofType: FluidButton.self)
    }
    
    func setupUI() {
        
        setupFromSCNib(border: 6.0)
        createWidthConstraint()
        applyWidthConstraint()
        roundedBorder()
        applyFont()
        applyButtonsBgColor()
        applyButtonsText()
        
        buttons.forEach {
            $0.setTitleColor(.gray.withAlphaComponent(0.5), for: .disabled)
        }
    }
    
    func createWidthConstraint() {
        
        for (index, button) in buttons.enumerated() {
            let circularConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: button, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
            circularWidthConstraints[index] = circularConstraint
            let rectangularConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: button.superview, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
            rectangularWidthConstraints[index] = rectangularConstraint
            //widthConstraint.isActive = true
        }
    }
    
    func applyWidthConstraint() {
        
        let circularActive = circular
        for (_, constraint) in circularWidthConstraints {
            constraint.isActive = circularActive
        }
        for (_, constraint) in rectangularWidthConstraints {
            constraint.isActive = !circularActive
        }
    }
    
    func roundedBorder() {
        
        backgroundColor = .clear
        
        buttons.forEach { button in
            button.imageView?.contentMode = .scaleAspectFit
            button.layer.cornerRadius = circular ? button.frame.height / 2 : cornerRadius
            if #available(iOS 13.0, *) {
                button.layer.cornerCurve = .continuous
            }
            
            if button.tag == SCKeyboard.bioTag {
                bioButton(button)
            }
            if button.tag == SCKeyboard.backTag {
                if #available(iOS 15.0, *) {
                    let backImage = UIImage(systemName: "delete.backward")
                    // button.contentHorizontalAlignment = .right
                    button.setImage(backImage, for: .normal)
                }
            }
        }
            
        let stacks = subviews(ofType: UIStackView.self)
        stacks.forEach { stack in
            if stack.axis == .vertical { stack.spacing = 16 }
            else { stack.spacing = 8 }
        }
    }
    
    func bioButton(_ button: UIButton) {
        
        if let bioType = withBioButton {
            button.backgroundColor = buttonsColor
            
            let image = SCKeyboard.biometricImage(type: bioType)
            let reduxHeight = button.frame.height * 0.55
            let size = CGSize(width: reduxHeight, height: reduxHeight)
            let img = image?.resized(to: size)
            button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = buttonsTextColor
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        } else {
            button.backgroundColor = .clear
            button.isUserInteractionEnabled = false
            button.alpha = 0.0
        }
    }
    
    func applyFont() {
        buttons.forEach { button in
            button.titleLabel?.font = buttonsFont
        }
    }
    
    func applyButtonsBgColor() {
        buttons.forEach { $0.backgroundColor = buttonsColor }
    }
    
    func applyButtonsBorder() {
        buttons.forEach { button in
            button.layer.borderWidth = buttonsBorder == .clear ? 0 : 1
            button.layer.borderColor = buttonsBorder.cgColor
        }
    }
    
    func updateCgColors() {
        buttons.forEach { button in
            button.layer.borderColor = buttonsBorder.cgColor
        }
    }
    
    func applyButtonsText() {
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

extension UIImage {
    
    @available(iOS 10.0, *)
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
//    func resized(to size: CGSize) -> UIImage? {
//        
//        let options: [CFString: Any] = [
//            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
//            kCGImageSourceCreateThumbnailWithTransform: true,
//            kCGImageSourceShouldCacheImmediately: true,
//            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
//        ]
//        
//        guard let imageData = pngData(),
//              let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
//              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
//        else {
//            return nil
//        }
//        
//        return UIImage(cgImage: image)
//    }
}

#endif
