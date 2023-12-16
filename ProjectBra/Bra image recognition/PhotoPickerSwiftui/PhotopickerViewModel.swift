//
//  PhotopickerViewModel.swift
//  Bra image recognition
//
//  Created by dadDev on 12/16/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class PhotopickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiimage = UIImage(data: data) {
                    selectedImage = uiimage
                    return
                }
            }
        }
    }
}
