//
//  QuizViewController.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 24/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class QuizViewController: UIViewController {

    @IBOutlet weak var progessTimeBar: UIProgressView!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTable: UITableView!
    var count = 1.0
    var countQuestion = 0
    var point = 0
    var timer: Timer?
    var artists: [JSON] = []
    var choose3artists: ArraySlice<JSON> = []
    var artist_id = JSON()
    var snippet = JSON()
    var playerNameData: Player = Player(name: "", scores: [])
    var playersData: [Player] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        questionTable.delegate = self
        questionTable.dataSource = self
        let nib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        questionTable.register(nib, forCellReuseIdentifier: "QuestionTableViewCell")
        createQuestion()

    }
    
    @objc func countdown (){
        if count > 0 {
            count -= 0.1
            progessTimeBar.progress = Float(count)
        }else {
            
            if countQuestion < 10 {
                count = 1.0
                createQuestion()
            }else {
                timer?.invalidate()
                timer = nil
                createAlertFinal() 
            }
        }
    }
    
    func createQuestion() {
        timer?.invalidate()
        timer = nil
        questionTable.isHidden = true
        questionLabel.isHidden = true
        choose3artists = artists.choose(3)
        let chose1artist = choose3artists.choose(1).first?["artist"]["artist_id"]
        guard let choose1 = chose1artist else { return }
        artist_id = choose1
        let params = Params(apikey: "eeac75835283f44d753ce8024214a0d5")
        AF.request("https://api.musixmatch.com/ws/1.1/track.search?f_artist_id=\(choose1)",parameters: params).responseDecodable(of: JSON.self) {
            response in
            
            guard let json = response.value else {return}
            if (json["message"]["header"]["status_code"] == 200 && json["message"]["body"]["track_list"].arrayValue.count > 0){
                let song = json["message"]["body"]["track_list"].arrayValue
                let track_id = song.choose(1).first?["track"]["track_id"]
                guard let track_id1 = track_id else {return}
                    AF.request("https://api.musixmatch.com/ws/1.1/track.snippet.get?track_id=\(track_id1)",parameters: params).responseDecodable(of: JSON.self) {
                        response in
                        guard let json = response.value else {return}
//                        control if snippet is empty
                        if (json["message"]["header"]["status_code"] == 200 && String(describing: json["message"]["body"]["snippet"]["snippet_body"]) != ""){
                            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
                            self.count = 1.0
                            self.questionLabel.text = String(describing: json["message"]["body"]["snippet"]["snippet_body"])
                            self.countQuestion += 1
                            self.numberQuestionLabel.text = "Question \(self.countQuestion)/10"
                            self.questionTable.reloadData()
                            self.questionTable.isHidden = false
                            self.questionLabel.isHidden = false
                        }else {
                            self.createQuestion()
                        }
                    }
                
            }else{
                self.createQuestion()
            }
        }
    }
    func createAlertFinal() {
        let dialogMessage = UIAlertController(title: "Punteggio Finale", message: String(describing: point), preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.playerNameData.scores.append(self.point)
            self.playerNameData.scores = self.playerNameData.scores.sorted(by: {$0>$1})
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.playerNameData), forKey: "Player")
            
            guard let index = self.playersData.firstIndex(where: { $0.name == self.playerNameData.name }) else {
                self.playersData.append(self.playerNameData)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.playersData), forKey: "PlayersScores")
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.playersData.remove(at: index)
            self.playersData.append(self.playerNameData)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.playersData), forKey: "PlayersScores")
            self.navigationController?.popToRootViewController(animated: true)
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
}
