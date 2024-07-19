//
//  LoginViewController.swift
//  BitcampA
//
//  Created by Chiraag Nadig on 4/21/24.
//

import UIKit

import LocalAuthentication



class LoginViewController: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    let color1 = UIColor(hex: 0x330066) // darkPurple color
    let color2 = UIColor(hex: 0xE6E6FA)



    override func viewDidLoad() {

        super.viewDidLoad()
        
        setupGradient()

        // Do any additional setup after loading the view.

    }
    
    func setupGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    

    @IBAction func didTapLoginBtn(_ sender: Any) {

        authenticate()

    }

    

    func authenticate() {

        let context = LAContext()

        var error: NSError? = nil

      if        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

       let reason = "Identify yourself!"

       context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,

                              localizedReason: reason) {

           [weak self] success, authenticationError in

           DispatchQueue.main.async {

              guard success, error == nil else{

              //Authentication failed, prompt an error message to the

              //user

             return

           }

       //Authentication successful! Proceed to next app screen.

       self?.performSegue(withIdentifier: "toHome", sender: nil)

      }

     }

    } else {

    //No biometrics available

    let alert = UIAlertController(title: "Unavailable", message: "FaceID Auth not available", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

    present(alert, animated: true)

    }

    }





}
