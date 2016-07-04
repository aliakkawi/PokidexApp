//
//  ViewController.swift
//  Pokidex
//
//  Created by Ali Akkawi on 7/1/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import AVFoundation

//// Put this piece of code anywhere you like
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate , UINavigationControllerDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    var pokimons  = [Pokimon]()
    var btnSound: AVAudioPlayer!
    var musicOn: Bool!
    var inSearchMood = false
    var filteredPokimon = [Pokimon]()
    
    @IBOutlet weak var searchBar2: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //hideKeyboardWhenTappedAround()
        musicOn = true
        // get the path of the sound file.
        
        // change the search word in the keyboard to DONE.
        
        searchBar2.returnKeyType = .Done
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: ".mp3")
        
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do{
             btnSound = try AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
            btnSound.numberOfLoops = -1 // infinit.
        } catch let err as NSError{
            print(err.debugDescription)
            
        }
        
        // play a sound.
        btnSound.play()
        
        
        parsePokemonCSV()
        
        
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    @IBAction func playMusic(sender: UIButton!) { // we changed the sender to UIButton so we can set the alpha.
        
        if musicOn == true{
            
            musicOn = false
            btnSound.stop()
            sender.alpha = 0.2
            
        }else {
            musicOn = true
            btnSound.play()
            sender.alpha = 1.0
        }
    }
    
    func parsePokemonCSV(){
        
        // GET THE PATH FOR THE CSV FILE.
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        // our csv.swift file throw an error so we have to use do catch.
        
        do {
            
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows // this will make a dictionary from the csv file.
            
            //iterate through the rows grap data and enter them through our array.
            //our csv file is a dictionary of pokemon number and name.
            for row in rows{ // in  each dictionary item.
                
                let pokemonId =  Int (row["id"]!)! // this is how we get the value for a key in the dictionary.
                let name = row["identifier"]!
                
                let pokimon: Pokimon = Pokimon(name: name, podex_Id: pokemonId)
                pokimons.append(pokimon)
                
            }
            
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if !inSearchMood{
            return pokimons.count
        }else {
            
           return filteredPokimon.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? CustomCollectionViewCell{
        
            //let pokimon: Pokimon = Pokimon(name: "Test", podex_Id: (indexPath.row + 1)) // we could do this because the images names are actually Integers.
            
            if !inSearchMood{
            cell.pokimonNameLabel.text = pokimons[indexPath.row].name
            cell.pokimonImage.image = UIImage(named: "\(pokimons[indexPath.row].podexId)")
            }else{
                cell.pokimonNameLabel.text = filteredPokimon[indexPath.row].name
                cell.pokimonImage.image = UIImage(named: "\(filteredPokimon[indexPath.row].podexId)")
                
            }
            
        return cell
        }else {
            
            return UICollectionViewCell()
        }
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        
//        
//        print("item clicked")
//        performSegueWithIdentifier("gotodetail", sender: nil)
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
             if segue.identifier == "gotodetail" {
            
            if let indexPaths = collectionView?.indexPathsForSelectedItems() {
                let destinationViewController = segue.destinationViewController as! PokimonDetailsViewController
                
                
                destinationViewController.pokimon = pokimons[indexPaths[0].row]
                //collectionView?.deselectItemAtIndexPath(indexPaths[0], animated:false)
                
                
                
            }
            
            
        }
    }
    
    
    func collectioView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    
// FOR THE SEARCH BAR.
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        // we need to make a second array for holding the filtered results.
        
        if searchBar2.text == nil || searchBar2.text == "" {
            
            inSearchMood = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            
            inSearchMood = true
            let searchText = searchBar2.text!.lowercaseString
            filteredPokimon = pokimons.filter({$0.name.rangeOfString(searchText) != nil})
            collectionView.reloadData()
        }
    }
    
    // when we click the search button we need the keyboard to disappear
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }

}

