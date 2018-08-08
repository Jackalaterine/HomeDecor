//
//  ViewController.swift
//  HomeDecor
//
//  Created by Caroline Port on 8/8/18.
//  Copyright © 2018 Caroline Port. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
     let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        config.planeDetection = .horizontal
        sceneView.session.run(config)
        
        sceneView.delegate = self
    }

    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))) //1
        
        floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)                                               //2
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wood")                                            //3
        floorNode.geometry?.firstMaterial?.isDoubleSided = true                                                        //4
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)                                                    //5
        return floorNode                                                                                               //6
    }
}

    extension ViewController:ARSCNViewDelegate{
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            let planeNode = createFloorNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            let planeNode = createFloorNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard let _ = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
        }
}

