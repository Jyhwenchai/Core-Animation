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
        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView?.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        
        cell.tag = indexPath.item
        
        imageView?.image = nil
        
        let imgBounds = imageView!.bounds
        
        // 切换到后台线程
        DispatchQueue.global().async {
            let index = indexPath.item
            let imagePath = self.imagePaths[index]
            let image = UIImage(named: imagePath)
            
            // 重绘图片
            UIGraphicsBeginImageContextWithOptions(imgBounds.size, true, 0)
            image?.draw(in: imgBounds)
            UIGraphicsGetImageFromCurrentImageContext()
            
            // 回到主线程展示图片
            DispatchQueue.main.async {
                if index == cell.tag {
                    imageView!.image = image
                }
            }
        }
        
        
        
        return cell
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
