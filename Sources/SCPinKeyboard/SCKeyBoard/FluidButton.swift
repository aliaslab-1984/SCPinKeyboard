//
//  FluidButton.swift
//  
//
//  Created by Enrico on 07/04/22.
//

import UIKit

// inspired by https://github.com/nathangitter/fluid-interfaces/blob/master/FluidInterfaces/FluidInterfaces/CalculatorButton.swift

class FluidButton: UIButton {
    
    private var animator = UIViewPropertyAnimator()
    
    private var normalColor = UIColor.clear
    private var highlightedColor = UIColor.gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fluidColors(normal: UIColor, highlighted: UIColor) {
        
        normalColor = normal
        highlightedColor = highlighted
        
        addTarget(self, action: #selector(touchDown),
                  for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp),
                  for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func touchDown() {
        animator.stopAnimation(true)
        backgroundColor = highlightedColor
    }
    
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.backgroundColor = self.normalColor
        })
        animator.startAnimation()
    }
    
}
