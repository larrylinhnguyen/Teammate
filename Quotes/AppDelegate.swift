//
//  AppDelegate.swift
//  Quotes
//
//  Created by Larry Skyla on 7/9/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let color = ColorSheet()
    let coreData = CoreData()
    
    var manageObjectContext : NSManagedObjectContext!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        // custom pageViewController
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let segmentedControlApearance = UISegmentedControl.appearance()
        segmentedControlApearance.backgroundColor = color.pinkColor
        segmentedControlApearance.tintColor = UIColor.white
        
        
        
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = color.pinkColor
        pageControlAppearance.currentPageIndicatorTintColor = color.deepGreyColor
        pageControlAppearance.backgroundColor = UIColor.white
        
        //custom nagvigation barU
        UIApplication.shared.statusBarStyle = .lightContent
        
        var navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.setBackgroundImage(UIImage(named: "Navigation BG"), for: .default)
        
        navigationBarAppearance.backgroundColor = UIColor.darkGray
        
//        navigationBarAppearance.tintColor = color.pinkColor
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes  = [NSForegroundColorAttributeName: UIColor.white]
        
        
        var tabBarApperance = UITabBar.appearance()
//        tabBarApperance.sizeThatFits(CGSize(width: 80.0, height: 60.0))
        tabBarApperance.tintColor = color.pinkColor
        
        //end
        
    manageObjectContext = coreData.managedObjectContext
        
      
           
            
            
//        let tabController = self.window?.rootViewController as! UITabBarController
            
            
                
//        deleteRecords()
        checkDataStore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // function to check existing data count in data store
    
    func checkDataStore() {
    
        let count: Int
        let coreData = CoreData()
        
        let quoteRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Quote")
        
        do{
         count = try coreData.managedObjectContext.count(for: quoteRequest)
        print("initial count : \(count)")
            
        } catch {
            
            fatalError("counting quotes error")
        
        }
        
        if count == 0 {
        
            uploadJsonData()
        
        }

    }

    // function to upload the jason file to data store
    func uploadJsonData(){
    
        let coreData = CoreData()
       
        
        let url = Bundle.main.url(forResource: "Quotes", withExtension: "json")
        
        let data = try? Data(contentsOf: url!)
        
        do {
            
            let jsonResults = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let jsonArray  = jsonResults.object(forKey: "quote") as! NSArray
       
            
            for json in jsonArray {
            
                let quote = NSEntityDescription.insertNewObject(forEntityName: "Quote", into: coreData.managedObjectContext) as! Quote
                
                quote.words = (json as AnyObject)["words"] as? String
                quote.author = (json as AnyObject)["author"] as? String
                let imageName = (json as AnyObject)["image"] as? String
                let image = UIImage(named: imageName!)
                let imageData = UIImageJPEGRepresentation(image!, 1)
                
              
                quote.image = imageData
                
                
                let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: coreData.managedObjectContext) as! Category
                
                category.type = ((json as AnyObject)["category"] as! NSDictionary)["type"] as? String
                quote.category = category
                
                let status = NSEntityDescription.insertNewObject(forEntityName: "Status", into: coreData.managedObjectContext) as! Status
                
                let isPositive = ((json as AnyObject)["status"] as! NSDictionary)["isPositive"] as? Bool
                status.isPositive  = NSNumber(value: isPositive! as Bool)
                quote.status = status
                
                let love = NSEntityDescription.insertNewObject(forEntityName: "Love", into: coreData.managedObjectContext) as! Love
                
                let isLove = ((json as AnyObject)["love"] as! NSDictionary)["isLove"] as? Bool
                love.isLove  = NSNumber(value: isLove! as Bool)
                quote.love = love

                
                
            }
            
            coreData.saveContext()
            
            let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Quote")

            do {
            let laterCount = try coreData.managedObjectContext.count(for: request)
            
            } catch {
            
                fatalError()
            }
            
        } catch {
        
            fatalError(" error uploading json data from json file" )
        }
        
        
    
    }
    
    
//    func deleteRecords() {
//        let coreData = CoreData()
//        
//        let quoteRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Quote")
//        let categoryRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
//
//        let statusRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Status")
//
//        let loveRequest  : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Love")
//
//        
//        do {
//            let quoteResults = try coreData.managedObjectContext.fetch(quoteRequest) as! [Quote]
//            for quote in quoteResults {
//                coreData.managedObjectContext.delete(quote)
//            }
//            
//            let categoryResults = try coreData.managedObjectContext.fetch(categoryRequest) as NSArray
//            for category in categoryResults {
//                coreData.managedObjectContext.delete(category as! NSManagedObject)
//            }
//            
//            let statusResults = try coreData.managedObjectContext.fetch(statusRequest) as! [Status]
//            for status in statusResults {
//                coreData.managedObjectContext.delete(status)
//            }
//            
//            let loveResults = try coreData.managedObjectContext.fetch(loveRequest) as! [Love]
//            for love in loveResults {
//                coreData.managedObjectContext.delete(love)
//            }
//            
//            coreData.saveContext()
//            
//            do {
//            let quoteCount = try coreData.managedObjectContext.count(for: quoteRequest)
//            print("Total home after clean up: \(quoteCount)")
//                
//            } catch {
//                fatalError()
//            }
//        }
//        catch {
//            fatalError("Error deleting objects")
//        }
//    }

    
}

