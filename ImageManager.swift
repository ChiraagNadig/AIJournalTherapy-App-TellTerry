//

//  ViewController.swift

//  StringParseBitcampA

//

//  Created by Krish Thakker on 4/20/24.

//



import UIKit

import OpenAIKit //Package Link: https://github.com/marcodotio/OpenAIKit.git

import Alamofire



class ImageManager {

    private let aiManager = OpenAIManager()

    private var todoArr: [String] = []

    var headers: [String] = []

    var subheaders: [String] = []

    var promptArr: [String] = []


    // for image generation

    let openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: "sk-proj-2WoFCfVvcLqvrHq401aTT3BlbkFJ6XeVjr9ZK4wZklasC5YY"))

        

    

    //func processTodos(input: String){
    func processTodos(input: String, completion: @escaping (_ headers: [String], _ subs: [String]) -> Void) {
        
        let todoInput = "Limit your response to 5 items and 2 sentences each. 1 sentence should be short and main. The second should describe the activity. Do not include numbers, dashes, or new lines. Include exactly one space after each sentence. Do not include new lines. Give me a to-do list of activities that do not include writing and would help the following person' journal entry mentally:" + input

        aiManager.generateResponse(for: todoInput) { response in

            //print("Response: " + response)

            // Format string into an array

            self.todoFormatting(inputText: response)
            completion(self.headers, self.subheaders)

        }

    }



    

    func processPrompts(input: String){
        
        print("processPrompts")
        
        let promptInput = "Limit your response to 3 questions with 8 words each. Do not include numbers, dashes, or new lines. Include exactly one space after each sentence. Do not include new lines. Give me a list of journal prompts that would be helpful to and be relevant for the following person' journal entry:" + input

        aiManager.generateResponse(for: promptInput) { response in

//            print("Response: " + response)

            // Format string into an array

            self.promptFormatting(inputText: response)

        }

    }



    func todoFormatting(inputText: String){

        // Seperate sentences by period

        todoArr = inputText.components(separatedBy: ". ")

        todoArr = removeBackslashesAndNewlines(from: todoArr)

        //print(todoArr)

        // Iterates through array to find headers and subheaders

        for (index, element) in todoArr.enumerated() {

            if index == todoArr.count - 1 {

                // Handling the last element differently

                subheaders.append(element)

            } else if index % 2 == 0 {

                // Add elements with even indices to headers array

                headers.append(element + ".")

            } else {

                // Add elements with odd indices to subheaders array

                subheaders.append(element + ".")

            }

        }

        

        // Print arrays to check
//
//        print(headers)
//
//        print(subheaders)

    }

    

    func promptFormatting(inputText: String){

            // Seperate sentences by question mark

            promptArr = inputText.components(separatedBy: "? ")

            promptArr = removeBackslashesAndNewlines(from: promptArr)

            // print(promptArr)
        
            var newArr: [String] = []

            // Iterates through array to find headers and subheaders

            for (index, element) in promptArr.enumerated() {

                if index == promptArr.count - 1 {

                    // Handling the last element differently

                    newArr.append(element)

                } else {

                    newArr.append(element + "?")

                }

            }
            promptArr = newArr

            // Print arrays to check
            // print(promptArr)

        }


    func removeBackslashesAndNewlines(from strings: [String]) -> [String] {

        return strings.map { $0.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\n", with: "") }

    }



}
