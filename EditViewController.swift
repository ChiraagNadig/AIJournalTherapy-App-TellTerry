//
//  EditViewController.swift
//  BitcampA
//
//  Created by Chiraag Nadig on 4/20/24.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    
    var header = "Header"
    
    var editResponse = false;
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA)
    
    
    @IBOutlet var headerText: UILabel!
    
    
    @IBOutlet var response: UITextView!
    
    
    @IBOutlet var saveButton: UIButton!
    
    
    
    @IBAction func saveJournal(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.returnsObjectsAsFaults = false
        if(editResponse) {
            request.predicate = NSPredicate(format: "prompt = %@", headerText.text!)
            request.returnsObjectsAsFaults = false
            do {
                let updateResults = try context.fetch(request)
                if updateResults.count > 0 {
                    for updateResult in updateResults as! [NSManagedObject] {
                        updateResult.setValue(response.text, forKey: "response")
                        do {
                           try context.save()
                        }
                        catch {
                            //saveStatus.text = "Your exercise failed to be updated. Please try again"
                        }
                    }
                }
            }
            catch {
                print("womp womp")
            }
        }
        else {
            let newRoutine = NSEntityDescription.insertNewObject(forEntityName: "PromptResponse", into: context)
            newRoutine.setValue(response.text, forKey: "response")
            newRoutine.setValue(headerText.text, forKey: "prompt")
            do {
                try context.save()
            }
            catch {
                //pop up that an error occured
                print("An error occured. Please try again")
            }
        }
        self.performSegue(withIdentifier: "editToHome", sender: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        headerText.text = header

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setupGradient()
        
        response.layer.cornerRadius = 20
        response.clipsToBounds = true
        
        if editResponse {
            saveButton.setTitle("Update", for: [])
        }
        else {
            saveButton.setTitle("Save", for: [])
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.predicate = NSPredicate(format: "prompt = %@", headerText.text!)
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var counter = 0
                for result in results as! [NSManagedObject] {
                    if let response = result.value(forKey: "response") as? String {
                        self.response.text = response
                    }
                }
            }
        }
        catch {
            print("Could not load exercises")
        }
    }
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
