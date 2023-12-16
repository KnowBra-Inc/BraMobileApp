//
//  BraRecogntionViewModelProtocol.swift
//  Bra image recognition
//
//  Created by dadDev on 12/16/23.
//

import Foundation

protocol BraRecogntionViewModelProtol {
    var title: String { get set }
    
    var resultText: String { get set }
    
    var buttonText: String {get}
    
    
    func handleSubToMLModel()
}
