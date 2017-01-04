//
//  PageContentVCViewController.swift
//  Teammate
//
//  Created by Larry on 1/3/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//


import UIKit

class PageContentVCViewController: UIViewController {
   
    let color = ColorSheet()
    
    
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    var pageIndex = 0
    var contentLbl = ""
    var headerLbl = ""
    var imageName = ""
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pageControl.currentPage = pageIndex
        pageControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        contentLabel.text = contentLbl
        contentLabel.textColor = color.prettyLightGreyColor
        
        headerLabel.text = headerLbl
        headerLabel.textColor = color.deepGreyColor

        image.image = UIImage(named:imageName)
 
       
        
        
        
        //custom button
        
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = color.pinkColor.cgColor
        startButton.setTitleColor(UIColor.white, for: UIControlState())
        startButton.layer.masksToBounds = true
        
        BGIMAGEandBlur ()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPressed(_ sender: AnyObject) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "displayedWalk")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func BGIMAGEandBlur () {
        
        BGImage.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        BGImage.image = UIImage(named:"iphoneBG Image")
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        
        view.addSubview(blurEffectView)
        view.addSubview(BGImage)
        
        view.sendSubview(toBack: blurEffectView)
        
        view.sendSubview(toBack: BGImage)

        
        
        
        
    }


  
}

