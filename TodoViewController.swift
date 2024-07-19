//
//  TodoViewController.swift
//  BitcampA
//
//  Created by Krish Thakker on 4/19/24.
//

import UIKit
import CoreData
import OpenAIKit

struct TableRowData {
    var header: String
    var subheader: String
    var image: UIImage?
}

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let imageManager = ImageManager()
    
    let openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: "sk-proj-2WoFCfVvcLqvrHq401aTT3BlbkFJ6XeVjr9ZK4wZklasC5YY"))
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA) // lightPurple color
    
    var tableData: [TableRowData] = []
    
    @IBOutlet weak var table: UITableView!
    
    
    
    let cellSpacingHeight: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 116
        
        //loadData()
        
        table.rowHeight = 150
        
        table.reloadData()
    }
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    /*
    func loadData() {
        makeBigBoyString { bigBoyString in
            self.imageManager.processTodos(input: bigBoyString) { headers, subs in
                self.loadImages(headers: headers, subs: subs)
            }
        }
    }
    
    func loadImages(headers: [String], subs: [String]) {
        for (index, header) in headers.enumerated() {
            Task {
                do {
                    let imageParams = ImageParameters(prompt: header, resolution: .medium, responseFormat: .base64Json)
                    let result = try await self.openAI.createImage(parameters: imageParams)
                    let generated = try self.openAI.decodeBase64Image(result.data[0].image)
                    
                    let row = TableRowData(header: header, subheader: subs[index], image: generated)
                    DispatchQueue.main.async {
                        self.tableData.append(row)
                        self.tableData.sort(by: { headers.firstIndex(of: $0.header)! < headers.firstIndex(of: $1.header)! })
                        self.table.reloadData()
                    }
                } catch {
                    print("Error generating image: \(error)")
                }
            }
        }
    }
     */
    
    // MARK: - UITableView DataSource and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecommendationsTableViewCell
        
        let rowData = tableData[indexPath.section]
        cell.headerText.text = rowData.header
        cell.subText.text = rowData.subheader
        cell.imageView1.image = rowData.image
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Helper Methods
    
    func makeBigBoyString(completion: @escaping (String) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PromptResponse")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            var bigBoyString = ""
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let responseStuff = result.value(forKey: "response") as? String {
                        bigBoyString += " " + responseStuff
                    }
                }
            }
            DispatchQueue.main.async {
                completion(bigBoyString)
            }
        }
        catch {
            print("Could not load prompts")
        }
    }
}

/*
import UIKit
import CoreData
import OpenAIKit

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let imageManager = ImageManager()
    
    let openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: "sk-proj-2WoFCfVvcLqvrHq401aTT3BlbkFJ6XeVjr9ZK4wZklasC5YY"))
    

    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA) // lightPurple color
    
    var imgs = [UIImage]()
    
    var headers = [String]()
    var subs = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    
    var bigBoyString = ""
    
    let cellSpacingHeight: CGFloat = 1
    
    
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headers.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecommendationsTableViewCell

      //Configure the cell...
        cell.headerText.text = headers[indexPath.section]
        cell.subText.text = subs[indexPath.section]
        cell.imageView1.image = imgs[indexPath.section]
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true

        return cell

    }
    
    override func viewDidLoad() {
//        plusBtn.backgroundColor = UIColor.purple
//        rightBtn.backgroundColor = UIColor(hex: 0xE6E6FA)
//        leftBtn.backgroundColor = UIColor(hex: 0x330066)
        setupGradient()
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        imgs = [UIImage]()
        
        table.rowHeight = 116
        
        makeBigBoy()
        print("BBS: " + bigBoyString)
        imageManager.processTodos(input: bigBoyString)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 100.0) {
            //print("Headers:")
            //print(self.imageManager.headers)
            //print("Subheaders:")
            //print(self.imageManager.subheaders)
            self.headers = self.imageManager.headers
            self.subs = self.imageManager.subheaders
            
            for head in self.headers {
                print("head: " + head)
                Task {
                                
                    do {
                        
                        
                        let imageParams = ImageParameters(prompt: head, resolution: .medium, responseFormat: .base64Json)
                        
                        
                            
                        let result = try await self.openAI.createImage(parameters: imageParams)
                        let generated = try self.openAI.decodeBase64Image(result.data[0].image)
                            
                        self.wait(for: 20)
                        self.imgs.append(generated)
                        
                    } catch {
                        
                        // Throws error if image generation does not work
                        
                        print("Error generating image: \(error)")
                    }
                    print("reload!")
                    
                    
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                self.table.reloadData()
            }
            
        }
        
        
        
        
        
    }
    
    func wait(for seconds: TimeInterval) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: seconds)
            semaphore.signal()
        }
        semaphore.wait()
        print("Waited for \(seconds) seconds.")
    }

    
    
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

}
*/
