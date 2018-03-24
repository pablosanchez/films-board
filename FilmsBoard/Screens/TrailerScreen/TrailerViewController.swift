//
//  TrailerViewController.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerVideo: WKWebView!
    
    
    private let viewModel: TrailerViewModel
    
    
    init(viewModel: TrailerViewModel)
    {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://www.youtube.com/embed/\(self.viewModel.trailerVideoExtension())")
        let request = URLRequest(url: url!)

        
        trailerVideo.load(request)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTrailer(_ sender: Any) {
        self.viewModel.closeTrailer()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
