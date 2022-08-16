//
//  ViewController.swift
//  RxPractice
//
//  Created by Mohamed osama on 16/08/2022.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    
    private lazy var loginStackView: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Login By RxSwift"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var userNameTft: UITextField = {
       let txt = UITextField()
        txt.placeholder = "enter your user name"
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .roundedRect
        return txt
    }()

    private lazy var passwordTft: UITextField = {
       let txt = UITextField()
        txt.isSecureTextEntry = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .roundedRect
        txt.placeholder = "password"
        return txt
    }()
    
    private lazy var loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginStackView)
        NSLayoutConstraint.activate([
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        loginStackView.addArrangedSubview(titleLabel)
        loginStackView.addArrangedSubview(userNameTft)
        loginStackView.addArrangedSubview(passwordTft)
        loginStackView.addArrangedSubview(loginButton)
        updateButtonUI()
        setBindings()
    }

    
    private func updateButtonUI() {
        loginButton.layer.cornerRadius = 12
        loginButton.clipsToBounds = true
    }
    
    private func setBindings(){
        userNameTft.rx.text.map{$0 ?? ""}.bind(to: viewModel.userNameSubject).disposed(by: disposeBag)
        passwordTft.rx.text.map{$0 ?? ""}.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        viewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map{$0 ? 1 : 0.5}.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        loginButton.rx.tap.bind { [weak self] _ in
            print("Login")
        }.disposed(by: disposeBag)
    }

}

class ViewModel{
    
    let userNameSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool>{
        return Observable.combineLatest(userNameSubject.asObservable(), passwordSubject.asObservable()).map({
            return $0.count >= 3 && $1.count >= 3
        })
    }
}
