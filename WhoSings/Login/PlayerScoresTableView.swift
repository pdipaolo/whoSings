//
//  PlayerScoresTableView.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 21/12/21.
//

import Foundation
import UIKit

extension Login: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playerName = playerNameData else {
            return 0
        }
        return playerName.scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerScoresTableViewCell", for: indexPath) as! PlayerScoresTableViewCell
        guard let playerName = playerNameData else {
            return cell
        }
        cell.positionLabel?.text = String(describing: indexPath.row + 1)
        cell.playerNameLabel?.text = playerName.name
        cell.scoreLabel?.text = String(describing: playerName.scores[indexPath.row])
        return cell
    }
    
    
}
