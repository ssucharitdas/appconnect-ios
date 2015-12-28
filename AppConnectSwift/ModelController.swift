//
//  ModelController.swift
//  AppConnectSample
//
//  Created by Steve Roy on 2015-12-16.
//  Copyright © 2015 Medidata Solutions. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var fields: [MDField] = []

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> FieldViewController? {
        // Return the data view controller for the given index.
        guard self.fields.count > 0 && index < self.fields.count else {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let fieldViewController = storyboard.instantiateViewControllerWithIdentifier("FieldViewController") as! FieldViewController
        fieldViewController.fieldID = fields[index].objectID
        return fieldViewController
    }

    func indexOfViewController(viewController: FieldViewController) -> Int {
        for (index, field) in fields.enumerate() {
            if field.objectID == viewController.fieldID {
                return index
            }
        }
        
        return NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! FieldViewController)
        
        guard index != 0 && index != NSNotFound else {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! FieldViewController)
        
        guard index != NSNotFound && ++index < self.fields.count else {
            return nil
        }

        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

