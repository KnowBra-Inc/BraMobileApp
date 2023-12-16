//
//  BraRcognizerViewModels.swift
//  Bra image recognition
//
//  Created by dadDev on 12/2/23.
//

import Foundation
import SwiftUI
import UIKit

class BraRecogntionViewModel {
    
    public var title: String = "Company title here"
    
    public var resultText: String = ""
    
   public var buttonText: String = "Submit"
    
   
    
    
}

//MARK: - Button config sections
extension BraRecogntionViewModel {
     func navToSwiftuiScreen() -> UIViewController {
        var braScreen = ContentView()
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
