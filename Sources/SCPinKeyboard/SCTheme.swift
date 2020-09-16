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
    
}

extension SCTheme {
    
    static func defaultTheme() -> SCTheme {
         return DefaultTheme()
    }
}

public struct DefaultTheme: SCTheme {
    
    public var backgroundColor: UIColor = .clear
    public var accentColor: UIColor = .blue
    
    public init() {
        self.backgroundColor = UIColor.lightGray
        self.accentColor = .blue
    }
}

#endif
