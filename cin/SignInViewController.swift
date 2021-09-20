//
//  ViewController.swift
//  cin
//
//  Created by user on 20.09.2021.
//

import UIKit
import Alamofire
import SwiftyJSON


class SignInViewController: UIViewController {
    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    let userDef = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(" You token is: \(userDef.value(forKey: "token"))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDef.value(forKey: "token") != nil {
            performSegue(withIdentifier: "auth", sender: nil)
        }
    }
    
    @IBAction func auth(_ sender: Any) {
        guard !inputLogin.text!.isEmpty else {return showAlertDialog(message: "Введите логин")}
        guard !inputPassword.text!.isEmpty else {return showAlertDialog(message: "Введите пароль")}
        let url = "http://recipe.madwsr.ru/signin?login=\(inputLogin.text!)&pass=\(inputPassword.text!)"
        
        
        
        AF.request(url, method: .post).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                //print(json["notice"]["token"].stringValue)
            let jsonToken = json["notice"]["token"].stringValue
                self.userDef.setValue(jsonToken,forKey: "token")
            case .failure(let error):
                self.showAlertDialog(message: error.localizedDescription)
            }
        }
        performSegue(withIdentifier: "auth", sender: nil)
    }
    // функция отображения алета, принимаетсообщение
        func showAlertDialog(message: String){
            //Отображение алерта с заголовком и текстом
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            // добавляем кнопку ОК
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //Отображаем алерт
            self.present(alert, animated: true, completion: nil)
        }
}

