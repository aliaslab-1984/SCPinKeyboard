//
//  SCKeyboard.swift
//  iOS_SecureCallOTP_Radius
//
//  Created by Enrico on 14/12/2018.
//  Copyright © 2018 Enrico Bonaldo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol SCKeyboardDelegate: class {
    
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioView.isScrollEnabled = false
        collectioView.isScrollEnabled = false
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        collectioView.backgroundColor = .clear
        return collectioView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
}

extension CustomSCKeyboard: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height / 4
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
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
            cella.configure(with: String(indexPath.item + 1))
        } else {
            if indexPath.item == 9 {
                cella.configure(with: "")
            } else if indexPath.item == 10 {
                cella.configure(with: String("0"))
            } else {
                cella.configure(with: "")
            }
        }
        
        if indexPath.item == 0 {
            cella.roundCorners(corners: .upLeft)
        } else if indexPath.item == 2 {
            cella.roundCorners(corners: .upRight)
        } else if indexPath.item == 9 {
            cella.roundCorners(corners: .downLeft)
        } else if indexPath.item == 11 {
            cella.roundCorners(corners: .downRight)
        } else {
            cella.roundCorners(corners: .none)
        }
        
        return cella
    }
    
}

#endif
