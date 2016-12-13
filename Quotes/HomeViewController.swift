//
//  homeViewController.swift
//  Quotes
//
//  Created by Larry on 9/7/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit
import CoreData
import Social





@available(iOS 10.0, *)
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    
    
    var addPredicate : NSPredicate!
    var sortDesc = [NSSortDescriptor]()
    var request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Quote")
    
    @IBOutlet weak var homeGuildLabel: UILabel!
    
    @IBOutlet weak var segmentBorderButton: UIButton!
    @IBOutlet weak var didSaveLabel: UILabel!
    var isPositive : Bool = true
    var isLove : Bool = false
    
   
    var loveQuotes : [Quote] = []
    var quotes : [Quote]   = []
    
    let coreData = CoreData()
    var managedObjectContext: NSManagedObjectContext!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
        self.segmentBorderButton.layer.cornerRadius = 3
        
        self.segmentBorderButton.layer.borderColor = ColorSheet().pinkColor.cgColor
        self.segmentBorderButton.layer.borderWidth = 3
        
        self.homeGuildLabel.layer.borderColor = ColorSheet().loveNavy.cgColor
        self.homeGuildLabel.layer.borderWidth = 2
        self.homeGuildLabel.layer.cornerRadius = 4
        
     
        
       self.homeGuildLabel.isHidden = false
        
       UIView.animate(withDuration: 1.5, delay: 4.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.curveLinear], animations: {
        
        self.homeGuildLabel.layer.position.x = self.homeGuildLabel.layer.position.x + 400
        

        }, completion: nil)
        
        delay(4.0) {
            self.homeGuildLabel.isHidden = true
        }
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          
        
        super.viewWillAppear(animated)
        let image = UIImage(named:"Bar Title Image.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.image = image
        self.navigationItem.titleView = imageView
        
      
        
        loadData()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        
        let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        if selectedValue == "Positive" {
            isPositive = true
        }
        else if selectedValue == "Negative" {
            isPositive = false
        }
        
        
        loadData()

    }
    //////////  Resize image
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // time delay func
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    ////////
    
    func loadData() {
        var predicates = [NSPredicate]()
        
        let statusPredicate = NSPredicate(format: "status.isPositive = %@", isPositive as CVarArg)
        if let addPredicate = addPredicate {
        
            predicates.append(addPredicate)
        
        }
        predicates.append(statusPredicate)
        
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        
        request.predicate = predicate
        
        
        
        if sortDesc.count > 0 {
        request.sortDescriptors = sortDesc
        }
        
        do {
             quotes = try managedObjectContext.fetch(request) as! [Quote]
            
            
            self.tableView.reloadData()
        
        
        } catch {
        
            fatalError(" error in loading data from quote entity in core data" )
        
        }
    
    
    }
    
    
    // alert function, twitterm facebook, basic alert
    
    
    
    func alert(_ title: String, msg: String) {
    
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    
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
                self.alert("No service", msg: "Check If You Logged In Twitter")
            
            }
        }
        
        let FBAct = UIAlertAction(title: facebookTitle, style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let fbAction: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbAction.setInitialText("Share with facebook")
                
                self.present(fbAction, animated: true, completion: nil)
            
            
            } else {
            
                self.alert("No service", msg: "Check if you logged in facebook")
            }
        }
        
        let CancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(twitterAct)
        alertController.addAction(FBAct)
        alertController.addAction(CancelAct)
        
        self.present(alertController, animated: true, completion: nil)
        
    
    
    }
    
    
    
    // table view functions
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return quotes.count
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeTableViewCell
        let quote = quotes[(indexPath as NSIndexPath).row]
        
        
        
        //custom cell 
        
        cell.contentView.backgroundColor = UIColor.white
       
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 149))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.227, 0.227, 0.227, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        
      
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

        
        cell.wordsLabel.textColor = ColorSheet().prettyLightGreyColor
        cell.authorLabel.textColor = UIColor.white
        cell.categoryLabel.textColor = UIColor.white
        
        //End custom cell
        
        
        // like and shares activation
        
        cell.wordsLabel.text = quote.words
        cell.authorLabel.text = quote.author
        cell.categoryLabel.text = quote.category?.type
        let imageData = quote.image
        
        let image = UIImage(data: imageData! as Data)
        
        let newImage  = ResizeImage(image: image!, targetSize: CGSize(width: 40, height: 40))
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.imageView?.image = newImage.circleMask
        
        
        
        
        
        return cell
 }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let quote = self.quotes[indexPath.row]

        //love action
        let love = UITableViewRowAction(style: .normal, title: "Love") { action, index in
            
                quote.love?.isLove = NSNumber(value: true)
            do {
                try self.managedObjectContext.save()
                
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
            quote.love?.isLove = NSNumber(value: false)
        do {
                try self.managedObjectContext.save()
                
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
        
        
        if quote.love?.isLove == false {
        return [share, love]
            
        } else if quote.love?.isLove == true {
        
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
    
//    //ending swipe
//        
//       // Gets a Quote by id
//    func getById(_ id: NSManagedObjectID) -> Quote? {
//        return managedObjectContext.object(with: id) as? Quote
//    }
//    
//    // Updates a Quote
//    func update(_ updatedQuote: Quote){
//        if let quote = getById(updatedQuote.objectID){
//            quote.love = updatedQuote.love
//            
//        }
//    }
    
   
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFilter" {
            addPredicate = nil
            sortDesc = []
            let controller = segue.destination as! FilterTableViewController
            controller.delegate = self
        
        }
    }
    
    
   }


//extension for Filter
@available(iOS 10.0, *)
extension HomeViewController: filterTableViewControllerProtocal {
    func updateQuoteList(_ filter: NSPredicate?, sort: NSSortDescriptor?) {
        if let filter = filter {
        
            addPredicate = filter
        
        }
        
        if let sort = sort {
        
            sortDesc.append(sort)
        
        }
    }
    
    
}

// extension for color

extension UIColor {
    
    
    static func colorWithRedValue(_ redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    }

//extension imge masking

extension UIImage {
    var circleMask: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 80
        return sizeThatFits
    }
}




