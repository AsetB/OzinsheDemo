//
//  ImageZoom.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 04.02.2024.
//

import UIKit

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}

extension UIImageView {
    private var originalTransform: CGAffineTransform {
        return CGAffineTransform.identity
    }

    private var zoomedTransform: CGAffineTransform {
        let scale: CGFloat = 2.0
        return originalTransform.scaledBy(x: scale, y: scale)
    }

    func enableDoubleTapZoom() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        isUserInteractionEnabled = true
        addGestureRecognizer(doubleTapGesture)
    }

    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.transform == self.originalTransform {
                self.transform = self.zoomedTransform
            } else {
                self.transform = self.originalTransform
            }
        }
    }
}



