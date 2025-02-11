import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer : UIViewRepresentable {
    @Binding var modelName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
        return arView
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // 1.
        let anchorEntity = AnchorEntity(plane: .any)
        
        // 2.
        guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }
        
        // 3.
        anchorEntity.addChild(modelEntity)
        
        // 4.
        uiView.scene.addAnchor(anchorEntity)
    }
}
