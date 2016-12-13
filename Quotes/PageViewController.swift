//
//  PageViewController.swift
//  Quotes
//
//  Created by Larry on 9/28/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
   
    var imageArray: NSArray! = ["Login Home Image","Login Heart Image","Login Radom Image","Login Note Image"]
    var headerArray : NSArray! = [" Welcome To PINC  ", "Love A Quote", " Pick A Random", "Create A Quote"]
    
    var ContentArray : NSArray! = ["Start Your Day With An Emotion","Press The Love To Love, Press The Share to Share","You Can Simply Press The Button To Generate A Random Quote"," You Can Create Your Own Quote With A Picture"]
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.dataSource = self
        
        if let startContentVC = self.viewControllerAtIndex(0){
        self.setViewControllers([startContentVC], direction: .forward, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pick pageContext using index
    
    func viewControllerAtIndex (_ index : Int) -> PageContentVCViewController? {
        
        if (index == NSNotFound  || index < 0 || index >= ContentArray.count) {
        
            return nil
           
        }
        
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "PageContentVC") as? PageContentVCViewController {
            pageContentVC.pageIndex = index
            pageContentVC.contentLbl = ContentArray[index] as! String
            pageContentVC.headerLbl  = headerArray[index] as! String
            pageContentVC.imageName = imageArray[index] as! String
            
            
            return pageContentVC
        }
        
        return nil
    
    }
    

}

extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentVCViewController).pageIndex
        
        index = index - 1
        
        return self.viewControllerAtIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
       
        var index = (viewController as! PageContentVCViewController).pageIndex
        
        index = index + 1
        
        return self.viewControllerAtIndex(index)

    }
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return self.headerArray.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
//
    
    

}
