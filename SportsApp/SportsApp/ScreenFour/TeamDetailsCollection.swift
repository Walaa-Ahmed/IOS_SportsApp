//
//  TeamDetailsCollection.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/3/21.
//  Copyright © 2021 Walaa. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


private let reuseIdentifier = "Cell"

class TeamDetailsCollection: UICollectionViewController {
    
    
    //back to eventLeagues.........
    @IBAction func backEventDetails(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }
    
    
    
    
        var eventData = EventDetails()
        var teamImage =  TeamsImage()
        var teamDetails = [TeamDetails]()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            print(teamImage.teamid)
            let requestData = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=" +  String (teamImage.teamid)
                request(requestData, method: .get).responseJSON { (myresponse) in
                switch myresponse.result {
                case .success:
                    print(myresponse.result)
                    let result = try? JSON(data: myresponse.data!)
                    print(result)
                    let resultArray = result!["teams"]
                    self.teamDetails.removeAll()
                    
                    for i in resultArray.arrayValue{
                        let teamName = i["strTeam"].stringValue
                        let teamAlternative = i["strAlternate"].stringValue
                        let teamLogo = i["strTeamLogo"].stringValue
                        let teamImg = i["strTeamBadge"].stringValue
                        let teamCountry = i["strCountry"].stringValue
                        
                        
                        var detailsTeam = TeamDetails()
                        detailsTeam.alternative = teamAlternative
                        detailsTeam.badge = teamImg
                        detailsTeam.country = teamCountry
                        detailsTeam.teamname = teamName
                        detailsTeam .logo = teamLogo
                        self.teamDetails.append(detailsTeam)
                       
                    }
                    self.collectionView.reloadData()
                    break;
                case .failure:
                    break
                }
            }
            
        }
        
        
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return teamDetails.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "team", for: indexPath)
            let  image:UIImageView = cell.viewWithTag(1) as! UIImageView
            let teamname:UILabel = cell.viewWithTag(2) as! UILabel
           
            let teamcountry:UILabel = cell.viewWithTag(4) as! UILabel
            let  teamalternative : UILabel = cell.viewWithTag(5) as! UILabel
          
            
            image.sd_setImage(with: URL(string: teamDetails[indexPath.row].badge), placeholderImage: UIImage(named: "teamsImage.jpg"))
           
            
            teamname.text = teamDetails[indexPath.row].teamname
            teamcountry.text = teamDetails[indexPath.row].country
            teamalternative.text = teamDetails[indexPath.row].alternative
            
            
            return cell
        }
        
        
        
        
    }

