//
//  LeaguesTableView.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/24/21.
//  Copyright © 2021 Walaa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class LeaguesTableView: UITableViewController {
    var sport = SportDetails()
    var arr_all_legues = [LeagueDetails]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leagues"
        

        let requestData = "https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?s=" + sport.name
        request(requestData, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                
                let result = try? JSON(data: myresponse.data!)
                
                let resultArray = result!["countrys"]
                self.arr_all_legues.removeAll()
                
                for i in resultArray.arrayValue{
                    let leagueName = i["strLeague"].stringValue
                    let leageImage = i["strBadge"].stringValue
                    let leagueYoutube = i["strYoutube"].stringValue
                    let leageId = i["idLeague"].intValue
                    
                    let Leagues = LeagueDetails()
                    Leagues.leaugename = leagueName
                    Leagues.leagueImage = leageImage
                    Leagues.leagueUrlButton = leagueYoutube
                    Leagues.leagueId = leageId
                    
                    // print all url youtube
                    print(Leagues.leagueUrlButton)
                    self.arr_all_legues.append(Leagues)
                    
                    self.tableView.reloadData()
                    
                }
                
            case .failure:
                break
            }
            
            
        }
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return arr_all_legues.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arr_all_legues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  img:UIImageView = cell.viewWithTag(1) as! UIImageView
        title.text = arr_all_legues[indexPath.row].leaugename
        img.sd_setImage(with: URL(string: arr_all_legues[indexPath.row].leagueImage), placeholderImage: UIImage(named: "league.jpg"))
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // useing accessoryButton for link to youtube
  
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
            if let url = NSURL(string: "http://" + arr_all_legues[indexPath.row].leagueUrlButton){
                UIApplication.shared.openURL(url as URL)
                print(url)
            }
    }
    
    
    
    // move to events of this league.....
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventLeagueScreen = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsView
        eventLeagueScreen.leagueEvent = arr_all_legues[indexPath.row]
        
        self.present(eventLeagueScreen  as! UIViewController, animated: true, completion: nil)
        print(arr_all_legues[indexPath.row].leagueId)
        print("Cell is pressed")
       
        
        
    }
}

/*
// https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=4328 //api for strBadge & strYoutube & strLeague 
//https://www.thesportsdb.com/api/v1/json/1/all_leagues.php //api for id_sport & strLeague
*/
