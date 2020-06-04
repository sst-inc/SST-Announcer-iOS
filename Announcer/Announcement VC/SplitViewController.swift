//
//  SplitViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 4/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    let vc = Storyboards.content.instantiateInitialViewController() as! ContentViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        show(LoadingViewController(), sender: nil)
        
        self.preferredDisplayMode = .automatic
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
