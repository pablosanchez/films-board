//
//  TrailerViewController.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerVideo: WKWebView!

    private var progressIndicator: MBProgressHUD!  // Loading indicator

    private let viewModel: TrailerViewModel

    init(viewModel: TrailerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestData()
    }
    
    @IBAction func closeTrailer(_ sender: Any) {
        self.viewModel.closeTrailer()
    }
}

extension TrailerViewController {

    private func requestData() {
        self.progressIndicator = MBProgressHUDBuilder.makeProgressIndicator(view: self.view)
        self.viewModel.getTrailer()
    }
}

extension TrailerViewController: TrailerViewModelDelegate {

    // MARK: TrailerViewModelDelegate methods

    func trailerViewModel(_ viewModel: TrailerViewModel, didGetUrl url: URL) {
        let request = URLRequest(url: url)
        self.progressIndicator.hide(animated: true)
        self.trailerVideo.load(request)
    }

    func trailerViewModel(_ viewModel: TrailerViewModel, didGetError error: String) {
        self.progressIndicator.hide(animated: true)
        SCLAlertViewBuilder()
            .setTitle("Aviso")
            .setSubtitle(error)
            .setCloseButtonTitle("Ok")
            .show()
    }
}
