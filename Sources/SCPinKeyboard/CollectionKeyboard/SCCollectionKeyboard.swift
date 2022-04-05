//
//  SCKeyboard.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 14/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class SCCollectionKeyboard: UIView {
    
    private weak var delegate: SCKeyboardDelegate?
    
    private var configuration: SCConfiguration
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioView.isScrollEnabled = false
        collectioView.isScrollEnabled = false
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        collectioView.backgroundColor = .clear
        return collectioView
    }()
    
    private var characterCount: Int = 0
    
    public init(configuration: SCConfiguration?) {
        
        if let conf = configuration {
            self.configuration = conf
        } else {
            self.configuration = SCDefaultConfiguration()
        }
        super.init(frame: .zero)
        
        self.addSubview(collectionView)
        
        constraintCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        
        configuration = SCDefaultConfiguration()
        super.init(coder: coder)
        
        self.addSubview(collectionView)
        
        constraintCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func constraintCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        collectionView.register(PadKey.self, forCellWithReuseIdentifier: PadKey.reuseid)
    }
    
    public var onCustomButtonPressed: (() -> Void)? = nil
    
    public func setDelegate(_ delegate: SCKeyboardDelegate?) {
        self.delegate = delegate
    }
    
    public override func layoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    public func updateConfiguration(with configuration: SCConfiguration) {
        self.configuration = configuration
        self.setTheme(configuration.theme)
    }
    
    public func reloadKeyboardPad() {
        collectionView.reloadData()
    }
}

extension SCCollectionKeyboard: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width / 3
        var height = collectionView.frame.height / 4
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing * 2
            height -= layout.minimumLineSpacing * 2
        }
        return .init(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number: Int
        switch indexPath.item {
        case 0..<9:
            number = indexPath.item + 1
            characterCount += 1
        case 9:
            onCustomButtonPressed?()
            number = -2
        case 10:
            number = 0
            characterCount += 1
        case 11:
            number = -1
            characterCount -= 1
        default:
            number = indexPath.item
        }
        
        delegate?.userDidPressKey(keyValue: number)
        
        let cell = collectionView.cellForItem(at: indexPath) as? PadKey
        cell?.animateTouch()
        
        guard collectionView.numberOfItems(inSection: 0) == 12,
            let item = collectionView.cellForItem(at: IndexPath(item: 11, section: 0)) as? PadKey else {
            return
        }
        
        if characterCount <= 0 {
            item.toggle(false)
            characterCount = 0
        } else {
            item.toggle(true)
        }
    }
    
    public func setTheme(_ theme: SCTheme) {
        self.configuration.theme = theme
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = theme.interItemSpacing.height
            layout.minimumLineSpacing = theme.interItemSpacing.width
        }
        collectionView.reloadData()
    }
}

extension SCCollectionKeyboard: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cella = collectionView.dequeueReusableCell(withReuseIdentifier: PadKey.reuseid, for: indexPath) as? PadKey else {
            fatalError()
        }
        
        if indexPath.item < 9 {
            cella.configure(with: (.number(number: String(indexPath.item + 1)), configuration))
        } else {
            if indexPath.item == 9 {
                cella.configure(with: (.custom, configuration))
            } else if indexPath.item == 10 {
                cella.configure(with: (.number(number: String(0)), configuration))
            } else {
                cella.configure(with: (.delete, configuration))
                if characterCount <= 0 {
                    cella.toggle(false)
                    characterCount = 0
                } else {
                    cella.toggle(true)
                }
            }
        }
        
        if configuration.theme.cornerConfiguration == .edgeCorners {
            if indexPath.item == 0 {
                cella.roundCorners(.upLeft)
            } else if indexPath.item == 2 {
                cella.roundCorners(.upRight)
            } else if indexPath.item == 9 {
                cella.roundCorners(.downLeft)
            } else if indexPath.item == 11 {
                cella.roundCorners(.downRight)
            } else {
                cella.roundCorners(.none)
            }
        } else if configuration.theme.cornerConfiguration == .allCorners {
            cella.roundCorners(.allCorners)
        } else {
            cella.roundCorners(.none)
        }
        
        return cella
    }
    
}

#endif
