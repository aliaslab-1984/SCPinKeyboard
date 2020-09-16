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
    
}

extension SCTheme {
    
    static func defaultTheme() -> SCTheme {
         return DefaultTheme()
    }
}

public struct DefaultTheme: SCTheme {
    
    public var backgroundColor: UIColor
    public var accentColor: UIColor
    public var textColor: UIColor
    
    public init() {
        self.backgroundColor = UIColor.lightGray
        if #available(iOS 13.0, *) {
            self.accentColor = .systemBlue
        } else {
            self.accentColor = .blue
        }
        if #available(iOS 13.0, *) {
            self.textColor = .label
        } else {
            self.textColor = .darkGray
        }
    }
}

#endif
