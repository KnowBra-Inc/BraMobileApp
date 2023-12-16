//
//  ViewController.swift
//  Bra image recognition
//
//  Created by dadDev on 12/2/23.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {

    var vml: BraRecogntionViewModel = BraRecogntionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        view.addSubview(navbarConfig())
        view.addSubview(buttonConfig())
        
    }

    
    func navbarConfig() -> UINavigationBar {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: view.frame.size.width, height: 44))
              navBar.backgroundColor = UIColor.green

              // Create a navigation item
        let navItem = UINavigationItem(title: vml.title)

              // Set navigation item to navigation bar
              navBar.items = [navItem]
        
        return navBar
    }

    func buttonConfig() -> UIButton {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        // Set button frame and position it at the bottom of the screen
        submitButton.frame = CGRect(x: 0, y: view.frame.size.height - 150, width: view.frame.size.width, height: 50)

        // Optional: Customize button appearance
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(subButton), for: .touchUpInside)

          
        return submitButton
    }
    
    @objc func subButton() {
        var navToVC = vml.navToSwiftuiScreen()
        present(navToVC, animated: true)
    }
}

