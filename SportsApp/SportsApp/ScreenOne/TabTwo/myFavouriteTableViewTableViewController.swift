//
//  myFavouriteTableViewTableViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/21/21.
//  Copyright © 2021 Walaa. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class myFavouriteTableViewTableViewController: UITableViewController {
    
    var arr_all_legues = [LeagueDetails]()
    var sportsArray = [NSManagedObject]()
  
    var legauesevents = LeagueDetails()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // coreData.......
        
        //1 app delgate
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2 manage object context
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        //3 create fetch request
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteSports")
        fetchRequest.returnsDistinctResults = true
        
        do{
            sportsArray = try manageContext.fetch(fetchRequest)
            print(" there are leagues ")
            
        }catch let error{
            
            print(error)
            
        }
        self.tableView.reloadData();
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sportsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath)
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  image:UIImageView = cell.viewWithTag(1) as! UIImageView
        
        title.text = (sportsArray[indexPath.row].value(forKey: "title") as! String)
        image.sd_setImage(with: URL(string: sportsArray[indexPath.row].value(forKey: "image") as! String), placeholderImage: UIImage(named: "sport.jpg"))
        
        return cell
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            //1 app delgate
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //2 manage object context
            
            let manageContext = appDelegate.persistentContainer.viewContext
            
            //3 delete from manage context
            manageContext.delete(sportsArray[indexPath.row])
            
            do{
                try manageContext.save()
                
            }catch let error{
                
                print(error)
            }
            
            sportsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Conection.isConnectedToInternet {
            
            let EventsScreen = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsView
            var id = sportsArray[indexPath.row].value(forKey: "id") as! String
            
            EventsScreen.leagueEvent.leagueId = Int(id)!
            
            self.present(EventsScreen  as UIViewController, animated: true, completion: nil)
            print("Favourite Cell")
        }
        else  {
            let alert = UIAlertController(title: "Alert", message: "connection failed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
}



}
