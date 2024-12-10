//
//  ARModel.swift
//  ARKIT _DEMO
//
//  Created by Likith Undabhatla on 05/10/24.
//

import Foundation

struct TargetModel {
    var id: UUID = UUID()
    var position: SIMD3<Float> // Position of the target in AR space
    var color: String // Color of the target
    var isHit: Bool = false // Track whether the target is hit
}


