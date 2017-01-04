//
//  AppDelegate.swift
//  Teammate
//
//  Created by Larry on 1/3/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//


import UIKit
import CoreData

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var imageData : Data!
    var window: UIWindow?
    let color = ColorSheet()
    lazy var coreDataStack = CoreDataStack(modelName: "Teammate Model")
     let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Teammate")

    var context : NSManagedObjectContext!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        context = coreDataStack.managedContext
        // custom pageViewController
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        context = coreDataStack.managedContext
        
    
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = color.pinkColor
        pageControlAppearance.currentPageIndicatorTintColor = color.deepGreyColor
        pageControlAppearance.backgroundColor = UIColor.white
        
        //custom nagvigation barU
        UIApplication.shared.statusBarStyle = .lightContent
        
        var navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.setBackgroundImage(UIImage(named: "Navigation BG"), for: .default)
        
        navigationBarAppearance.backgroundColor = UIColor.darkGray
    
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes  = [NSForegroundColorAttributeName: UIColor.white]
        
        
        var tabBarApperance = UITabBar.appearance()

        tabBarApperance.tintColor = color.pinkColor
        
        deleteRecords()
        checkDataStore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    
    // function to check existing data count in data store
    
    

    func checkDataStore() {
        let count: Int
        
        do{
            count = try context.count(for: request)
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
        
        let url = Bundle.main.url(forResource: "team", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            
            let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
            
            
            for json in jsonArray {
                
                let teammate = NSEntityDescription.insertNewObject(forEntityName: "Teammate", into: context) as! Teammate
                let first = (json as AnyObject)["firstName"] as? String
                teammate.setValue(first, forKey: "firstname")
                
                let last = (json as AnyObject)["lastName"] as? String
                teammate.setValue(last, forKey: "lastname")

                let i = (json as AnyObject)["id"] as? String
                teammate.setValue(i, forKey: "id")

                let bi = (json as AnyObject)["bio"] as? String
                teammate.setValue(bi, forKey: "bio")

                let titl = (json as AnyObject)["title"] as? String
                teammate.setValue(titl, forKey: "title")
                
                
                
                let picture = NSEntityDescription.insertNewObject(forEntityName: "Picture", into: context) as! Picture
                let string = (json as AnyObject)["avatar"] as? String
                
                let data = NSData(contentsOf: NSURL(string: string!)! as URL)
                
                
                
                teammate.setValue(data, forKey: "avatar")
                let love = NSEntityDescription.insertNewObject(forEntityName: "Love", into: context) as! Love
                
                let isLove = NSNumber(value: false)
                love.setValue(isLove, forKey: "islove")
                teammate.setValue(isLove, forKey: "isLove")
               
            }
            
            coreDataStack.saveContext()
            
            
            do {
                let count = try context.count(for: request)
                print("Later count:\(count)")
            } catch {
                fatalError()
            }
            
        } catch {
            
            fatalError(" error uploading json data from json file" )
        }
        
        
        
    }
    
    //MARK: delete data
    
        func deleteRecords() {
        
            let teammateRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Teammate")
            let pictureRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Picture")
            let loveRequest  : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Love")
    
    
            do {
                let teammates = try context.fetch(teammateRequest) as! [Teammate]
                for teammate in teammates {
                  context.delete(teammate)
                }
                
                let loves = try context.fetch(loveRequest) as! [Love]
                for pic in loves {
                    context.delete(pic)
                }

                
                let pics = try context.fetch(pictureRequest) as! [Picture]
                for pic in pics {
                    context.delete(pic)
                }
    
                
               coreDataStack.saveContext()
    
        }
            catch {
                fatalError("Error deleting objects")
            }
        }

    
    
    }



