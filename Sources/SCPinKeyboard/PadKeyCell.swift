//
//  PadKeyCell.swift
//  
//
//  Created by Francesco Bianco on 16/09/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit

enum PadItem: Equatable {
    
    case number(number: String)
    case delete
    case custom
    
}

final class PadKey: UICollectionViewCell {
    
    static let reuseid = "CollectionCellKeyReuseID"
    
    private var configuration: SCConfiguration = SCDefaultConfiguration()
    
    private var padItem: PadItem?
    
    private var cornerType: Corner = .none
    
    private var isEnabled: Bool = true
    
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
    
    public func configure(with item: (PadItem, SCConfiguration)) {
        let padItem = item.0
        let configuration = item.1
        self.padItem = padItem
        switch padItem {
        case let .number(number):
            label.text = number
        case .delete:
            if #available(iOS 13, *) {
                let image = UIImage(systemName: "delete.left.fill")
                self.image.image = image
            } else {
                let image = UIImage(named: "icon_blue")
                self.image.image = image?.withRenderingMode(.alwaysTemplate)
            }
            
            self.isEnabled = false
            self.toggle(false)
        case .custom:
            if let text = configuration.additionalButton?.text {
                label.text = text
            } else if let imageName = configuration.additionalButton?.image {
                self.image.image = imageName.withRenderingMode(.alwaysTemplate)
            } else {
                label.text = nil
                self.image.image = nil
            }
        }
        
        self.configuration = configuration
        self.contentView.backgroundColor = self.configuration.theme.backgroundColor
        self.label.textColor = self.configuration.theme.textColor
        self.label.font = self.configuration.font
        if image.image != nil {
            self.image.tintColor = padItem != .custom ? self.configuration.theme.accentColor : self.configuration.theme.secondAccent
            if padItem == .custom {
                self.image.backgroundColor = self.configuration.theme.textColor
                self.image.image = self.image.image?.withRenderingMode(.alwaysTemplate)?.with(insets: .init(top: 10, left: 10, bottom: 10, right: 10))
            } else {
                self.image.backgroundColor = nil
            }
            layoutSubviews()
        } else {
            self.image.backgroundColor = nil
        }
    }
    
    func toggle(_ enabled: Bool) {
        guard isEnabled != enabled else {
            return
        }
        isEnabled = enabled
        
        guard image.image != nil else {
            return
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let sSelf = self else {
                return
            }
            sSelf.image.tintColor = enabled ? sSelf.configuration.theme.accentColor : sSelf.configuration.theme.secondAccent
            if sSelf.padItem == .custom {
                sSelf.image.backgroundColor = enabled ? sSelf.configuration.theme.textColor : .lightText
            } else {
                sSelf.image.backgroundColor = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if padItem == .custom {
            self.image.layer.masksToBounds = true
            self.image.layer.cornerRadius = image.frame.height / 4
        } else {
            self.image.layer.cornerRadius = 0
            self.image.layer.masksToBounds = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        image.image = nil
    }
}

#endif
