//
//  RankingViewController.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 24/12/21.
//

import UIKit

class RankingViewController: UIViewController {
    var playersScores = UserDefaults.standard.value(forKey: "PlayersScores") as? Data
    lazy var playersData = try? PropertyListDecoder().decode([Player].self, from: playersScores ?? Data())
    var array = [ScorePlayer]()
    @IBOutlet weak var rankingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        playersData?.forEach({ for i in $0.scores { array.append(ScorePlayer(name: $0.name, score: i))}})
        array = array.sorted(by: {$0.score > $1.score})
        rankingTableView.dataSource = self
        rankingTableView.delegate = self
        let nib = UINib(nibName: "PlayerScoresTableViewCell", bundle: nil)
        rankingTableView.register(nib, forCellReuseIdentifier: "PlayerScoresTableViewCell")
    }

}
