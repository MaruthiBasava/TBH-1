//
//  IntroViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController {
    var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        pages.append(storyboard.instantiateViewController(withIdentifier: "intro_1_vc"))
        pages.append(storyboard.instantiateViewController(withIdentifier: "intro_2_vc"))
        
        self.view.backgroundColor = UIColor.white
        pages[0].view.backgroundColor = UIColor.white
        pages[1].view.backgroundColor = UIColor.white
        
        delegate = self
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension IntroViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard pages.count != nextIndex else {
            return nil
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension IntroViewController: UIPageViewControllerDelegate {
    
}
