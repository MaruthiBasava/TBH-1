//
//  FirstIntroViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

class FirstIntroViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func next(_ sender: UIButton) {
        let parentVc = parent as! IntroViewController
        parentVc.setViewControllers([parentVc.pages[1]], direction: UIPageViewControllerNavigationDirection.forward,
                                    animated: true, completion: nil)
    }
}
