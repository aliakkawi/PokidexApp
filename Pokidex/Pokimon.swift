//
//  Pokimon.swift
//  Pokidex
//
//  Created by Ali Akkawi on 7/1/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import Foundation
import Alamofire

class Pokimon{
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _types: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    
    // getters.
    
    
    var name: String{
        
        get{
            
            if _name == nil{
                
                _name = ""
            }
            return self._name
        }
    }
    
    var podexId: Int{
        
        get{
            
            
            return self._pokedexId
        }
    }
    
    var description: String{
        
        get{
            if _description == nil{
                
                _description = ""
            }
            
            return self._description
        }
    }
    
    var types: String{
        
        get{
            if _types == nil{
                
                _types = ""
            }
            
            return self._types
        }
    }
    
    var defense: String{
        
        get{
            if _defense == nil{
                
                _defense = ""
            }
            
            return self._defense
        }
    }
    
    var height: String{
        
        get{
            if _height == nil{
                
                _height = ""
            }
            
            return self._height
        }
    }
    
    var weight: String{
        
        get{
            if _weight == nil{
                
                _weight = ""
            }
            
            return self._weight
        }
    }
    
    var attack: String{
        
        get{
            if _attack == nil{
                
                _attack = ""
            }
            
            return self._attack
        }
    }
    
    var nextEvolutionText: String{
        
        get{
            if _nextEvolutionText == nil{
                
                _nextEvolutionText = ""
            }
            
            return self._nextEvolutionText
        }
    }
    
    var nextEvolutionId: String{
        
        get{
            if _nextEvolutionId == nil{
                
                _nextEvolutionId = ""
            }
            
            return self._nextEvolutionId
        }
    }
    
    var nextEvolutionLevel: String{
        
        get{
            if _nextEvolutionLevel == nil{
                
                _nextEvolutionLevel = ""
            }
            
            return self._nextEvolutionLevel
        }
    }
    
    var pokemonUrl: String{
        
        get{
            if _pokemonUrl == nil{
                
                _pokemonUrl = ""
            }
            
            return self._pokemonUrl
        }
    }
    
    
    
    
    
    init(name: String, podex_Id: Int){
        
        
        self._name = name;
        self._pokedexId = podex_Id
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/" // everytime we make a new pokemon this url will be generated automatically.
    }
    
    
    
    func downloadPokemonDetails(completed: DownloadComplete) { // when the download complete call this.
        
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response) in
            let result = response.result
            //print(result.value.debugDescription)
            
            // the download function in our PokimonDetailsViewController will be called and the data will be downloaded.
            // Almofire mde it easy for us to download the data.
            // now all we need to do is Parse the JSon just like we did earlier in the web request test project.
            
            if let dict = result.value as? Dictionary<String, AnyObject>{ // convert JSON to dictionary.
                
                if let weight = dict["weight"] as? String{
                
                self._weight = weight
                
                }
                
                if let height = dict["height"] as? String{
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{ // in the api they show as integers.
                    
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    
                    self._defense = "\(defense)"
                }
                
                // type is a string and the vlue is an array. so it is an array of dictionaries.
                
                if let types = dict["types"] as? [Dictionary<String,String>]
                where types.count > 0{ // array of Dictionaries.   >0 check if there is a data in our array.
                    
                    
                    // grap the first name
                    if let typeName = types[0]["name"]{ // first item in the array (wich is a dictionary, and we need the name property.
                        
                        self._types = typeName.capitalizedString
                    }
                    
                    if types.count > 1 { // if there is more than 1 type we need to append the type string.
                        
                        for i in 1...(types.count - 1){ // we started from 1 because the first item already added to self._types.
                            
                            if let name = types[i]["name"]{
                        self._types! += "/\(name.capitalizedString)"
                                
                            }
                        }
                    }
                
                
                }else { // if there is no types.
                    
                    self._types! += ""
                    
                }
                
                
                
                // Description is also an array of Dictionaries,
                
                /*
                 
                 eg:
                 
                 "description": [
                    {
                        "name": "shorupi_gen4",
                        "resource_url" : "/api/v1/description/5666...."
                 }
                 
                 {
                 "name": "shorupi_gen4",
                 "resource_url" : "/api/v1/description/5666...."
                 }
                 
                 ]
 
 
 
 */
                
                //we will grap only the first item of the array, first Dictionary.
             
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0{
                
                    
                    if let url = descArr[0]["resource_uri"]{ // only the first item and we need only the description url not the name.
                    
                    // the result is a url that we need to parse.
                        
                        
                        
                        // now we need to pARSE USING aLMOFIRE JUST LIKE WE DID UP.
                        
                        let nsurl = NSURL(string:  "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { (response) in
                            let result = response.result
                            // we need to grap the name for the description inside the descriptions.  wow
                            
                            if let descDict = result.value as? Dictionary<String, AnyObject>{
                                
                                if let description = descDict["description"] as? String{
                                    
                                    self._description = description
                                    print(self._description)
                                }
                                
                            }
                            
                            completed()
                    
                        }
                    
                    }
                }else {
                    self._description = ""
                    
                }
                
                
                // finally we will get the next evolution for the Pokemon wich is also an array of dictionaries.
                
                // we will grap it with the name.
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>]
                    where evolutions.count > 0{
                    
                    if let evolution = evolutions[0]["to"] as? String{ // first item in the array (wich is a dictionary, and we need the name property.
                        
                        self._types = evolution.capitalizedString
                        // if the word mega exist in the evolution we will delete it.
                        
                        if evolution.rangeOfString("mega") == nil{ // mega is not found.
                            
                            // extract the pokemon id from the "resource_url" eg: "resources_uri":"/api/v1/pokemon/452/"
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "") // replace it with empty string.
                                // now we need to get rid of the / at the end.
                                
                                let pokemonId = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = pokemonId
                                self._nextEvolutionText = evolution
                                
                                if let lvl = evolutions[0]["level"] as? Int
                                {
                                    
                                    self._nextEvolutionLevel = "\(lvl)"
                                    
                                
                                
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionText)
                                print(self._nextEvolutionLevel)
                                
                            }
                            
                        }
                    }
                    
                }
                
                
                
                
                
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._types)
                
                
            }
        }
        
    }
}
