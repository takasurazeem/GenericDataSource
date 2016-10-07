//
//  GeneralCollectionView.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 2/13/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import Foundation

/**
 The GeneralCollectionView protocol unifies the interface of the `UICollectionView` and 
 `UITableView` so that similar methods with different names will have the same name now that starts with "ds_" prefix.
 
 Besides, `CompositeDataSource` has different implementation that allows children data sources to manipulate the `UICollectionView` and/or `UITableView` as if the children data sources are in the same top level first section even if it's in a different section.
 */
@objc public protocol GeneralCollectionView: class {
    
    /**
     Represents the underlying scroll view. Use this method if you want to get the
     `UICollectionView`/`UITableView` itself not a wrapper.
     So, if you have for example an instance like the following
     ```
     let generalCollectionView: GeneralCollectionView = <...>
     
     // Not Recommented, can result crashes if there is a CompositeDataSource.
     let underlyingTableView = generalCollectionView as! UITableView
     
     // Recommended, safer
     let underlyingTableView = generalCollectionView.ds_scrollView as! UITableView
     ```
     The later can result a crash if the scroll view is a UICollectionView not a UITableView.
     
     */
    var ds_scrollView: UIScrollView { get }
    
    // MARK:- Register, dequeue
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_registerClass(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_dequeueReusableCellViewWithIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> ReusableCell
    
    // MARK:- Numbers

    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_numberOfSections() -> Int
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_numberOfItemsInSection(_ section: Int) -> Int
    
    // MARK:- Manpulate items and sections
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_reloadData()
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_insertSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_deleteSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_reloadSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_moveSection(_ section: Int, toSection newSection: Int)
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_insertItemsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_deleteItemsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_reloadItemsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation)
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_moveItemAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath)
    
    // MARK:- Scroll
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_scrollToItemAtIndexPath(_ indexPath: IndexPath, atScrollPosition scrollPosition: UICollectionViewScrollPosition, animated: Bool)
    
    // MARK:- Select/Deselect
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_selectItemAtIndexPath(_ indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition)
    func ds_deselectItemAtIndexPath(_ indexPath: IndexPath, animated: Bool)
    
    // MARK:- IndexPaths, Cells
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_indexPathForCell(_ cell: ReusableCell) -> IndexPath?
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_indexPathForItemAtPoint(_ point: CGPoint) -> IndexPath?
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_indexPathsForVisibleItems() -> [IndexPath]
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_indexPathsForSelectedItems() -> [IndexPath]
    
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_visibleCells() -> [ReusableCell]
    /**
     Check documentation of the corresponding methods from `UICollectionView` and `UITableView`.
     */
    func ds_cellForItemAtIndexPath(_ indexPath: IndexPath) -> ReusableCell?
    
    
    // MARK: - Local, Global
    
    /**
     Converts an index path value relative to the composite data source to an index path value relative to a specific data source.
     
     - parameter indexPath:    The index path relative to the compsite data source.
     
     - returns: The global index path relative to the composite data source.
     */
    func ds_localIndexPathForGlobalIndexPath(_ globalIndex: IndexPath) -> IndexPath
    
    /**
     Converts an index path value relative to a specific data source to an index path value relative to the composite data source.
     
     - parameter indexPath:     The local index path relative to the passed data source.
     
     - returns: The global index path relative to the composite data source.
     */
    func ds_globalIndexPathForLocalIndexPath(_ localIndex: IndexPath) -> IndexPath
    
    /**
     Converts a section value relative to a specific data source to a section value relative to the composite data source.
     
     - parameter section:       The local section relative to the passed data source.

     - returns: The global section relative to the composite data source.
     */
    func ds_globalSectionForLocalSection(_ localSection: Int) -> Int
    
}

extension GeneralCollectionView {

    func ds_localIndexPathsForGlobalIndexPaths(_ globalIndexPaths: [IndexPath]) -> [IndexPath] {
        return globalIndexPaths.map { ds_localIndexPathForGlobalIndexPath($0) }
    }

    func ds_globalIndexPathsForLocalIndexPaths(_ localIndexPaths: [IndexPath]) -> [IndexPath] {
        return localIndexPaths.map {  ds_globalIndexPathForLocalIndexPath($0) }
    }

    func ds_globalSectionSetForLocalSectionSet(_ localSections: IndexSet) -> IndexSet {
        let globalSections = NSMutableIndexSet()
        for section in localSections {
            let globalSection = ds_globalSectionForLocalSection(section)
            globalSections.add(globalSection)
        }
        return globalSections as IndexSet
    }
}