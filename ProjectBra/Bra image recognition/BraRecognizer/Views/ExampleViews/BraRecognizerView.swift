//
//  BraRecognizerView.swift
//  Bra image recognition
//
//  Created by dadDev on 12/2/23.
//

import SwiftUI

struct BraRecognizerView: View {

    @State private var showSuccessScreen = false
      @State private var capturedImage: UIImage?

      var body: some View {
          NavigationView {
              VStack {
                  Button("Capture Picture") {
                      self.showSuccessScreen = true
                  }
                  .padding()
                  .foregroundColor(.white)
                  .background(Color.blue)
                  .cornerRadius(10)

                  NavigationLink(
                      destination: SuccessScreen(),
                      isActive: $showSuccessScreen,
                      label: { EmptyView() }
                  ).hidden()

                 
              }
              .navigationTitle("Capture App")
          }
      }
}

struct BraRecognizerView_Previews: PreviewProvider {
    static var previews: some View {
        BraRecognizerView()
    }
}
