import UIKit
import CoreData
import OpenAIKit

class LoadingViewController: UIViewController {

    private let todo = TodoViewController()
    var timer: Timer?
    var elapsedTime: TimeInterval = 0
    let totalTime: TimeInterval = 18 // Total time for the timer
    var bigBoyString = ""
    private let imageManager = ImageManager()
    var prompts = [String]()

    let openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: "sk-proj-2WoFCfVvcLqvrHq401aTT3BlbkFJ6XeVjr9ZK4wZklasC5YY"))
    
    var tableData: [TableRowData] = []
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA)


    @IBOutlet var sensei: UIImageView!
    
    @IBOutlet var progressView: UIProgressView!
    
    
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

                // Start the bounce animation
        
        
        // Start the timer to update progress
        startTimer()
        // Save
        loadData()
        
        setupGradient()
        
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateImageUpDown()
    }
    
    func animateImageUpDown() {

                // Define the animation duration and options

                let duration: TimeInterval = 1.0

                let options: UIView.AnimationOptions = [.autoreverse, .repeat]

                

                // Define the starting position (origin) of the image view

                let startingY = sensei.frame.origin.y

                

                // Calculate the end position (destination) of the image view

                let endY = startingY + 100 // Adjust this value to change the distance

                

                // Perform the animation

                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {

                    // Update the image view's frame to move it up and down

                    self.sensei.frame.origin.y = endY

                }, completion: nil)

            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YourSegueIdentifier" {
            let otherView = segue.destination as! TodoViewController
            otherView.tableData = self.tableData
        }
    }
    
    // added
    func loadData() {
        makeBigBoyString { bigBoyString in
            self.imageManager.processTodos(input: bigBoyString) { headers, subs in
                self.loadImages(headers: headers, subs: subs)
            }
        }
    }
    
    // added
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
                    }
                } catch {
                    print("Error generating image: \(error)")
                }
            }
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
        
    
   
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
   
    @objc func updateProgress() {
        elapsedTime += 0.1 // Increase elapsed time by 0.1 seconds
       
        // Calculate progress based on elapsed time and total time
        let progress = Float(elapsedTime / totalTime)
       
        // Update the progress bar
        progressView.setProgress(progress, animated: true)
       
        // Check if timer has finished
        if elapsedTime >= totalTime {
            timer?.invalidate() // Stop the timer
            performSegue(withIdentifier: "YourSegueIdentifier", sender: self) // Perform segue
        }
    }
   
}
