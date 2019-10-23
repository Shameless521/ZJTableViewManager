//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
@objc public protocol ZJTableViewDelegate: NSObjectProtocol {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView)
}

open class ZJTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    public weak var delegate: ZJTableViewDelegate?
    public var tableView: UITableView!
    public var sections: [ZJTableViewSection] = []
    var defaultTableViewSectionHeight: CGFloat {
        return tableView.style == .grouped ? 44 : 0
    }
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        registerDefaultCells()
    }
    
    /// use this method to update cell height after you change item.cellHeight.
    open func updateHeight() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func registerDefaultCells() {
        let myBundle = Bundle(for: ZJTextItem.self)
        register(ZJTextCell.self, ZJTextItem.self, myBundle)
    }
    
    public func register(_ nibClass: AnyClass, _ item: AnyClass, _ bundle: Bundle = Bundle.main) {
        print("\(nibClass)")
        if bundle.path(forResource: "\(nibClass)", ofType: "nib") != nil {
            tableView.register(UINib(nibName: "\(nibClass)", bundle: bundle), forCellReuseIdentifier: "\(item)")
        } else {
            tableView.register(nibClass, forCellReuseIdentifier: "\(item)")
        }
    }
    
    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = sections[section]
        if currentSection.headerView != nil || (currentSection.headerHeight > 0 && currentSection.headerHeight != CGFloat.leastNormalMagnitude) {
            return currentSection.headerHeight
        }
        
        if let title = currentSection.headerTitle {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
            label.text = title
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.sizeToFit()
            return label.frame.height + 20.0
        } else {
            return defaultTableViewSectionHeight
        }
    }
    
    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.headerView
    }
    
    public func tableView(_: UITableView, willDisplayHeaderView _: UIView, forSection section: Int) {
        let (currentSection, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerWillDisplayHandler?(currentSection!)
    }
    
    public func tableView(_: UITableView, didEndDisplayingHeaderView _: UIView, forSection section: Int) {
        let (currentSection, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerDidEndDisplayHandler?(currentSection!)
    }
    
    public func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let currentSection = sections[section]
        return currentSection.footerHeight
    }
    
    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.footerView
    }
    
    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (section, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.headerTitle
    }
    
    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        let (section, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.footerTitle
    }
    
    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        return currentSection.items.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        #if swift(>=4.2)
        if item.cellHeight == UITableView.automaticDimension, tableView.estimatedRowHeight == 0 {
            tableView.estimatedRowHeight = 44
            tableView.estimatedSectionFooterHeight = 44
            tableView.estimatedSectionHeaderHeight = 44
        }
        #else
        if item.cellHeight == UITableViewAutomaticDimension, tableView.estimatedRowHeight == 0 {
            tableView.estimatedRowHeight = 44
            tableView.estimatedSectionFooterHeight = 44
            tableView.estimatedSectionHeaderHeight = 44
        }
        #endif
        
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        item.tableViewManager = self
        // 报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? DefaultCellProtocol
        if cell == nil {
            cell = (ZJTableViewCell(style: item.cellStyle!, reuseIdentifier: item.cellIdentifier) as DefaultCellProtocol)
        }
        
        cell!.textLabel?.text = item.cellTitle

        cell!.accessoryType = item.accessoryType

        cell!.selectionStyle = item.selectionStyle

        cell!._item = item
        
        cell!.cellWillAppear()
        
        return cell!
    }
    
    public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! DefaultCellProtocol).cellDidDisappear()
    }
    
    public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! DefaultCellProtocol).cellDidAppear()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        if item.isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        item.selectionHandler?(item)
    }
    
    public func tableView(_: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let (_, item) = sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)
        return item!.editingStyle
    }
    
    public func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let (_, item) = sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)
        
        if editingStyle == .delete {
            if let handler = item?.deletionHandler {
                handler(item!)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = delegate {
            if d.responds(to: #selector(ZJTableViewDelegate.scrollViewDidScroll(_:))) {
                d.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    func sectinAndItemFrom(indexPath: IndexPath?, sectionIndex: Int?, rowIndex: Int?) -> (ZJTableViewSection?, ZJTableViewItem?) {
        var currentSection: ZJTableViewSection?
        var item: ZJTableViewItem?
        if let idx = indexPath {
            currentSection = sections[idx.section]
            item = currentSection?.items[idx.row]
        }
        
        if let idx = sectionIndex {
            currentSection = sections.count > idx ? sections[idx] : nil
        }
        
        if let idx = rowIndex {
            item = (currentSection?.items.count)! > idx ? currentSection?.items[idx] : nil
        }
        
        return (currentSection, item)
    }
    
    public func add(section: ZJTableViewSection) {
        if !section.isKind(of: ZJTableViewSection.self) {
            print("error section class")
            return
        }
        section.tableViewManager = self
        sections.append(section)
    }
    
    public func remove(section: Any) {
        if !(section as AnyObject).isKind(of: ZJTableViewSection.self) {
            print("error section class")
            return
        }
        sections.remove(at: sections.zj_indexOf(section as! ZJTableViewSection))
    }
    
    public func removeAllSections() {
        sections.removeAll()
    }
    
    public func reload() {
        tableView.reloadData()
    }
    
    public func transform(fromLabel: UILabel?, toLabel: UILabel?) {
        toLabel?.text = fromLabel?.text
        toLabel?.font = fromLabel?.font
        toLabel?.textColor = fromLabel?.textColor
        toLabel?.textAlignment = (fromLabel?.textAlignment)!
        if let string = fromLabel?.attributedText {
            toLabel?.attributedText = string
        }
    }
}

extension Array where Element: Equatable {
    func zj_indexOf(_ element: Element) -> Int {
        var index: Int? = nil
        
        #if swift(>=5)
         index = self.firstIndex { (e) -> Bool in
            return e == element
        }
        #else
        index = self.index(where: { (e) -> Bool in
            return e == element
        })
        #endif
        
        assert(index != nil, "Can't find element in array, please check you code")
        return index!
    }
}
