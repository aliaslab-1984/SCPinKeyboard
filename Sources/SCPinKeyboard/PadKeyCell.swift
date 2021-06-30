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
    
    private var configuration: SCConfiguration = SCDefaultConfiguration()
    
    private var cornerType: Corner = .none
    
    public func roundCorners(_ corner: Corner) {
        
        self.cornerType = corner
        guard corner != .none,
              configuration.theme.cornerRadius != 0 else {
            layer.mask = nil
            return
        }
        
        let path: UIBezierPath = self.pathForCorner(corner: corner)
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
                cornerRadii: CGSize(width: configuration.theme.cornerRadius, height: configuration.theme.cornerRadius)
            )
        case .upRight:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topRight],
                cornerRadii: CGSize(width: configuration.theme.cornerRadius, height: configuration.theme.cornerRadius)
            )
        case .downRight:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomRight],
                cornerRadii: CGSize(width: configuration.theme.cornerRadius, height: configuration.theme.cornerRadius)
            )
        case .downLeft:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft],
                cornerRadii: CGSize(width: configuration.theme.cornerRadius, height: configuration.theme.cornerRadius)
            )
        case .allCorners:
            path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight],
                cornerRadii: CGSize(width: configuration.theme.cornerRadius, height: configuration.theme.cornerRadius)
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
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    private let image: UIImageView = {
        let lab = UIImageView()
        lab.contentMode = .scaleAspectFit
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        self.contentView.backgroundColor = configuration.theme.backgroundColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: (String, SCConfiguration)) {
        if item.0 == "del" {
            let image = UIImage(named: "icon_blue")
            self.image.image = image?.withRenderingMode(.alwaysTemplate)
        } else {
            label.text = item.0
        }
        
        self.configuration = item.1
        self.contentView.backgroundColor = self.configuration.theme.backgroundColor
        self.label.textColor = self.configuration.theme.textColor
        self.label.font = self.configuration.font
        self.image.tintColor = self.configuration.theme.textColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        image.image = nil
    }
}

#endif
