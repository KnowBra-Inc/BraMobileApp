//
//  ViewController.swift
//  Bra image recognition
//
//  Created by dadDev on 12/2/23.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var vml: BraRecogntionViewModel = BraRecogntionViewModel()
    
    
      let imagePicker = UIImagePickerController()
    var  imageView = UIImageView()
      
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
   
        setupUI()
        
        
        
    }
    
    private func setupUI() {
         setupImageView()
         navbarConfig()
         buttonConfig()
     }
    
    
    func setupImageView() {
        // Create UIImageView
        imageView = UIImageView(image: UIImage(systemName: "photo") )
        imageView.contentMode = .scaleAspectFit  // Set the content mode as needed
        
        view.addSubview(imageView)
        
        // Set up constraints to center the UIImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),  // Set the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 200)  // Set the height as needed
        ])
        // Add the UIImageView to the view hierarchy
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            guard let convertCIImage = CIImage(image: userPickImage) else {
                fatalError("cannot conver image")
            }
            vml.detect(image: convertCIImage, inputModel: FoodClassifier().model)
           

            imageView.image = userPickImage
        }
        navbarConfig()
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    func navbarConfig()  {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: view.frame.size.width, height: 44))
        navBar.backgroundColor = vml.barColor

              // Create a navigation item
        let navItem = UINavigationItem(title: vml.title)

              // Set navigation item to navigation bar
              navBar.items = [navItem]
        
        view.addSubview(navBar)
    }

    func buttonConfig()  {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle(vml.buttonText, for: .normal)
        // Set button frame and position it at the bottom of the screen
        submitButton.frame = CGRect(x: 100, y: view.frame.size.height - 150, width: view.frame.size.width - 150, height: 50)

        // Optional: Customize button appearance
        submitButton.backgroundColor = UIColor.green
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(subButton), for: .touchUpInside)

          
        view.addSubview(submitButton)
    }
    
    @objc func subButton() {
//        var navToVC = vml.navToSwiftuiScreen()
//        present(navToVC, animated: true)
        let actionSheet = UIAlertController(title: "Photo Source", message: "choose your source", preferredStyle: .actionSheet)
                      
                      actionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (UIAlertAction) in
                          self.imagePicker.sourceType = .savedPhotosAlbum
                          self.present(self.imagePicker, animated: true, completion: nil)
                      }))
                      
                      actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
                          self.imagePicker.sourceType = .camera
                          self.present(self.imagePicker, animated: true, completion: nil)
                      }))
                      
                     
                      
                      
                      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                      self.present(actionSheet, animated: true, completion: nil)
    }
}

