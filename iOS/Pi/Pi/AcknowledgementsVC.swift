//
//  AcknowledgementsVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/18/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class AcknowledgementsVC: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagePath = Bundle.main.path(forResource: "acknowledgements", ofType: "html")
        let pageURL = URL(fileURLWithPath: pagePath!)
        
        let request = URLRequest(url: pageURL)
        self.webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
