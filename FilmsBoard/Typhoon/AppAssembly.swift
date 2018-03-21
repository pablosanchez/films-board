//
//  AppAssembly.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import Typhoon

@objc
class AppAssembly: TyphoonAssembly {

    @objc
    public dynamic func appCoordinator() -> Any {
        return TyphoonDefinition.withClass(AppCoordinator.self) { (definition) in
            definition?.useInitializer(
                #selector(AppCoordinator.init(tabsCoordinatorProvider:))) { (initializer) in
                    initializer?.injectParameter(with: self)
                }
            definition?.scope = .singleton
        }
    }
    

    
    
    @objc
    public dynamic func detailFilmViewModel() -> Any {
        return TyphoonDefinition.withClass(DetailFilmViewModel.self) { (definition) in
            definition?.useInitializer(
            #selector(DetailFilmViewModel.init(storage:))) { (initializer) in
                initializer?.injectParameter(with: self.mediaItemsStorage())
            }
            definition?.scope = .prototype
        }
    }
    
    
    

    @objc
    public dynamic func tabsCoordinator() -> Any {
        return TyphoonDefinition.withClass(TabsCoordinator.self) { (definition) in
            definition?.useInitializer(
                #selector(TabsCoordinator.init(mediaItemsTabCoordinatorProvider:))) { (initializer) in
                    initializer?.injectParameter(with: self)
                }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mediaItemsTabCoordinator() -> Any {
        return TyphoonDefinition.withClass(MediaItemsTabCoordinator.self) { (definition) in
            definition?.useInitializer(
                #selector(MediaItemsTabCoordinator.init(viewModel:detailFilmViewModelProvider:))) { (initializer) in
                    initializer?.injectParameter(with: self.mediaItemsViewModel())
                    initializer?.injectParameter(with: self)
                }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mediaItemsViewModel() -> Any {
        return TyphoonDefinition.withClass(MediaItemsViewModel.self) { (definition) in
            definition?.useInitializer(
                #selector(MediaItemsViewModel.init(storage:))) { (initializer) in
                    initializer?.injectParameter(with: self.mediaItemsStorage())
                }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mediaItemsStorage() -> Any {
        return TyphoonDefinition.withClass(MediaItemsStorage.self) { (definition) in
            definition?.scope = .singleton
        }
    }
}
