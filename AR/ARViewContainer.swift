import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelName: String

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Set ARSessionDelegate
        arView.session.delegate = context.coordinator
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

//        arView.session.run(config)
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let anchorEntity = AnchorEntity(plane: .any)
        
        guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }
        
        anchorEntity.addChild(modelEntity)
        uiView.scene.addAnchor(anchorEntity)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            autoreleasepool {
                // Prevent frame retention
                let _ = frame.capturedImage
            }
        }
    }
}
