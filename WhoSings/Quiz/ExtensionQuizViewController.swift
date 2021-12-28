//
//  ExtensionQuizViewController.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 24/12/21.
//

import Foundation
import UIKit

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choose3artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        let chose1artist = choose3artists[indexPath.row]["artist"]
        
        cell.artistData = chose1artist["artist_id"]
        cell.singerLabel.text = String(describing: chose1artist["artist_name"])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.progessTimeBar.progress = 0
        timer?.invalidate()
        timer = nil
        if (countQuestion >= 10) {
            if ( artist_id == choose3artists[indexPath.row]["artist"]["artist_id"]){
                point += 10
            }else{
                point -= 2
            }
            createAlertFinal() 
        }else {
            var title = ""
            var message = ""
            if ( artist_id == choose3artists[indexPath.row]["artist"]["artist_id"]){
                title = "Risposta esatta"
                message = "+ 10 punti"
                point += 10
            }else{
                title = "Risposta sbagliata"
                message = "- 2 punti"
                point -= 2
            }
            let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.createQuestion()
             })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        
    }
    
}
