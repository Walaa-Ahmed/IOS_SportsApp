//
//  EventsView.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/27/21.
//  Copyright © 2021 Walaa. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class EventsView: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    // back to leagues......
    
    @IBAction func backLeague(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    
    
    var leagueEvent = LeagueDetails()
    var eventDetail = [EventDetails]()
    var teamImage = [TeamsImage]()
    
    @IBOutlet weak var firstCell: UICollectionView!
    
    @IBOutlet weak var secondCell: UICollectionView!
    
    @IBOutlet weak var thirdCell: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestData = "https://www.thesportsdb.com/api/v1/json/1/eventsseason.php?id=" + String(leagueEvent.leagueId)
            request(requestData, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["events"]
                self.eventDetail.removeAll()
                for i in resultArray.arrayValue{
                    let leagueEventName = i["strEvent"].stringValue
                    let leagueEventDate = i["dateEvent"].stringValue
                    let leagueEventTime = i["strTime"].stringValue
                    let leagueHomeTeam = i["strHomeTeam"].stringValue
                    let leagueAwayTeam = i["strAwayTeam"].stringValue
                    let leagueHomeTeamScore = i["intHomeScore"].intValue
                    let leagueAwayTeamScore = i["intAwayScore"].intValue
                    var event = EventDetails()
                    event.eventname = leagueEventName
                    event.eventdate = leagueEventDate
                    event.eventtime = leagueEventTime
                    event.hometeam = leagueHomeTeam
                    event.awayteam = leagueAwayTeam
                    event.homeScore = leagueHomeTeamScore
                    event.awayScore = leagueAwayTeamScore
                    self.eventDetail.append(event)
                    
                
                    //reload data........
                    self.firstCell.reloadData()
                    self.secondCell.reloadData()
                   
                }
                break;
            case .failure:
                break
            }
        }
        
        
        
        let requestTeamData = "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=" + String(leagueEvent.leagueId)
            request(requestTeamData, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["teams"]
                self.teamImage.removeAll()
                for i in resultArray.arrayValue{
                    let teamsdetails = TeamsImage()
                    let teamId = i["idTeam"].intValue
                    let teamLogo = i["strTeamLogo"].stringValue
                    
                    teamsdetails.teamid = teamId
                    teamsdetails.teamimmg = teamLogo
                    
                    self.teamImage.append(teamsdetails)
                    
                    //reload data.......
                    self.thirdCell.reloadData()
                    
                }
                break;
            case .failure:
                break
            }
        }
        
    }
    
    var sportsArray = [NSManagedObject]()
    
    //coreData...........
    
    @IBAction func fav_sport(_ sender: Any) {
        //1 app delgate
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2 manage object context
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        //3 create entity object
        
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteSports", in: manageContext)
        
        
        
        // 4 create manage object for movie entity
        
        let sport = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        //5 set values for the manage object
        var leaguesid = String(leagueEvent.leagueId)
        sport.setValue(leaguesid, forKey: "id")
        sport.setValue(leagueEvent.leaugename, forKey: "title")
        sport.setValue(leagueEvent.leagueImage, forKey: "image")
        
        
        //6 Save
        do{
            
            try manageContext.save()
            sportsArray.append(sport)
            
            let FavouriteScreen = self.storyboard?.instantiateViewController(withIdentifier: "fav") as! myFavouriteTableViewTableViewController
            self.present(FavouriteScreen, animated: true, completion: nil)
            
            print("Favourite League is added")
            
        }catch let error{
            
            print(error)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == firstCell){
            return eventDetail.count
        }
        if(collectionView == secondCell){
            return eventDetail.count
            
        }
        
        return eventDetail.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == firstCell){
            let cell = firstCell.dequeueReusableCell(withReuseIdentifier: "fCell", for: indexPath) as! UICollectionViewCell
            
            let  eventName:UILabel = cell.viewWithTag(1) as! UILabel
            let  eventTime:UILabel = cell.viewWithTag(2) as! UILabel
            let  eventDate:UILabel = cell.viewWithTag(3) as! UILabel
            
            eventName.text = eventDetail[indexPath.row].eventname
            eventTime.text = eventDetail[indexPath.row].eventtime
            eventDate.text = eventDetail[indexPath.row].eventdate
            return cell
            
        }
        
        if(collectionView == secondCell){
            let cell2 = secondCell.dequeueReusableCell(withReuseIdentifier: "sCell", for: indexPath) as! UICollectionViewCell
            let homeTeamName:UILabel = cell2.viewWithTag(1) as! UILabel
            let homeTeamnScore:UILabel = cell2.viewWithTag(2) as! UILabel
            let eventTime:UILabel = cell2.viewWithTag(3) as! UILabel
            let  secondTeamName : UILabel = cell2.viewWithTag(4) as! UILabel
            let secondTeamScore: UILabel = cell2.viewWithTag(5) as! UILabel
            let eventDate : UILabel = cell2.viewWithTag(6) as! UILabel
            
            
            homeTeamName.text = eventDetail[indexPath.row].hometeam
            
            homeTeamnScore.text = String (eventDetail[indexPath.row].homeScore)
            eventTime.text = eventDetail[indexPath.row].eventtime
            secondTeamName.text = eventDetail[indexPath.row].awayteam
            secondTeamScore.text = String(eventDetail[indexPath.row].awayScore)
            eventDate.text = eventDetail[indexPath.row].eventdate
            
            
            return cell2
            
            
        }
        
        
        
        if(collectionView == thirdCell){
            
            let cell3 = thirdCell.dequeueReusableCell(withReuseIdentifier: "tCell", for: indexPath) as! UICollectionViewCell
            
            let  teamLogo:UIImageView = cell3.viewWithTag(8) as! UIImageView
            teamLogo.sd_setImage(with: URL(string: teamImage[indexPath.row].teamimmg), placeholderImage: UIImage(named: "teamsImage.jpg"))
            teamLogo.layer.cornerRadius = teamLogo.frame.size.width / 2
            teamLogo.clipsToBounds = true
            print("link of team image")
            print(teamImage[indexPath.row].teamimmg)
            print("link of team image appeared")
            return cell3
            
            
        }
        
        let cellfinal = collectionView.dequeueReusableCell(withReuseIdentifier: "Events", for: indexPath) as! UICollectionViewCell
        
        
        return cellfinal
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let TeamDetailsScreen = self.storyboard?.instantiateViewController(withIdentifier: "team") as! TeamDetailsCollection
        TeamDetailsScreen.teamImage = teamImage[indexPath.row]
        self.present(TeamDetailsScreen, animated: true, completion: nil)
        
        print("Image is pressed")
    }
}
