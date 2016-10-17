//
//  ChooseTargetLanguagesTC.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit

class ChooseTargetLanguagesTC: UITableViewController {
    
    var languages:[Language]!
    var choosed:[Language]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Choose target languages"
        
        var langs = Language.getAllLanguages()
        if let lan = TranslateManager.sharedInstance().sourceLang {
            if let idx = langs.index(of: lan) {
                langs.remove(at: idx)
            }
        }
        self.languages = langs
        self.choosed = [Language]()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: UIBarButtonItemStyle.done, target: self, action: #selector(ChooseTargetLanguagesTC.startTranslate))
    }
    
    func startTranslate() {
        if choosed.count == 0 {
            return
        }
        let tm = TranslateManager.sharedInstance()
        tm.targetLangs = choosed
        _ = tm.startTranslate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangCell", for: indexPath)

        let lan = self.languages[indexPath.row]
        cell.textLabel?.text = lan.getFullName()
        
        cell.accessoryType = self.choosed.contains(lan) ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lan = self.languages[indexPath.row]
        if choosed.contains(lan) {
            if let idx = choosed.index(of: lan){
                choosed.remove(at: idx)
            }
        }
        else {
            choosed.append(lan)
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
