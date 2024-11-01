//
//  LoginViewController.swift
//  Instagram
//
//  Created by mba2408.spacegray kyoei.engine on 2024/10/31.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var displayName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //ログインボタン処理
    @IBAction func handleLogin(_ sender: Any) {
        if let vAddress = mailAddress.text, let vPassword = password.text {
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if vAddress.isEmpty || vPassword.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: vAddress, password: vPassword) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                SVProgressHUD.dismiss()
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    //アカウント作成ボタン処理
    @IBAction func handleCreateAccount(_ sender: Any) {
        if let vAddress = mailAddress.text, let vPassword = password.text, let vDisplayName = displayName.text {
            
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if vAddress.isEmpty || vPassword.isEmpty || vDisplayName.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: vAddress, password: vPassword) { authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "アカウント作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                SVProgressHUD.show()

                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = vDisplayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        SVProgressHUD.dismiss()
                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
