//
//  RankingViewControllerExtension.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 24/12/21.
//

import Foundation
import UIKit

extension RankingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerScoresTableViewCell", for: indexPath) as! PlayerScoresTableViewCell
            cell.positionLabel?.text = String(describing: indexPath.row + 1)
        cell.playerNameLabel?.text = String(describing: array[indexPath.row].name)
        cell.scoreLabel?.text = String(describing: array[indexPath.row].score)
            return cell
    }
    
    
}
