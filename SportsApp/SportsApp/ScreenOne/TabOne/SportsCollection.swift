//
//  SportsCollection.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/23/21.
//  Copyright © 2021 Walaa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class SportsCollection: UICollectionViewController {
    var arr_sports = [SportDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        let requestData = "https://www.thesportsdb.com/api/v1/json/1/all_sports.php"
        request(requestData, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["sports"]
                self.arr_sports.removeAll()
                
                for i in resultArray.arrayValue{
                    let sportName = i["strSport"].stringValue
                    let sportImage = i["strSportThumb"].stringValue
                    
                    var sport = SportDetails()
                    sport.name = sportName
                    sport.image = sportImage
                    self.arr_sports.append(sport)
                    self.collectionView.reloadData()
                }
                break;
            case .failure:
                break
            }
        }
        
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return arr_sports.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arr_sports.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  img:UIImageView = cell.viewWithTag(1) as! UIImageView
        
        title.text = arr_sports[indexPath.row].name
        img.sd_setImage(with: URL(string: arr_sports[indexPath.row].image), placeholderImage: UIImage(named: "sport.jpg"))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arr_sports[indexPath.row].name)
        print(arr_sports[indexPath.row].image)
        let leagueScreen = self.storyboard?.instantiateViewController(withIdentifier: "legVC") as! LeaguesTableView
        leagueScreen.sport = arr_sports[indexPath.row]
         self.present(leagueScreen, animated: true, completion: nil)
        print("Cell is pressed")
        
        
    }
    
}
