//
//  ExampleCVisionView.swift
//  Bra image recognition
//
//  Created by dadDev on 12/16/23.
//

import Foundation
import SwiftUI
import Vision
import CoreML

// Model Protocol
protocol ImageRecognitionModel {
    func recognizeImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void)
}

// ViewModel
class ImageRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String?
    @Published var errorMessage: String?

    var model: ImageRecognitionModel

    init(model: ImageRecognitionModel) {
        self.model = model
    }

    func recognizeImage(_ image: UIImage) {
        model.recognizeImage(image) { recognizedText, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    self.recognizedText = recognizedText
                }
            }
        }
    }
}

// Core ML Model Implementation
class CoreMLImageRecognitionModel: ImageRecognitionModel {
    func recognizeImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let model = try? VNCoreMLModel(for: FoodClassifier().model) else {
            completion(nil, NSError(domain: "ImageRecognition", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model loading failed."]))
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                completion(nil, NSError(domain: "ImageRecognition", code: 2, userInfo: [NSLocalizedDescriptionKey: "No results found."]))
                return
            }

            completion(topResult.identifier, nil)
        }

        guard let ciImage = CIImage(image: image) else {
            completion(nil, NSError(domain: "ImageRecognition", code: 3, userInfo: [NSLocalizedDescriptionKey: "Image conversion failed."]))
            return
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)

        do {
            try handler.perform([request])
        } catch {
            completion(nil, error)
        }
    }
}

// SwiftUI View
struct ContentView: View {
    @StateObject private var viewModel = ImageRecognitionViewModel(model: CoreMLImageRecognitionModel())
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onTapGesture {
                    // Logic to pick an image from the gallery or camera
                    // Set the selectedImage variable with the chosen image
                }

            Button("Recognize Image") {
                if let selectedImage = selectedImage {
                    viewModel.recognizeImage(selectedImage)
                }
            }

            if let recognizedText = viewModel.recognizedText {
                Text("Recognized Text: \(recognizedText)")
            }

            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .padding()
    }
}
