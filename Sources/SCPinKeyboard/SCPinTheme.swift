//
//  SCPinTheme.swift
//  
//
//  Created by Enrico on 07/04/22.
//

import UIKit

public protocol SCPinTheme {
    
    var square: Bool { get }
    
    var padding: Int { get }
    
    var emptyColor: UIColor { get }
    var fullColor: UIColor { get }
    var borderColor: UIColor? { get }
    var shadowColor: UIColor? { get }
}

public struct BasicPinTheme: SCPinTheme {
    
    public let square = false
    
    public let padding = 2
    
    public let emptyColor = UIColor.clear
    public let fullColor = UIColor.systemBlue
    public var borderColor: UIColor?
    public var shadowColor: UIColor?
}
