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
    
    public let cornerConfiguration: CornerConfiguration = .edgeCorners
    public let cornerRadius: CGFloat = 12.0
    public var interItemSpacing = CGSize(width: 1, height: 1)
    public let squarePin = false
    public let pinPadding = 2
    
    public init() {
        
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemFill
        } else {
            backgroundColor = UIColor.lightGray
        }
        if #available(iOS 13.0, *) {
            accentColor = .systemBlue
        } else {
            accentColor = .blue
        }
        if #available(iOS 13.0, *) {
            secondAccent = .systemBlue
        } else {
            secondAccent = .blue
        }
        if #available(iOS 13.0, *) {
            textColor = .label
        } else {
            textColor = .darkGray
        }
    }
}

public struct AllRoundedCornersTheme: SCTheme {
    
    public var backgroundColor: UIColor
    public var accentColor: UIColor
    public var secondAccent: UIColor
    public var textColor: UIColor
    
    public let cornerConfiguration: CornerConfiguration = .allCorners
    public let cornerRadius: CGFloat = 12.0
    public var interItemSpacing = CGSize(width: 1, height: 1)
    public let squarePin = false
    public let pinPadding = 2
    
    public init() {
        
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemFill
        } else {
            backgroundColor = UIColor.lightGray
        }
        if #available(iOS 13.0, *) {
            accentColor = .systemBlue
        } else {
            accentColor = .blue
        }
        if #available(iOS 13.0, *) {
            secondAccent = .systemBlue
        } else {
            secondAccent = .blue
        }
        if #available(iOS 13.0, *) {
            textColor = .label
        } else {
            textColor = .darkGray
        }
    }
}

#endif
