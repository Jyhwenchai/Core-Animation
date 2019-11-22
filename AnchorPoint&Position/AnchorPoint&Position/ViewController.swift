//
//  ViewController.swift
//  AnchorPoint&Position
//
//  Created by 蔡志文 on 2019/11/13.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var yellowView: UIView!
    
    @IBOutlet weak var anchorX: UILabel!
    @IBOutlet weak var anchorY: UILabel!

    @IBOutlet weak var positionX: UILabel!
    @IBOutlet weak var positionY: UILabel!
    
    @IBOutlet weak var anchorXSlider: UISlider!
    @IBOutlet weak var anchorYSlider: UISlider!
    @IBOutlet weak var positionXSlider: UISlider!
    @IBOutlet weak var positionYSlider: UISlider!
    
    @IBOutlet weak var frameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func anchorPointXChanged(_ sender: UISlider) {
        var anchorPoint = yellowView.layer.anchorPoint
        anchorPoint.x = CGFloat(sender.value)
        yellowView.layer.anchorPoint = anchorPoint
        anchorX.text = String(format: "%.2f", sender.value)
        updateFrameAndBounds()
    }
    
    @IBAction func anchorPointYChanged(_ sender: UISlider) {
        var anchorPoint = yellowView.layer.anchorPoint
        anchorPoint.y = CGFloat(sender.value)
        yellowView.layer.anchorPoint = anchorPoint
        anchorY.text = String(format: "%.2f", sender.value)
        updateFrameAndBounds()
    }
    
    @IBAction func positionXChanged(_ sender: UISlider) {
        var position = yellowView.layer.position
        position.x = CGFloat(sender.value)
        yellowView.layer.position = position
        positionX.text = String(format: "%.2f", sender.value)
        updateFrameAndBounds()
    }
    
    @IBAction func positionYChanged(_ sender: UISlider) {
        var position = yellowView.layer.position
        position.y = CGFloat(sender.value)
        yellowView.layer.position = position
        positionY.text = String(format: "%.2f", sender.value)
        updateFrameAndBounds()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        yellowView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        yellowView.layer.position = CGPoint(x: 150, y: 150)
        anchorX.text = "0.5"
        anchorY.text = "0.5"
        positionX.text = String(format: "%.2f", yellowView.layer.position.x)
        positionY.text = String(format: "%.2f", yellowView.layer.position.y)
        anchorXSlider.value = 0.5
        anchorYSlider.value = 0.5
        positionXSlider.value = 150
        positionYSlider.value = 150
        updateFrameAndBounds()
    }
    
    func updateFrameAndBounds() {
        yellowView.setNeedsLayout()
        yellowView.layoutIfNeeded()
        frameLabel.text = String(format: "%.0f，%.0f，%.0f，%.0f", yellowView.frame.origin.x, yellowView.frame.origin.y, 100.0, 100.0)
        print(yellowView.layer.position)
        print(yellowView.layer.bounds)
    }
}
