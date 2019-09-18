//
//  ViewController.swift
//  Example14_1
//
//  Created by ilosic on 2019/9/11.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var imagePaths: [String] {
        let paths = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "large photos")
        
        return paths
    }
    
    let imageTag = 99
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        (collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return imagePaths.count
    }

    /// 使用 GCD 在后台进行图片加载
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.tag = indexPath.item
        
        var tileLayer = cell.contentView.layer.sublayers?.last
        if tileLayer == nil {
            tileLayer = CATiledLayer()
            tileLayer?.frame = cell.bounds
            tileLayer?.contentsScale = UIScreen.main.scale
            tileLayer?.delegate = self
            tileLayer?.setValue(indexPath.item, forKey: "index")
            cell.contentView.layer.addSublayer(tileLayer!)
        }
        
        // 获取对应图层并加载
        tileLayer?.contents = nil
        tileLayer?.setValue(indexPath.item, forKey: "index")
        tileLayer?.setNeedsDisplay()
        
        return cell
    }

}

extension ViewController: CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        // get image index
        let index = layer.value(forKey: "index") as! Int
        
        // 加载 tile image
         let imagePath = self.imagePaths[index]
        let image = UIImage(named: imagePath)!
        
        // 计算图片区域
        let aspetRatio = image.size.height / image.size.width
        let size = CGSize(width: layer.bounds.width, height: layer.bounds.width * aspetRatio)
        
        let rect = CGRect(x: 0,
                          y: (layer.bounds.height - size.height) / 2.0,
                          width: size.width, height: size.height)
        // 绘制 tile
        UIGraphicsPushContext(ctx)
        image.draw(in: rect)
        UIGraphicsPopContext()
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 600, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
