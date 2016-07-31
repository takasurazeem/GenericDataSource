//
//  SingleSectionDataSourcesCollection.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 2/21/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import Foundation

class SingleSectionDataSourcesCollection: DataSourcesCollection {

    private var itemsCount: Int = 0

    private var globalItemToMappings: [Int: SingleSectionMapping] = [:]

    override func createMappingForDataSource(dataSource: DataSource) -> Mapping {
        return SingleSectionMapping(dataSource: dataSource)
    }

    override func updateMappings() {

        // reset
        var count = 0
        globalItemToMappings.removeAll()

        for mapping in mappings {
            guard let mapping = mapping as? SingleSectionMapping else {
                fatalError("Mappings for \(self.dynamicType) should be of type \(SingleSectionMapping.self)")
            }

            let newItemCount = mapping.updateMappings(startingWithGlobalItem: count) + count
            while (count < newItemCount) {
                globalItemToMappings[count] = mapping
                count += 1
            }
        }
        itemsCount = count
    }

    override func mappingForIndexPath(indexPath: NSIndexPath) -> Mapping {
        return mappingForGlobalItem(indexPath.item)
    }

    func mappingForGlobalItem(item: Int) -> SingleSectionMapping {
        guard let mapping = globalItemToMappings[item] else {
            fatalError("Couldn't find mapping for item: \(item)")
        }
        return mapping
    }

    // MARK:- Data Source

    override func numberOfSections() -> Int {
        updateMappings()

        return 1
    }

    override func numberOfItems(inSection section: Int) -> Int {
        updateMappings()

        return itemsCount
    }
}

extension SingleSectionDataSourcesCollection {

    internal class SingleSectionMapping : Mapping {

        private var globalItemStartIndex: Int = 0

        override func localItemForGlobalItem(globalItem: Int) -> Int {
            return globalItem - globalItemStartIndex
        }

        override func globalItemForLocalItem(localItem: Int) -> Int {
            return localItem + globalItemStartIndex
        }

        func updateMappings(startingWithGlobalItem globalItem:Int) -> Int {

            globalItemStartIndex = globalItem
            let itemCount = self.dataSource.ds_numberOfItems(inSection: 0)
            return itemCount
        }
    }
}
