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
                #selector(AppCoordinator.init(
                    tabsCoordinatorProvider:mapCoordinatorProvider:))) { (initializer) in
                        initializer?.injectParameter(with: self)
                        initializer?.injectParameter(with: self)
            }
            definition?.scope = .singleton
        }
    }

    @objc
    public dynamic func tabsCoordinator() -> Any {
        return TyphoonDefinition.withClass(TabsCoordinator.self) { (definition) in
            definition?.useInitializer(
                #selector(TabsCoordinator.init(
                    mediaItemsTabCoordinatorProvider:searchTabCoordinatorProvider:))) { (initializer) in
                        initializer?.injectParameter(with: self)
                        initializer?.injectParameter(with: self)
            }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mediaItemsTabCoordinator() -> Any {
        return TyphoonDefinition.withClass(MediaItemsTabCoordinator.self) { (definition) in
            definition?.useInitializer(
                #selector(MediaItemsTabCoordinator.init(mediaItemsViewModelProvider:
                    mediaItemsCategoryViewModelProvider:))) { (initializer) in
                        initializer?.injectParameter(with: self)
                        initializer?.injectParameter(with: self)
            }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func searchTabCoordinator() -> Any {
        return TyphoonDefinition.withClass(SearchTabCoordinator.self) { (definition) in
            definition?.useInitializer(
            #selector(SearchTabCoordinator.init(searchViewModelProvider:))) { (initializer) in
                initializer?.injectParameter(with: self)
            }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mapCoordinator() -> Any {
        return TyphoonDefinition.withClass(MapCoordinator.self) { (definition) in
            definition?.useInitializer(
            #selector(MapCoordinator.init(mapViewModel:))) { (initializer) in
                initializer?.injectParameter(with: self.mapViewModel())
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
    public dynamic func mediaItemsCategoryViewModel() -> Any {
        return TyphoonDefinition.withClass(MediaItemsCategoryViewModel.self) { (definition) in
            definition?.useInitializer(
            #selector(MediaItemsCategoryViewModel.init(storage:))) { (initializer) in
                initializer?.injectParameter(with: self.mediaItemsStorage())
            }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func searchViewModel() -> Any {
        return TyphoonDefinition.withClass(SearchViewModel.self) { (definition) in
            definition?.useInitializer(
            #selector(SearchViewModel.init(storage:))) { (initializer) in
                initializer?.injectParameter(with: self.mediaItemsStorage())
            }
            definition?.scope = .prototype
        }
    }

    @objc
    public dynamic func mapViewModel() -> Any {
        return TyphoonDefinition.withClass(MapViewModel.self) { (definition) in
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
