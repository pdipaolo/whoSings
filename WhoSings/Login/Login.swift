//
//  ViewController.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 19/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Login: UIViewController {
    var player = UserDefaults.standard.value(forKey: "Player") as? Data
    lazy var playerNameData = try? PropertyListDecoder().decode(Player.self, from: player ?? Data())
    var playersScores = UserDefaults.standard.value(forKey: "PlayersScores") as? Data
    lazy var playersData = try? PropertyListDecoder().decode([Player].self, from: playersScores ?? Data())
    var artists: [JSON] = []
    
    
    @IBOutlet weak var playerScoreTableView: UITableView!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var saveNameButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func saveButton(_ sender: UIButton){
        guard let name = playerNameTextField.text else {
            return
        }
        
        guard let index = playersData?.firstIndex(where: {$0.name == name}) else {
            let newPlayer = Player(name: name.capitalized, scores: [])
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newPlayer), forKey: "Player")
            player = UserDefaults.standard.value(forKey: "Player") as? Data
            playerNameData = try? PropertyListDecoder().decode(Player.self, from: player ?? Data())
            enableButton(value: false)
            playerScoreTableView.reloadData()
            return
        }
        let newPlayer = Player(name: name.capitalized, scores: (playersData?[index].scores)!)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(newPlayer), forKey: "Player")
        player = UserDefaults.standard.value(forKey: "Player") as? Data
        playerNameData = try? PropertyListDecoder().decode(Player.self, from: player ?? Data())
        enableButton(value: false)
        playerScoreTableView.reloadData()

    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "Player")
        playerScoreTableView.reloadData()
        enableButton(value: true)
        playerNameTextField.text = ""
    }
    
    @IBAction func playerNameTextField(_ sender: UITextField) {
        guard let playerNameText = playerNameTextField.text else {
            return
        }
        if (!playerNameText.isEmpty || playerNameText != ""){
            saveNameButton.isEnabled = true
            saveNameButton.isHidden = false
        }else {
            saveNameButton.isHidden = true
            saveNameButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singerList()
        setupTable()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        player = UserDefaults.standard.value(forKey: "Player") as? Data
        playerNameData = try? PropertyListDecoder().decode(Player.self, from: player ?? Data())
        guard let playerName = playerNameData else {
            return
        }
        
        playerScoreTableView.reloadData()
        playerNameTextField.text = playerName.name
        enableButton(value: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playQuiz" {
                let controller = segue.destination as! QuizViewController
                controller.artists = artists
                guard let playerName = playerNameData else {
                    return
                }
            
            controller.playerNameData = playerName
            guard let playersData = playersData else {
                return
            }
            controller.playersData = playersData
        }
    }
    
    func enableButton (value: Bool){
        playerScoreTableView.isHidden = value
        playerNameTextField.isEnabled = value
        playButton.isHidden = value
        logoutButton.isHidden = value
        saveNameButton.isEnabled = !value
        saveNameButton.isHidden = !value
    }
    
    func setupTable(){
        playerScoreTableView.delegate = self
        playerScoreTableView.dataSource = self
        let nib = UINib(nibName: "PlayerScoresTableViewCell", bundle: nil)
        playerScoreTableView.register(nib, forCellReuseIdentifier: "PlayerScoresTableViewCell")
    }
    
    func singerList(){
        AF.request("https://api.musixmatch.com/ws/1.1/chart.artists.get?page=1&page_size=100&country=it",parameters: params).responseDecodable(of: JSON.self) {
            response in
            guard let json = response.value else {return}
            self.artists = json["message"]["body"]["artist_list"].arrayValue
            self.playButton.isEnabled = true
        }
    }
}

