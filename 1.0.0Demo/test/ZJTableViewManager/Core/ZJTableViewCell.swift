//
//  ZJTableViewManagerCell.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

open class ZJTableViewCell: UITableViewCell, ZJCellProtocol {
    public var item: ZJTableViewItem!
    
    public typealias ZJCelltemType = ZJTableViewItem

    public func cellWillAppear() { }

    public func cellDidAppear() { }

    public func cellDidDisappear() {}

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
