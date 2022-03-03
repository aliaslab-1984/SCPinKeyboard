//
//  SecretView.swift
//  
//
//  Created by Enrico on 18/02/22.
//

import UIKit

protocol SecretView: UIView {
    
    var isOn: Bool { get }
    
    func tickOn()
    func tickOff()
    func toggle()
}
