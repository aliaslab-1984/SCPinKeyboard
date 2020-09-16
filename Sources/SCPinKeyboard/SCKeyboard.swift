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
    
    func setDelegate(_ delegate: SCKeyboardDelegate?) {
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
        // TODO: Fix it
        delegate?.userDidPressKey(keyValue: indexPath.item)
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
        
        return cella
    }
    
}

final class PadKey: UICollectionViewCell {
    
    static let reuseid = "CollectionCellKeyReuseID"
    
    private let label: UILabel = {
        let lab = UILabel()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: String) {
        label.text = item
    }
}
#endif
