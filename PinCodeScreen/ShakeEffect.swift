//
//  ShakeEffect.swift
//  PinCodeScreen
//
//  Created by Denis Kuzmin on 08.02.2022.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 1
    var position: CGFloat
    var animatableData: CGFloat {
        get {
            position
        }
        set {
            position = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        return ProjectionTransform(CGAffineTransform(translationX:
                                                    amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                                    y: 0))
    }
        
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
}
