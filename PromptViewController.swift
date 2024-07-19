//
//  PromptViewController.swift
//  BitcampA
//
//  Created by Chiraag Nadig on 4/20/24.
//

import UIKit
import CoreData

class PromptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA) // lightPurple color
    var passedHeader = ""
    
    @IBOutlet var table: UITableView!
    
    var names = [String]()
    
    let cellSpacingHeight: CGFloat = 1
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "promptToEditor" {
            let otherView = segue.destination as! EditViewController
            otherView.header = passedHeader
        }
    }
    
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passedHeader = names[indexPath.section]
        performSegue(withIdentifier: "promptToEditor", sender: nil)
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
     let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! PromptTableViewCell

      //Configure the cell...
//     cell.titleLabel.text = names[indexPath.section]
        cell.headerText.text = names[indexPath.section]
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true

        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.rowHeight = 120

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        names = [String]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            //print(results.count)
            //print(results)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let promptName = result.value(forKey: "prompty") as? String {
                        //print("Name: " + promptName)
                        names.append(promptName)
                    }
                }
            }
        }
        catch {
            print("Could not load prompts")
        }
        table.reloadData()
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
