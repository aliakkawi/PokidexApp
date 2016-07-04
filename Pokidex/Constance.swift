//
//  Constance.swift
//  Pokidex
//
//  Created by Ali Akkawi on 7/2/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"


// we will make a closure -> a block of code that will be run when the download complete.

typealias DownloadComplete = () -> ()