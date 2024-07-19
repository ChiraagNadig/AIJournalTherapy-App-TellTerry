//
//  ViewController.swift
//  BitcampA
//
//  Created by Krish Thakker on 4/19/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA) // lightPurple color
    
    var names = [String]()
    var prompts = [String]()
    
    var passedHeader = ""
    
    let cellSpacingHeight: CGFloat = 1
    
    var bigBoyString = ""
    
    var font = UIFont(name: "Miology", size: 72)
    
    @IBOutlet var label: UILabel!
    private let imageManager = ImageManager()
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditor" {
            let otherView = segue.destination as! EditViewController
            otherView.header = passedHeader
            otherView.editResponse = true
        }
    }
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passedHeader = names[indexPath.section]
        performSegue(withIdentifier: "toEditor", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return names.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1
        let headerView = UIView()
        // 2
        //headerView.backgroundColor = view.backgroundColor
        // 3
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! OvalCell

      //Configure the cell...
//     cell.titleLabel.text = names[indexPath.section]
        cell.titleLabel.text = names[indexPath.section]
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true

        return cell
    }
    
    override func viewDidLoad() {
//        label.font = font
//        
//        rightBtn.titleLabel?.font = font
//        leftBtn.titleLabel?.font = font
        
//        plusBtn.backgroundColor = UIColor.purple
//        rightBtn.backgroundColor = UIColor(hex: 0x330066)
//        leftBtn.backgroundColor = UIColor(hex: 0xE6E6FA)
        setupGradient()
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.rowHeight = 80
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //clean()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var counter = 0
                for result in results as! [NSManagedObject] {
                    if let promptName = result.value(forKey: "prompt") as? String {
                        counter = counter + 1
                        if counter > names.count {
                            names.append(promptName)
                        }
                    }
                }
            }
        }
        catch {
            print("Could not load prompts")
        }
        table.reloadData()
        
        
        /*
        makeBigBoy()
        print("BBS: " + bigBoyString)
        imageManager.processPrompts(input: bigBoyString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            //print("Prompts:")
            //print(self.imageManager.promptArr) // FIX QUESTIONS
            self.prompts = self.imageManager.promptArr
            
            //print(self.prompts)
            
            self.cleanPrompts()
            //print(self.prompts)
            let requestPrompts = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
            requestPrompts.returnsObjectsAsFaults = false
            for prompt in self.prompts {
                let newRoutine = NSEntityDescription.insertNewObject(forEntityName: "Questions", into: context)
                print(prompt)
                newRoutine.setValue(prompt, forKey: "prompty")
                do {
                    try context.save()
                }
                catch {
                    //pop up that an error occured
                    print("An error occured. Please try again")
                }
            }
            
            
        }
        */
        
    }
    /*
    func makeBigBoy() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let responseStuff = result.value(forKey: "response") as? String {
                        bigBoyString = bigBoyString + " " + responseStuff
                    }
                }
            }
        }
        catch {
            print("Could not load prompts")
        }
    }
    */
    func clean() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    do {
                        try context.save()
                    }
                    catch {
                        print("could not delete")
                    }
                }
            }
        }
        catch {
            print("could not fetch results")
        }
    }
    
    func cleanPrompts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    do {
                        try context.save()
                    }
                    catch {
                        print("could not delete")
                    }
                }
            }
        }
        catch {
            print("could not fetch results")
        }
    }

}



