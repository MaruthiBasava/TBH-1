//
//  SecondIntroViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import RxSwift

class SecondIntroViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let service = AuthService()
        service.authenticate()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { success in
                print(success)
            }, onError: { error in
                print(error)
            }).addDisposableTo(disposeBag)
    }
}
