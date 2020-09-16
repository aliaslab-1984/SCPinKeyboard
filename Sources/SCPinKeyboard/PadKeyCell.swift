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
    
    public var cornerRadius: CGFloat = 12
    
    public enum Corner {
        case upLeft
        case upRight
        case downRight
        case downLeft
        case none
    }
    
    let theme = DefaultTheme()
    
    private var cornerType: Corner = .none
    
    public func roundCorners(corners: Corner) {
        
        self.cornerType = corners
        if self.cornerRadius == 0 {
            layer.mask = nil
            return
        }
        
        let path: UIBezierPath = self.pathForCorner(corner: corners)
        let mask: CAShapeLayer = .init()
        
        mask.path = path.cgPath
        layer.mask = mask
        
        setNeedsDisplay()
    }
    
    private func pathForCorner(corner: Corner) -> UIBezierPath {
        let path: UIBezierPath
        switch corner {
        case .upLeft:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topLeft],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
        case .upRight:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
        case .downRight:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
        case .downLeft:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
        case .none:
            path = UIBezierPath(rect: frame)
        }
        
        return path
    }
    
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
        
        self.contentView.backgroundColor = theme.backgroundColor
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: String) {
        label.text = item
    }
}

#endif
