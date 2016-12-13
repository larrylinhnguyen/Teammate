//
//  LoveViewController.swift
//  Quotes
//
//  Created by Larry on 9/22/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit
import CoreData


@available(iOS 10.0, *)
class LoveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var color = ColorSheet()

    
    var cellTapped : Bool = false
    
    
    var currentTappedRow = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var guildLabel: UILabel!
    
    var request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Quote")
   
    var managedObjectContext : NSManagedObjectContext!
    var loveQuotes : [Quote] = []
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        
        
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        guildLabel.layer.borderWidth = 4
        guildLabel.layer.borderColor = color.pinkColor.cgColor
        guildLabel.layer.cornerRadius = 3
        
        let image = UIImage(named: "Love Bar Image")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        self.navigationItem.titleView = imageView
        
      
        
        
    }
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
             
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pick random color func
    
    
    // loadData func
    
    func loadData () {

        let predicate = NSPredicate(format: "love.isLove = %@", true as CVarArg)
        request.predicate = predicate
        
        do {
            
            loveQuotes = try managedObjectContext.fetch(request) as! [Quote]
            
            self.tableView.reloadData()
            
            print("love count \(loveQuotes.count)")
            
           
            
        } catch {
        
            fatalError("can't load data for love tab" )
        }
        
           }
    //delete data func 
   
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Unlove") { (action, indexPath) in
            
            
            let quote = self.loveQuotes[indexPath.row]
            
            quote.love?.isLove = NSNumber(value: false)
            
            do {
                
                try self.managedObjectContext.save()
                
            } catch {
                
                fatalError()
                
            }
            
            
            
            self.tableView.setEditing(false, animated: true)
            self.loadData()
        }
        
        delete.backgroundColor = UIColor.red
        return [delete]
    }

    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loveQuotes.count
    }
    
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loveCell", for: indexPath) as! LoveTableViewCell
        
        cell.clipsToBounds = true
        cell.wordsLabel.lineBreakMode = .byWordWrapping
        cell.wordsLabel.numberOfLines = 0
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        
       
        
        
        
        // set up contextview
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 150))
        
        whiteRoundedView.layer.backgroundColor = UIColor.clear.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        whiteRoundedView.layer.borderColor = UIColor.white.cgColor
        whiteRoundedView.layer.borderWidth = 2
        
        switch (indexPath.row) {
            
        case 1,6,11,16,21,26,31: whiteRoundedView .layer.backgroundColor = color.loveLightGreenGrey.cgColor
        case 2,7,12,17,22,27,0 : whiteRoundedView.layer.backgroundColor = color.LoveLightGrey.cgColor
            
        case 3,8,13,18,23,28 : whiteRoundedView.layer.backgroundColor = color.loveFogGrey.cgColor
        
        case 4,9,14,19,24,29: whiteRoundedView.layer.backgroundColor = color.loveDarkGrey.cgColor
            
        case 5,10,15,20,25,30 : whiteRoundedView.layer.backgroundColor = color.loveNavy.cgColor
            
        default:
            whiteRoundedView.layer.backgroundColor = color.lightCreamColor.cgColor
            
        }
        

        
        
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        

     
        let loveQuote = loveQuotes[(indexPath as NSIndexPath).row ]
        cell.wordsLabel.text = loveQuote.words
        cell.wordsLabel.textColor = UIColor.darkGray
        cell.authorLabel.text = loveQuote.author
        cell.authorLabel.textColor = UIColor.white
        
        let imageData = loveQuote.image
        let image = UIImage(data: imageData!)?.circleMask
        
        cell.imageLove.image = image
    
     
     return cell
        
     }
    
    
         func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //initial stage
        
        cell.alpha = 0
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        
        //later stage
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        })
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let selectedIndex = indexPath
        currentTappedRow  = selectedIndex.row
       
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let totalRow = loveQuotes.count
        
        
        if indexPath.row == (totalRow - 1){
            return 160
            
        } else {
            
        
        if currentTappedRow ==  indexPath.row   {
            
        if cellTapped == false {
            cellTapped = true
            return 160
        
        
        } else if cellTapped  == true {
        
            cellTapped = false
            return 50
        
        }
        
        }
        return 50
            
            }
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
 

}

