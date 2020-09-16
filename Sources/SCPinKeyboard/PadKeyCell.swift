//
//  PadKeyCell.swift
//  
//
//  Created by Francesco Bianco on 16/09/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit

final class PadKey: UICollectionViewCell {
    
    static let reuseid = "CollectionCellKeyReuseID"
    
    private let label: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .center
        return lab
    }()
    
    private let image: UIImageView = {
        let lab = UIImageView()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 3.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: String) {
        label.text = item
    }
}

#endif
