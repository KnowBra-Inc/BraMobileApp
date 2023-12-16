//
//  BraRcognizerViewModels.swift
//  Bra image recognition
//
//  Created by dadDev on 12/2/23.
//

import Foundation
import SwiftUI
import Foundation
import UIKit
import Vision
import CoreML

class BraRecogntionViewModel {
    
    public var title: String = "Company title here"
    
    public var resultText: String = ""
    
   public var buttonText: String = "Submit"
    public var barColor: UIColor = .gray
   
    
    
}

//MARK: - Button config sections
extension BraRecogntionViewModel {
     func navToSwiftuiScreen() -> UIViewController {
        var braScreen = PhotoPickerView()//ContentView()
        var hostingController = UIHostingController(rootView: braScreen)
        
        return hostingController
    }
}

//MARK: - viewModelProtocol methods
extension BraRecogntionViewModel: BraRecogntionViewModelProtol {
     func handleSubToMLModel() {
        //TODO: add method here
         
    }
}


//MARK: - detect image model and images
extension BraRecogntionViewModel {
     func detect(image: CIImage, inputModel: MLModel) {
          guard let model = try? VNCoreMLModel(for: inputModel) else {
              fatalError("cannot import model")
          }
          
          let request = VNCoreMLRequest(model: model) { (request, error) in
              guard let classification = request.results?.first as? VNClassificationObservation else {
                  fatalError("could not class")
              }
              self.title = classification.identifier.capitalized
              print("GOKU: \(classification.identifier.capitalized)")
              if request.results != nil {
                  self.barColor = .green
                 // navigationController.navigationBar.barTintColor = UIColor.green
                  //navigationController.title = classification.identifier.capitalized
              } else {
                  self.barColor = .red
              }
          } // end of closure
          
          let handler = VNImageRequestHandler(ciImage: image)
          do {
              try handler.perform([request])
          } catch {
              print(error)
          }
          
      } // end of detect func
}
