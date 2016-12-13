//
//  ProfileViewController.swift
//  Quotes
//
//  Created by Larry on 10/1/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit
import CoreData


@available(iOS 10.0, *)
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    let emotions: [String]  = ["Happines","Love","Trust","Hope", "Bore","Disgust","Sadness","Stress"]
    var positive : Bool = false
    let color = ColorSheet()
    let coreData = CoreData()
    var managedObjectContext : NSManagedObjectContext!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!

  
    @IBOutlet weak var wordsLabel: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var aboveAuthor: UILabel!
    @IBOutlet weak var wordsTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        
        self.wordsTextField.delegate = self
        self.authorTextField.delegate = self
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.wordsTextField.text = ""
        self.authorTextField.text = ""
        
        
                // custom fields
        
        aboveAuthor.layer.borderWidth = 3
        aboveAuthor.layer.cornerRadius = 3
        aboveAuthor.layer.borderColor = color.deepGreyColor.cgColor
        
        authorLabel.textColor = color.deepGreyColor
        authorLabel.backgroundColor = UIColor.clear
     
        authorLabel.layer.cornerRadius = 6
        authorLabel.layer.borderWidth = 3
        authorLabel.layer.borderColor = color.pinkColor.cgColor
        
        wordsLabel.backgroundColor = UIColor.clear
        wordsLabel.textColor = color.loveDarkGrey
        wordsLabel.layer.cornerRadius = 6
        wordsLabel.layer.borderWidth = 3
        wordsLabel.layer.borderColor = color.loveGreenCoffee.cgColor
        
        
        
              
        
        navigationItem.title = " Create Your Own Quote"
        
        self.hideKeyboardWhenTappedAround()


        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        if wordsTextField.text! == "" || authorTextField.text! == "" {
            
            let alertController = UIAlertController(title:"Missing Field", message: "Please Complete the Missing Field", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            let words = wordsTextField.text!
            let author = authorTextField.text!
            let imageData = UIImageJPEGRepresentation(imageView.image!, 1.0)
            
            let quote = NSEntityDescription.insertNewObject(forEntityName: "Quote", into: coreData.managedObjectContext) as! Quote
            
            quote.words = words
            quote.author = author
            quote.image = imageData
            let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: coreData.managedObjectContext) as! Category
            
            let type = emotions[pickerView.selectedRow(inComponent: 0)]
            category.type = type
            quote.category = category
            
            switch (type) {
            case "Happines","Hope","Trust","Love":
                positive = true
            case "Sadness","Disgust","Stress", "Bore":
                positive = false
            default:
                positive = true
            }
            
            let love = NSEntityDescription.insertNewObject(forEntityName: "Love", into: coreData.managedObjectContext) as! Love
            
            let isLove = NSNumber(value: true)
            love.isLove = isLove
            quote.love = love
            
            let status = NSEntityDescription.insertNewObject(forEntityName: "Status", into: coreData.managedObjectContext) as! Status
            
            let isPositive = NSNumber(value: positive)
            status.isPositive = isPositive
            quote.status = status
            
            do {
                try self.managedObjectContext.save()
                //saved alert
                
                let alertController = UIAlertController(title:"Quote Saved", message: "Your Quote Have Been Saved", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)  
            } catch
                
            {
                fatalError(" cant save quote")
                
            }
            
            coreData.saveContext()
            
            wordsTextField.isHidden = true
            authorTextField.isHidden = true
            aboveAuthor.isHidden = true
            
            let ps = NSMutableParagraphStyle();
            ps.firstLineHeadIndent = 20
            
            // indent words label,author label
            let attrs = [NSParagraphStyleAttributeName: ps]
            let attributedWordLabel = NSAttributedString(string: wordsTextField.text!, attributes: attrs)

            wordsLabel.attributedText = attributedWordLabel
            
            let attributedAuthorLabel = NSAttributedString(string: authorTextField.text!,attributes: attrs)
            
            authorLabel.attributedText = attributedAuthorLabel

           
            authorLabel.isHidden = false
            wordsLabel.isHidden = false
            addMoreButton.isHidden = false
            saveButton.isEnabled = false
            wordsTextField.text = ""
            authorTextField.text = ""
            
}
            }
    
    @IBAction func addMorePressed(_ sender: AnyObject) {
        
        wordsTextField.isHidden = false
        authorTextField.isHidden = false
        aboveAuthor.isHidden = false
        authorLabel.text = ""
        wordsLabel.text = ""
        authorLabel.isHidden = true
        wordsLabel.isHidden = true
        
        addMoreButton.isHidden = true
        saveButton.isEnabled = true
        imageView.image = UIImage(named: "Camera")
        
    }

    @IBAction func imagepickerAction(_ sender: AnyObject) {
        alert("", msg: "Add Picture")
        
        
    }
    
    // photo camera
    
    func cameraPick() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
            }
            
        } else {
            
            let alertController = UIAlertController(title:"", message: "Camera Not Available", preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(actionOK)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        
        }
    }
    
    
    //photo library
    func photoLibraryPick () {
    
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        
        }
    
    }
    
    // alert  camera, photo,and cancel
    
    func alert(_ title: String, msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
       
        var cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        var cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.cameraPick()
        }
        
        var photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.photoLibraryPick()
            
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        

        self.present(alertController, animated: true, completion: nil)
        
        }
    
    //blurr background when taking photo
    
   /* func makeItBlur() {
    
    
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(visualEffectView)
        view.sendSubview(toBack: visualEffectView)

        
    
    }
    
   */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            imageView.image = pickedImage.circleMask
            
            imageView.contentMode = .scaleAspectFit
            
            self.dismiss(animated: true, completion: nil)
        
        }
        
    }
    
    // textfield methods
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // picker view protocols
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let emotion = self.emotions[row]
        return emotion
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.emotions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        }
    
    
}


///////////////extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

