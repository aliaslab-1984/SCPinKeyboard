//
//  NibLoadable.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 14/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// https://stackoverflow.com/a/47295926/718925

public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Error loading \(self) from nib")
        }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        }
    }
}
#endif
