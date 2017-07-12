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
    
    var tag = 1
    
    enum action {
        case add
        case change
    }
    
    struct viewStat {
        var tag: Int
        var type: action
        var frame: CGRect
    }
    
    var undo = [viewStat]()
    var redo = [viewStat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
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
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.resizeBlur(_:)))
        blurView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveBlur(_:)))
        blurView.addGestureRecognizer(panGesture)
        
        blurView.tag = tag
        tag += 1
        
        imageView.addSubview(blurView)
        
        undo.append(viewStat(tag: blurView.tag, type: .add, frame: blurView.frame))
    }
    
    @objc func resizeBlur(_ sender: UIPinchGestureRecognizer) {
        guard let subView = sender.view else {
            return
        }
        
        let subHeight = subView.frame.height
        
        if sender.state == .began {
            height = subHeight
            undo.append(viewStat(tag: subView.tag, type: .change, frame: subView.frame))
        }
        
        subView.frame.size.height = height * sender.scale
        subView.frame.size.width = height * sender.scale
        subView.layer.cornerRadius = (height * sender.scale) / 2
        subView.center = sender.location(in: imageView)
        
    }
    
    @objc func moveBlur(_ sender: UIPanGestureRecognizer) {
        guard let subView = sender.view else {
            return
        }
        
        if sender.state == .began {
            undo.append(viewStat(tag: subView.tag, type: .change, frame: subView.frame))
        }
        
        subView.center = sender.location(in: imageView)
    }
    
    @IBAction func undoChange(_ sender: Any) {
        guard let change = undo.last else {
            print("Nothing here")
            return
        }
        print("Something here")
        
        guard let subView = imageView.viewWithTag(change.tag) else {
            print("No subview with tag \(tag)")
            return
        }
        
        if change.type == .add {
            subView.removeFromSuperview()
            
            undo.remove(at: undo.count - 1)
            redo.append(change)
        } else {
            undo.remove(at: undo.count - 1)
            redo.append(viewStat(tag: change.tag, type: change.type, frame: subView.frame))
            
            subView.frame = change.frame
        }
    }
    
    @IBAction func redoChange(_ sender: Any) {
        guard let change = redo.last else {
            print("Nothing here")
            return
        }
        print("Something here")
        
        
        if change.type == .add {
            let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurView = UIVisualEffectView(effect: blur)
            
            blurView.frame = change.frame
            blurView.layer.cornerRadius = change.frame.height / 2
            blurView.clipsToBounds = true
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.resizeBlur(_:)))
            blurView.addGestureRecognizer(pinchGesture)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveBlur(_:)))
            blurView.addGestureRecognizer(panGesture)
            
            blurView.tag = change.tag
            
            imageView.addSubview(blurView)
            
            redo.remove(at: redo.count - 1)
            undo.append(viewStat(tag: change.tag, type: change.type, frame: blurView.frame))
        } else {
            guard let subView = imageView.viewWithTag(change.tag) else {
                print("No subview with tag \(tag)")
                return
            }
            
            redo.remove(at: redo.count - 1)
            undo.append(viewStat(tag: change.tag, type: change.type, frame: subView.frame))
            
            subView.frame = change.frame
        }
    }
    


}

