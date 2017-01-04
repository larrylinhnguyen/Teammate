//
//  homeViewController.swift
//  Teammate
//
//  Created by Larry on 1/3/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import UIKit
import CoreData
import Social


@available(iOS 10.0, *)
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
       
    @IBOutlet weak var homeGuildLabel: UILabel!
    
    @IBOutlet weak var didSaveLabel: UILabel!

    var teammates : [Teammate]   = []
    
    var context: NSManagedObjectContext!
    @IBOutlet weak var tableView: UITableView!
    let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Teammate")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request.returnsObjectsAsFaults = false
        tableView.delegate = self
        tableView.dataSource = self
        self.homeGuildLabel.layer.borderColor = ColorSheet().loveNavy.cgColor
        self.homeGuildLabel.layer.borderWidth = 2
        self.homeGuildLabel.layer.cornerRadius = 4
        self.homeGuildLabel.isHidden = false
        let image = UIImage(named:"red.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.image = image
        self.navigationItem.titleView = imageView
        tableView.backgroundColor = UIColor.clear
        
        let BGImageGIF = UIImage.gif(name: "BG")
        
        let BGImageGIFImageView = UIImageView(image: BGImageGIF)
        BGImageGIFImageView.addBlurEffect()
        BGImageGIFImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageGIFImageView)
        self.view.sendSubview(toBack: BGImageGIFImageView)
        self.view.bringSubview(toFront: tableView)
        
        UIView.animate(withDuration: 1.5, delay: 4.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.curveLinear], animations: {
        
        self.homeGuildLabel.layer.position.x = self.homeGuildLabel.layer.position.x + 400
        
        

        }, completion: nil)
        
        delay(2.0) {
            self.homeGuildLabel.isHidden = true
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // alert function, twitterm facebook, basic alert
    
    func sharingTwitterFacebook (){
        
        let message = "SHARE WITH"
        
        let twitterTitle = "Twitter"
        let facebookTitle = "Facebook"
    
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        
        let twitterAct = UIAlertAction(title: twitterTitle, style: .default) { (action)  in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twitterAction : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterAction.setInitialText("Share With Twitter")
                self.present(twitterAction, animated: true, completion: nil)
            
            } else {
                self.alert(message: "Please check if you logged in", title: "No service")
            
            }
        }
        
        let FBAct = UIAlertAction(title: facebookTitle, style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let fbAction: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbAction.setInitialText("Share with facebook")
                
                self.present(fbAction, animated: true, completion: nil)
            
            
            } else {
            
                self.alert(message: "Please check if you logged in", title: "No service")
            }
        }
        
        let CancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(twitterAct)
        alertController.addAction(FBAct)
        alertController.addAction(CancelAct)
        
        self.present(alertController, animated: true, completion: nil)
        
    
    
    }
    
    
    
    // table view delegate and datasource functions
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
          //initial stage
      
        cell.alpha = 0
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        
        //later stage
        UIView.animate(withDuration: 1.0, animations: { 
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }) 
    }
    
    
    
    //MARK: essential tableview delegate and datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return teammates.count
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeTableViewCell
        
        let teammate = teammates[(indexPath as NSIndexPath).row]
        
        
        
        //custom cell 
        
        cell.contentView.backgroundColor = UIColor.white
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 149))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.227, 0.227, 0.227, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        

        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

       
        cell.bio.textColor = ColorSheet().prettyLightGreyColor
        cell.name.textColor = UIColor.white
        cell.title.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.name.text = "\(teammate.firstname)" + "" + "\(teammate.lastname)"
        cell.bio.text = teammate.bio
        cell.title.text = teammate.title
        
        let imageData = teammate.avatar
        
        let image = UIImage(data: imageData! as Data)
        let newImage  = image?.resizeWith(percentage: 0.1)
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.imageView?.image = newImage?.circleMask
        

    
        return cell
 }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let teammate = self.teammates[indexPath.row]

    //love action
        let love = UITableViewRowAction(style: .normal, title: "Love") { action, index in
            
                teammate.love?.islove = true
            do {
                try self.context.save()
                
            } catch {
            
                fatalError()
            
            }
        self.didSaveLabel.text = "Loved"
        self.didSaveLabel.textColor = ColorSheet().pinkColor
        self.didSaveLabel.layer.borderColor = ColorSheet().pinkColor.cgColor
        self.didSaveLabel.layer.borderWidth = 4
        self.didSaveLabel.isHidden = false
        self.delay(1.0, closure: {
            UIView.animate(withDuration: 1.0, animations: {
                self.didSaveLabel.isHidden = true
                })
                
            })
        
        self.tableView.setEditing(false, animated: true)
        }
        love.backgroundColor = ColorSheet().pinkColor
        
        
    // Unlove Action
        
        let unLove = UITableViewRowAction(style: .normal, title: "Unlove") { action, index in
            teammate.love?.islove = false
            
            do {
                try self.context.save()
                
            } catch {
                fatalError()
            }
            
            self.tableView.setEditing(false, animated: true)
            
            self.didSaveLabel.text = "Unloved"
            self.didSaveLabel.textColor = ColorSheet().loveFogGrey
            self.didSaveLabel.layer.borderColor = ColorSheet().loveFogGrey.cgColor
            self.didSaveLabel.layer.borderWidth = 4
            self.didSaveLabel.isHidden = false
            
            self.delay(1.0, closure: {
                UIView.animate(withDuration: 1.0, animations: {
                    self.didSaveLabel.isHidden = true
                })
            })
        }
        
        unLove.backgroundColor = ColorSheet().loveNavy

    //share action
            
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
            
            self.sharingTwitterFacebook()
            self.tableView.setEditing(false, animated: true)
        }
    
        share.backgroundColor = ColorSheet().prettyLightGreyColor
        
        
        if teammate.love?.islove == false {
            return [share, love]
            
        } else if teammate.love?.islove == true {
            return [share,unLove]
        }
        
        return nil
    }
    
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    
    }
    
    
    // Retrieve data from coredata
    
    func loadData()  {
        
        do {
            teammates = try context.fetch(request) as! [Teammate]
             self.tableView.reloadData()
            print("teammates:\(teammates.count)")
            for t in teammates {
                print(t)
            }
        } catch {
            fatalError(" error in loading data from quote entity in core data" )
        
        }

    }
    
    // time delay func
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }


}







