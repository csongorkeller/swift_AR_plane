//
//  ViewController.swift
//  ARDicee
//
//  Created by Csongor Keller on 19/11/2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    @IBAction func removeObjects(_ sender: UIBarButtonItem) {
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView) //2d location
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent) //results now in 3d with x,y and z component
            
            if let hitResult = results.first {
                
                
                let scene = SCNScene(named: "art.scnassets/plane.scn")!
                
                // Set the scene to the view
                sceneView.scene = scene
                
                sceneView.autoenablesDefaultLighting = true
                
                if let planeNode = scene.rootNode.childNode(withName: "plane", recursively: true) {
                    
                    planeNode.position = SCNVector3(
                        x:hitResult.worldTransform.columns.3.x, //wordTransform is a 4x4 matrix
                        y:hitResult.worldTransform.columns.3.y,
                        z:hitResult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(planeNode)
                    //        }
                }
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if anchor is ARPlaneAnchor {
                
                let planeAnchor = anchor as! ARPlaneAnchor
                
                let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
                
                let planeNode = SCNNode()
                
                planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0 , z: planeAnchor.center.z)
                
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0) //since planenode is vertical, we have to rotate it by 90deg = pi/2 radian
                
                let gridMaterial = SCNMaterial()
                gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
                plane.materials = [gridMaterial]
                planeNode.geometry = plane
                
                node.addChildNode(planeNode)
            } else {
                return
            }
        }
    }
}
