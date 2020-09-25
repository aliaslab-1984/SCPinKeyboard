//
//  SCConfiguration.swift
//  
//
//  Created by Francesco Bianco on 25/09/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit

public protocol SCConfiguration {
    var cornerRadius: CGFloat {get set}
    var font: UIFont {get set}
    var theme: SCTheme {get set}
}

public struct SCDefaultConfiguration: SCConfiguration {
    
    public init(cornerRadius: CGFloat = 12.0, font: UIFont = UIFont.boldSystemFont(ofSize: 18), theme: SCTheme = DefaultTheme()) {
        self.cornerRadius = cornerRadius
        self.font = font
        self.theme = theme
    }
    
    
    public var cornerRadius: CGFloat = 12.0
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public var theme: SCTheme = DefaultTheme()
    
}

#endif
