//
//  SCConfiguration.swift
//  
//
//  Created by Francesco Bianco on 25/09/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit

public struct CustomButton {
    let text: String?
    let image: UIImage?
    let name: String
}

public protocol SCConfiguration {
    var font: UIFont {get set}
    var theme: SCTheme {get set}
    var additionalButton: CustomButton? { get set }
}

public struct SCDefaultConfiguration: SCConfiguration {
    
    public init(font: UIFont = UIFont.boldSystemFont(ofSize: 18),
                theme: SCTheme = EdgedCornerTheme()) {
        self.font = font
        self.theme = theme
    }
    
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public var theme: SCTheme = EdgedCornerTheme()
    public var additionalButton: CustomButton?
    
}

#endif
