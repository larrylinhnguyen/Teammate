//
//  StartVC.swift
//  Teammate
//
//  Created by Larry on 1/3/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//


import UIKit
import CoreData

@available(iOS 10.0, *)
class StartVC: UIViewController {
    
    let color = ColorSheet()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameImage: UIImageView!
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDel.context
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.displayWalk()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // func: check if has displayed walkthrough
    
    func displayWalk () {
        
    
        let userDefaults = UserDefaults.standard
        
        let displayedWalkThrough = userDefaults.bool(forKey: "displayedWalk")
        
        if !displayedWalkThrough  {
            
           
                if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
                           
                            
                self.present(pageViewController, animated: true, completion: nil)
                    
            }
        }
        
        // if displayed, go ahead to main viewcontrollers
        if displayedWalkThrough  {
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let tabController = self.storyboard!.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
            
            appDelegate.window?.rootViewController = tabController
            appDelegate.window?.makeKeyAndVisible()
            
            let homeNavViewController = tabController.viewControllers![0] as! UINavigationController
            let homeViewController = homeNavViewController.topViewController as! HomeViewController
            homeViewController.context = context
            
            let loveNavViewController = tabController.viewControllers![1] as! UINavigationController
            let loveViewController = loveNavViewController.topViewController as! LoveViewController
            loveViewController.context = context
            
            let randomNavViewController = tabController.viewControllers![2] as! UINavigationController
            let randomViewController = randomNavViewController.topViewController as! RandomTableViewController
            randomViewController.context = context
            
        }
        
    }

   }
