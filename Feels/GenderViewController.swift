//
//  GenderViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import RxSwift

class GenderViewController: UIViewController {
    private let maleCode = 0
    private let femaleCode = 1
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectBoy(_ sender: UIButton) {
        signUpWithPhone(gender: maleCode)
    }
    
    @IBAction func selectGirl(_ sender: UIButton) {
        signUpWithPhone(gender: femaleCode)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func signUpWithPhone(gender: Int!) {
        let service = AuthService()
        service.authenticate(genderCode: gender)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { success in
                self.goToMainApp()
            },
            onError: { error in
                print(error)
                self.showGenericError()
            }).addDisposableTo(disposeBag)
    }
    
    private func goToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true)
    }
}
