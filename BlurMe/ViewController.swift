//
//  ViewController.swift
//  BlurMe
//
//  Created by Justin Doan on 7/2/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let blurSize: CGFloat = 150
    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addBlur(_:)))
        
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func addBlur(_ sender: UITapGestureRecognizer) {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        
        blurView.frame.size.width = blurSize
        blurView.frame.size.height = blurSize
        blurView.layer.cornerRadius = blurSize / 2
        blurView.center = sender.location(in: imageView)
        blurView.clipsToBounds = true
        //blurView.backgroundColor = UIColor.black
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.resizeBlur(_:)))
        blurView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveBlur(_:)))
        blurView.addGestureRecognizer(panGesture)
        
        imageView.addSubview(blurView)
    }
    
    @objc func resizeBlur(_ sender: UIPinchGestureRecognizer) {
        let subView = sender.view
        let subHeight = subView?.frame.height
        
        if sender.state == .began {
            height = subHeight!
        }
        
        subView?.frame.size.height = height * sender.scale
        subView?.frame.size.width = height * sender.scale
        subView?.layer.cornerRadius = (height * sender.scale) / 2
        subView?.center = sender.location(in: imageView)
    }
    
    @objc func moveBlur(_ sender: UIPanGestureRecognizer) {
        let subView = sender.view
        subView?.center = sender.location(in: imageView)
    }


}

