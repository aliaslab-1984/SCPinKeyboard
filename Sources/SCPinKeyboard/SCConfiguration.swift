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
    
    public var cornerRadius: CGFloat = 12.0
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public var theme: SCTheme = DefaultTheme()
    
}

#endif
