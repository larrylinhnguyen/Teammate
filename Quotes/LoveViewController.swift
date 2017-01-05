//
//  LoveViewController.swift
//  Teammate
//
//  Created by Larry on 1/3/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//


import UIKit
import CoreData
import DZNEmptyDataSet

@available(iOS 10.0, *)
class LoveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    var color = ColorSheet()
    var cellTapped : Bool = false
    var currentTappedRow = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var guildLabel: UILabel!
    
    
    var request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Teammate")
    var context : NSManagedObjectContext!
    var loveMates : [Teammate] = []
  
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let BGImageGIF = UIImage(named: "BG")
        let BGImageView = UIImageView(image: BGImageGIF)
        BGImageView.addBlurEffect()
        BGImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageView)
        self.view.sendSubview(toBack: BGImageView)

        guildLabel.layer.borderWidth = 4
        guildLabel.layer.borderColor = color.pinkColor.cgColor
        guildLabel.layer.cornerRadius = 3
        
        let image = UIImage(named: "Love Bar Image")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        self.navigationItem.titleView = imageView
        loadData()
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    // MARK: request data
    
    
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return loveMates.count ?? 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loveCell", for: indexPath as IndexPath) as! LoveTableViewCell
        
             let loveMate = loveMates[(indexPath as NSIndexPath).row]
            cell.clipsToBounds = true
            cell.name.lineBreakMode = .byWordWrapping
            cell.name.numberOfLines = 0
        
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
            
        
            cell.name.text = loveMate.firstname! + " " + loveMate.lastname!
            
            cell.name.textColor = UIColor.darkGray
            cell.title.text = loveMate.title
            cell.title.textColor = UIColor.white
            
            let imageData = loveMate.avatar
            let image = UIImage(data: imageData! as Data )?.resizeWith(percentage: 0.3)
            cell.imageView?.image = image?.circleMask
        return cell
    }
    
    
   // Tableview delegate methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Unlove") { (action, indexPath) in
            
            
            let loveMate = self.loveMates[indexPath.row]
            
            loveMate.isLove = false
            
            
            do {
                try self.context.save()
            } catch {
                fatalError()
            }
            self.loadData()
            self.tableView.setEditing(false, animated: true)
            self.tableView.reloadData()
        }
        
        delete.backgroundColor = UIColor.red
        return [delete]
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
        
        let totalRow = loveMates.count
        
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
    
    
    // MARK: load data
    
    func loadData() {
        let predicate = NSPredicate(format: "isLove = %@", true as CVarArg)
        request.predicate = predicate
        do {
            loveMates = try context.fetch(request) as! [Teammate]
            self.tableView.reloadData()
        } catch {
            fatalError(" error in loading data from quote entity in core data" )
        }
        
        
    }
    
    // MARK : Empty data table implemetation
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Add Teammates at Home Tab"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Then Swipe Left To See Options "
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "icon.png")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Remember to press LOVE "
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: "Get to know your new teammates", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default))
        present(ac, animated: true)
    }
    
    
    

 

}

