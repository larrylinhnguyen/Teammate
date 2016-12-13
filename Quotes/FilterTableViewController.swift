//
//  FilterTableViewController.swift
//  Quotes
//
//  Created by Larry on 9/14/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit


protocol filterTableViewControllerProtocal {
    func updateQuoteList (_ filter:NSPredicate?, sort: NSSortDescriptor?)
}

class FilterTableViewController: UITableViewController {
// FIlter
    
    @IBOutlet weak var happyFilter: UITableViewCell!
    @IBOutlet weak var loveFilter: UITableViewCell!
 
    @IBOutlet weak var hopeFilter: UITableViewCell!
    @IBOutlet weak var trustFilter: UITableViewCell!
    @IBOutlet weak var sadFilter: UITableViewCell!
    @IBOutlet weak var stressFilter: UITableViewCell!
    @IBOutlet weak var boreFilter: UITableViewCell!

    @IBOutlet weak var disgustFilter: UITableViewCell!
    
   
    var sortDisc : NSSortDescriptor?
    var addPredicate : NSPredicate?

    var delegate : filterTableViewControllerProtocal!
    
    // Sorting
    @IBOutlet weak var aZSort: UITableViewCell!
    
    @IBOutlet weak var zASort: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if section == 0 {
        
            return 8
        
        } else if section == 1 {
            
            return 2
        
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    // select filter and sort cells
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        
        switch selectedCell {
            
        case aZSort :
            setSortDescriptor("category.type", isAscending: true)
        case zASort :
            setSortDescriptor("category.type", isAscending: false)
            
        case happyFilter :
            setFilterPredicate("Happiness")
        case loveFilter:
            setFilterPredicate("Love")
        case trustFilter:
            setFilterPredicate("Trust")
        case hopeFilter:
            setFilterPredicate("Hope")
        case sadFilter:
            setFilterPredicate("Sadness")
        case boreFilter:
            setFilterPredicate("Bore")
        case disgustFilter:
            setFilterPredicate("Disgust")
        case stressFilter:
            setFilterPredicate("Stress")
        default:
            print(" no filter or sorting selected")
        
        }
        
        selectedCell.accessoryType = .checkmark
        delegate.updateQuoteList(addPredicate, sort: sortDisc)
        
    }
    
    //////////////////////////
    
    // sort and filter functions
    
    func setSortDescriptor ( _ sortBy:String, isAscending: Bool) {
    
    
        sortDisc = NSSortDescriptor(key: sortBy, ascending: isAscending)
    
    }
    
    func setFilterPredicate (_ filterBy: String) {
        
        addPredicate = NSPredicate(format: "category.type = %@", filterBy)
    
    
    }
    
    
       /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
