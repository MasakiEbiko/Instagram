//
//  InputCommentViewController.swift
//  Instagram
//
//  Created by mba2408.spacegray kyoei.engine on 2024/11/05.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseFirestore

class InputCommentViewController: UIViewController {

    @IBOutlet weak var comment: UITextView!
    var docId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.text = ""
        // Do any additional setup after loading the view.
    }
    

    @IBAction func handleCancelButton(_ sender: Any) {
        // 先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlePostButton(_ sender: Any) {
        if let inputComment = comment.text, let user = Auth.auth().currentUser?.displayName {
            if inputComment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            var updateValue: FieldValue
            let val:String = "\(user) : \(inputComment)"
            // commentを追加する更新データを作成
            updateValue = FieldValue.arrayUnion([val])
            // commentsに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(self.docId)
            postRef.updateData(["comments": updateValue])
        }
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        // 投稿処理が完了したので先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
