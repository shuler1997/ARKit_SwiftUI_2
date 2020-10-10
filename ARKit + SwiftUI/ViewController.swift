//
//  ViewController.swift
//  ARKit + SwiftUI
//
//  Created by Admin on 09/10/2020.
//

import UIKit
import SceneKit
import ARKit
import SwiftUI

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let geometrySize = CGSize(width: 0.8, height: 0.8)
    var ARNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    @IBAction func generateButton(_ sender: Any) {
        initARScene(baseNode: sceneView.scene.rootNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's
        sceneView.session.pause()
        
    }
    
    func initARScene(baseNode: SCNNode) {
        ARNode = createNode(size: geometrySize)
        ARNode.position = SCNVector3(0,0,-0.2)
        baseNode.addChildNode(ARNode)
    }
    
    func createNode(size:CGSize) -> SCNNode {
        let node = SCNNode()
        let plane = SCNPlane(width: size.height, height: size.height)
        let planeNode = SCNNode(geometry: plane)
        createHostingController(for: planeNode)
        node.addChildNode(planeNode)
        return node
    }
    
    func createHostingController(for node: SCNNode) {
        let arVC = UIHostingController(rootView: SwiftUIView())
        DispatchQueue.main.async {
            arVC.willMove(toParent: self)
            self.addChild(arVC)
            arVC.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
            self.view.addSubview(arVC.view)
            self.show(hostingVC: arVC, on: node)
        }
    }
    
    func show(hostingVC: UIHostingController<SwiftUIView>, on node: SCNNode) {
        let material = SCNMaterial()
        hostingVC.view.isOpaque = false
        material.diffuse.contents = hostingVC.view
        material.isDoubleSided = true
        node.geometry?.materials = [material]
    }
    
}

