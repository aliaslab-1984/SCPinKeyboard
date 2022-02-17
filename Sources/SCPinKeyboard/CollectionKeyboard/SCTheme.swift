//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/09/2020.
//

import Foundation
#if canImport(UIKit)

import UIKit

public protocol SCTheme {
    
    var backgroundColor: UIColor { get }
    var accentColor: UIColor { get }
    var textColor: UIColor { get }
    var secondAccent: UIColor { get }
    var cornerConfiguration: CornerConfiguration { get }
    var cornerRadius: CGFloat { get }
    var interItemSpacing: CGSize { get set }
}

public enum CornerConfiguration {
    case allCorners
    case edgeCorners
    case noCorners
}

public enum Corner: CaseIterable {
    case upLeft
    case upRight
    case downRight
    case downLeft
    case allCorners
    case none
}

public struct EdgedCornerTheme: SCTheme {
    
    public var backgroundColor: UIColor
    public var accentColor: UIColor
    public var secondAccent: UIColor
    public var textColor: UIColor
    public var cornerConfiguration: CornerConfiguration
    public var cornerRadius: CGFloat
    public var interItemSpacing: CGSize
    
    public init() {
        
        if #available(iOS 13.0, *) {
            self.backgroundColor = .secondarySystemFill
        } else {
            self.backgroundColor = UIColor.lightGray
        }
        if #available(iOS 13.0, *) {
            self.accentColor = .systemBlue
        } else {
            self.accentColor = .blue
        }
        if #available(iOS 13.0, *) {
            self.secondAccent = .systemBlue
        } else {
            self.secondAccent = .blue
        }
        if #available(iOS 13.0, *) {
            self.textColor = .label
        } else {
            self.textColor = .darkGray
        }
        
        cornerConfiguration = .edgeCorners
        cornerRadius = 12.0
        interItemSpacing = .init(width: 1, height: 1)
    }
}

public struct AllRoundedCornersTheme: SCTheme {
    
    public var backgroundColor: UIColor
    public var accentColor: UIColor
    public var secondAccent: UIColor
    public var textColor: UIColor
    public var cornerConfiguration: CornerConfiguration
    public var cornerRadius: CGFloat
    public var interItemSpacing: CGSize
    
    
    public init() {
        
        if #available(iOS 13.0, *) {
            self.backgroundColor = .secondarySystemFill
        } else {
            self.backgroundColor = UIColor.lightGray
        }
        if #available(iOS 13.0, *) {
            self.accentColor = .systemBlue
        } else {
            self.accentColor = .blue
        }
        if #available(iOS 13.0, *) {
            self.secondAccent = .systemBlue
        } else {
            self.secondAccent = .blue
        }
        if #available(iOS 13.0, *) {
            self.textColor = .label
        } else {
            self.textColor = .darkGray
        }
        
        cornerConfiguration = .allCorners
        cornerRadius = 12.0
        interItemSpacing = .init(width: 1, height: 1)
    }
}

#endif
