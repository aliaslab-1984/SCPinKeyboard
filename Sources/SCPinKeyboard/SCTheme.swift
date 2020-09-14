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

struct DefaultTheme: SCTheme {
    
    var backgroundColor: UIColor = .clear
    var accentColor: UIColor = .blue
}

#endif
