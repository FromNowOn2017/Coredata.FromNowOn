//
//  ViewController.swift
//  CoreData.FromNowOn
//
//  Created by togashi yoshiki on 2018/02/21.
//  Copyright © 2018年 togashi yoshiki. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    
    //    MARK:配列
    //時間の配列
    var todoDeta = [""]
    //文字の配列
    var todoTask = [""]
    
    
    
    @IBOutlet weak var TableView: UITableView!
    
    //ボタンを押すとアラート表示をしコアデータに文字と時間を登録する
    @IBAction func add(_ sender: UIButton) {
        // テキストフィールド付きアラート表示
        let alert = UIAlertController(title: "ToDo", message: "文字を入力してください。", preferredStyle: .alert)
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    //        AppDelegateのインスタンスを用意しておく
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //        エンティティを操作するためのオブジェクト
                    let viewContext = appDelegate.persistentContainer.viewContext
                    //        ToDoエンティティオブジェクトを作成
                    let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
                    //        ToDoエンティティにレコード(行)を挿入するためのオブジェクトを作成
                    let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
                    //        追加したいデータ(txtTitleに入力された文字)のセット
                    if textField.text! == "" || textField.text! == nil{
                        print("nilが入っています。")
                    }else{
                        newRecord.setValue(textField.text!, forKey: "todotitle")
                        newRecord.setValue(Date(), forKey: "tododeta")
                        
                        
                        //        レコード(行)の即時保存
                        do{
                            try viewContext.save()
                        }catch{
                        }
                        print("右の文字が入る\(textField.text!)")
                        
                        
                        self.todoTask.append(textField.text!)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                        //Stringにしたい
                        let detastring:String = formatter.string(from: Date())
                        
                        self.todoDeta.append(detastring)
                        self.TableView.reloadData()
                        
                    }
                }
            }
        })
        alert.addAction(okAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text=todoTask[indexPath.row]
        return cell
    }
    
    
    
    
    //    削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
            if editingStyle == .delete {
              
                //        AooDelegateを使う用意をしておく
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                //        エンティティを操作するためのオブジェクトを作成
                let viewContext = appDelegate.persistentContainer.viewContext
                //        どのエンティティからデータを取得してくるか設定
                let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
                do{
                    
                    //            削除するデータを取得
                    let fetchResults = try viewContext.fetch(query)
                    //            削除するデータを取得
                    for result : AnyObject in fetchResults {
                        let deta: NSDate! = result.value(forKey: "tododeta") as! NSDate
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                        //Stringにしたい
                        let detastring:String = formatter.string(from: deta as Date)
                        ///        一行ずつ削除
                        if detastring == todoDeta[indexPath.row]{
                            //        一行ずつ削除
                            let record = result as! NSManagedObject
                            viewContext.delete(record)
                        }
                    }
                    //            削除した状態を保存(処理の確定)
                    try viewContext.save()
                    todoTask.remove(at: indexPath.row)
                    todoDeta.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.TableView.reloadData()
                }catch{
                }
            }
        
    }
    
    
//    Coredataから全ての中身を取り出し、各変数に保存
    func read(){
        todoTask = []
        todoDeta = []
        //        AppDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do{
            query.sortDescriptors = [NSSortDescriptor(key: "tododeta",ascending: false)]
            //        データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //        ループで一行ずつ表示
            for result : AnyObject in fetchResults {
                //                一行ずつのデータを取得する
                //                MARK:todoTextのアペンド
                var todoText:String = ""
                if result.value(forKey: "todotitle") == nil {
                    print("ToDoなし")
                }else{
                    todoText = result.value(forKey: "todotitle") as! String
                    let deta: NSDate! = result.value(forKey: "tododeta") as! NSDate
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                    //Stringにしたい
                    let detastring:String = formatter.string(from: deta as Date)
                    todoTask.append(todoText)
                    todoDeta.append(detastring)
                    
                    print("todotitleは:\(todoText)")
                    print("tododetaは:\(todoDeta)")
                }
            }
        }catch{
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        read()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

