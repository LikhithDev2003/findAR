import Foundation
import RealityKit
import ARKit
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var arView: ARView?
    @Published var score: Int = 0
    
    private var arConfig: ARWorldTrackingConfiguration
    private var subscriptions = Set<AnyCancellable>()
    private var targets = [TargetModel]()
    
    init() {
        self.arConfig = ARWorldTrackingConfiguration()
        self.arConfig.planeDetection = [.horizontal, .vertical]
        
        setupARView()
        generateTargets() // Generate initial targets
    }

    // Sets up the ARView
    private func setupARView() {
        arView = ARView(frame: .zero)
        arView?.session.run(arConfig)
        
        // Gesture recognizer for tap detection
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView?.addGestureRecognizer(tapGesture)
    }

    // Generate targets asynchronously
    private func generateTargets() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let arView = self.arView else { return }
            
            for _ in 0..<5 {
                let position = SIMD3<Float>(
                    Float.random(in: -1.0...1.0),
                    Float.random(in: 0.0...1.0),
                    Float.random(in: -1.0...1.0)
                )
                let color = UIColor.random()
                
                DispatchQueue.main.async {
                    self.addTargetEntity(at: position, color: color, in: arView)
                }
            }
        }
    }

    // Add a target entity to the AR scene
    private func addTargetEntity(at position: SIMD3<Float>, color: UIColor, in arView: ARView) {
        let boxMesh = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: color, isMetallic: true)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [material])
        
        // Set position and collision component to allow hit detection
        boxEntity.position = position
        boxEntity.generateCollisionShapes(recursive: true) // Add collision shape for interaction
        
        boxEntity.name = UUID().uuidString // Assign unique name
        
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(boxEntity)
        arView.scene.addAnchor(anchorEntity)

        // Update targets list
        let target = TargetModel(position: position, color: color.description)
        targets.append(target)
    }

    // Handle tap gesture to hit targets
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        
        let tapLocation = sender.location(in: arView)
        if let hitEntity = arView.entity(at: tapLocation) as? ModelEntity {
            // Remove entity from parent and update score
            hitEntity.removeFromParent()
            increaseScore()
        }
    }

    // Increase score
    private func increaseScore() {
        DispatchQueue.main.async {
            self.score += 1
        }
    }
}



extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}
