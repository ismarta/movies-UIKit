//
//  EmptyUIView.swift
//  Movies
//
//  Created by Marta on 11/3/24.
//

import UIKit

class OverlayUIView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var reloadButtonPressed: (() -> Void)?

    class func createView() -> OverlayUIView {
        let view = UINib(nibName: String(describing: OverlayUIView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! OverlayUIView
        return view
    }

    @IBAction func reloadButtonPressed(_ sender: Any) {
        guard let reloadButtonPressed = reloadButtonPressed else { return }
        reloadButtonPressed()
    }
}

extension OverlayUIView {
    func customiseEmptyView() -> OverlayUIView {
        imageView.image = UIImage(named: "error")
        messageLabel.text = "No hay resultados"
        actionButton.isHidden = true
        return self
    }

    func customiseErrorView() -> OverlayUIView {
        imageView.image = UIImage(named: "error")
        messageLabel.text = "Ha ocurrido un error"
        actionButton.isHidden = false
        return self
    }
}
