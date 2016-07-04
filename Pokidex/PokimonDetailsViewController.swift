//
//  PokimonDetailsViewController.swift
//  Pokidex
//
//  Created by Ali Akkawi on 7/2/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class PokimonDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var pokimonImageView: UIImageView!

    @IBOutlet weak var pokimonNameLabel: UILabel!
    
    @IBOutlet weak var pokemonDescriptionLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var defenceLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var pokemonIdLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var baseAtackLabel: UILabel!
    
    @IBOutlet weak var evolutionLabel: UILabel!
    
    
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    var pokimon: Pokimon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokimonImageView.image = UIImage(named: "\(pokimon.podexId)")
        pokimonNameLabel.text = pokimon.name
        
        // download the data.
        
        pokimon.downloadPokemonDetails { 
            
            self.updateUserInterface()
        }
        
        
        
    }
    
    func updateUserInterface(){
        
        pokemonDescriptionLabel.text = pokimon.description
        typeLabel.text = pokimon.types
        defenceLabel.text = pokimon.defense
        heightLabel.text = pokimon.height
        pokemonIdLabel.text = "\(pokimon.podexId)"
        weightLabel.text = pokimon.weight
        baseAtackLabel.text = pokimon.attack
        evolutionLabel.text = pokimon.nextEvolutionText
        
        if pokimon.nextEvolutionId == "" {
            
            evolutionLabel.text = "NO EVOLUTIONS"
            currentEvolutionImage.hidden = true
            nextEvolutionImage.hidden = true
        } else {
            
            currentEvolutionImage.hidden = false
            nextEvolutionImage.hidden = false
            
            
        currentEvolutionImage.image = UIImage(named: pokimon.nextEvolutionId)
        nextEvolutionImage.image = UIImage(named: pokimon.nextEvolutionId)
            var str = "Next Evolution: \(pokimon.nextEvolutionText)"
            if pokimon.nextEvolutionLevel != "" {
                
                str += " - LVL \(pokimon.nextEvolutionLevel)"
            }
            
        }
        
    }

    

}
