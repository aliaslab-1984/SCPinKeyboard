//
//  SCKeyboard.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 14/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol SCKeyboardDelegate: AnyObject {
    
    func userDidPressKey(keyValue: Int)
}

@IBDesignable
public class SCKeyboard: UIView, NibLoadable {

    private weak var delegate: SCKeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func setDelegate(_ delegate: SCKeyboardDelegate?) {
        self.delegate = delegate
    }

    @IBAction func didPressedButton(_ sender: UIButton) {
        delegate?.userDidPressKey(keyValue: sender.tag)
    }
}

public class CustomSCKeyboard: UIView {
    
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
    
    private func constraintCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        collectionView.register(PadKey.self, forCellWithReuseIdentifier: PadKey.reuseid)
    }
    
    public func setDelegate(_ delegate: SCKeyboardDelegate?) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    public func reloadKeyboardPad() {
        collectionView.reloadData()
    }
}

extension CustomSCKeyboard: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        case 9:
            number = -2
        case 10:
            number = 0
        case 11:
            number = -1
        default:
            number = indexPath.item
        }
        delegate?.userDidPressKey(keyValue: number)
    }
    
    public func setTheme(_ theme: SCTheme) {
        self.configuration.theme = theme
        collectionView.reloadData()
    }
}

extension CustomSCKeyboard: UICollectionViewDataSource {
    
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
