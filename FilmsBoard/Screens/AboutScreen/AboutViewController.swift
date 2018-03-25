//
//  AboutViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 25/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import Licensy

class AboutViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: LicensyTable!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionLabel.text = "Aplicación desarrollada por Pablo Sánchez Egido y Javier García Antúnez para el máster MIMO.\n\nLos datos y las imágenes mostrados se obtienen de The Movie Database API.\nA continuación se detallan las librerías de terceros usadas."
        self.loadLibraries()
    }
}

extension AboutViewController {

    private func loadLibraries() {
        let libraries = [
            LibraryEntity(name: "Typhoon", organization: "AppsQuickly", url: "https://github.com/appsquickly/Typhoon", copyright: "2012 - 2015 Jasper Blues, Aleksey Garbarev and contributors.", license: ApacheSoftwareLicense20()),
            LibraryEntity(name: "Alamofire", organization: "Alamofire", url: "https://github.com/Alamofire/Alamofire", copyright: "Alamofire", license: MITLicense()),
            LibraryEntity(name: "SDWebImage", organization: "SDWebImage", url: "https://github.com/rs/SDWebImage", copyright: "Olivier Poitrey", license: MITLicense()),
            LibraryEntity(name: "SCLAlertView", organization: "Vik Me Up", url: "https://github.com/vikmeup/SCLAlertView-Swift", copyright: "Scroll Feed", license: MITLicense()),
            LibraryEntity(name: "Cosmos", organization: "Evgenyneu", url: "https://github.com/evgenyneu/Cosmos", copyright: "Evgenyneu", license: MITLicense()),
            LibraryEntity(name: "MBProgressHUD", organization: "JDG", url: "https://github.com/jdg/MBProgressHUD", copyright: "JDG", license: MITLicense()),
            LibraryEntity(name: "SlideMenuControllerSwift", organization: "Dekatoro", url: "https://github.com/dekatotoro/SlideMenuControllerSwift", copyright: "Yuji Hato Blog", license: MITLicense()),
            LibraryEntity(name: "SQLite.swift", organization: "Stephencelis", url: "https://github.com/stephencelis/SQLite.swift", copyright: "Stephen Celis", license: MITLicense()),
            LibraryEntity(name: "CarbonBadgeLabel", organization: "Ermalkaleci", url: "https://github.com/ermalkaleci/CarbonBadgeLabel", copyright: "Ermalkaleci", license: MITLicense()),
            LibraryEntity(name: "ReachabilitySwift", organization: "Ashleymills", url: "https://github.com/ashleymills/Reachability.swift", copyright: "Ashley Mills", license: MITLicense()),
            LibraryEntity(name: "Licensy", organization: "Gygr969", url: "https://github.com/gygr969/Licensy", copyright: "Copyright © David Jimenez Guinaldo & Guillermo Garcia Rebolo", license: MITLicense())
        ]

        self.tableView.appearance.setOrangeFitAppearance()
        self.tableView.setLibraries(libraries)
    }
}
