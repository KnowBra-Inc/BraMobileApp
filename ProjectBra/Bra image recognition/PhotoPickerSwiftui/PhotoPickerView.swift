//
//  PhotoPickerView.swift
//  Bra image recognition
//
//  Created by dadDev on 12/16/23.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Vision
import CoreML
import AVFoundation

struct PhotoPickerView: View {
    
    @StateObject private var vm = PhotopickerViewModel()
    @StateObject private var viewModel = ImageRecognitionViewModel(model: CoreMLImageRecognitionModel())
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        if let image = vm.selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        PhotosPicker(selection: $vm.imageSelection, matching: .images) {
            Text("Open photo ")
                .foregroundColor(.blue)
        }
        
        Button("Recognize Image") {
            if let selectedImage = vm.selectedImage {
                viewModel.recognizeImage(selectedImage)
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}
