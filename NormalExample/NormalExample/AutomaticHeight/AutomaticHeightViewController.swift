//
//  AutomaticHeightViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit

class AutomaticHeightViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutomaticHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(AutomaticHeightCell.self, AutomaticHeightCellItem.self)
        tableView.separatorStyle = .none
        // 模拟网络请求
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            indicator.stopAnimating()
            // 网络请求完成
            self.showData()
        }
        // Do any additional setup after loading the view.
    }

    func showData() {
        for hero in randomStr() {
            let headerView = HeroHeaderView.view()
            headerView.imageHero.image = UIImage(named: hero.name)
            headerView.labelHero.text = hero.name
            let section = ZJTableViewSection(headerView: headerView)
            manager.add(section: section)

            for skill in hero.skill {
                let item = AutomaticHeightCellItem()
                item.skill = skill
                // 计算高度
                item.autoHeight(manager)
                section.add(item: item)
            }
        }
        manager.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 随机产生不确定长度字符串
    func randomStr() -> [HeroModel] {
        let myArray: [Any] = [
            [
                "name": "程咬金",
                "skill": [
                    [
                        "name": "爆裂双斧",
                        "desc": "程咬金向指定目标位置猛力一跃并挥动双斧斩击，对范围内敌人造成120/155/190/225/260/295（+50%物理加成）点物理伤害并造成50%的减速效果，持续2秒；被动：程咬金的普通攻击命中敌方英雄会减少1秒爆裂双斧的冷却时间。",
                    ],
                    [
                        "name": "激热回旋",
                        "desc": "程咬金转动双斧劈砍敌人，对范围内的敌人造成两段伤害，每段造成125/150/175/200/225/250（+60%物理加成）点物理伤害。",
                    ],
                    [
                        "name": "正义潜能",
                        "desc": "程咬金迸发正义热情，每秒回复8%最大生命，同时增加移动速度30%，持续5秒。",
                    ],
                ],
            ],
            [
                "name": "花木兰",
                "skill": [
                    [
                        "name": "空裂斩",
                        "desc": "花木兰冲锋后向指定方向挥砍，对命中的目标造成80/90/100/110/120/130（+43%物理加成）点物理伤害；如果该技能命中目标，可在5秒内发起第二次空裂斩",
                    ],
                    [
                        "name": "旋舞之华",
                        "desc": "花木兰向指定方向投掷轻剑，对路径上的敌人造成180/200/220/240/260/280（+90%物理加成）点物理伤害，轻剑会在终点旋转3秒，对范围内敌人每0.5秒造成72（+36%物理加成）点物理伤害并减少50%移动速度，持续1秒；拾起轻剑会减少5秒旋舞之华的冷却时间",
                    ],
                    [
                        "name": "绽放刀锋",
                        "desc": "花木兰拔出重剑横扫，对附近的敌人造成200/280/360（+110%物理加成）点物理伤害，同时增加60点攻击力，持续5秒；拔出重剑后，会使用重剑技能",
                    ],
                ],
            ],
            [
                "name": "干将莫邪",
                "skill": [
                    [
                        "name": "护主邪冢",
                        "desc": "干将连续两次将剑冢用力向前推刺出并自身后移，剑冢造成300/350/400/450/500/550（+50%法术加成）点法术伤害并击飞击退敌人。剑冢击伤的敌人3秒内降低150/180/210/240/270/300点法术防御。被动：每次击败英雄或助攻，剑冢都为干将增加自身15点永久法术强度，最高20层。",
                    ],
                    [
                        "name": "雌雄双剑·近",
                        "desc": "凌空成剑，释放雄剑，雄剑沿着曲型弹道飞行对敌方造成400/485/570/655/740/825（+40%法术加成）点法术伤害。",
                    ],
                    [
                        "name": "雌雄双剑·远",
                        "desc": "凌空成剑，释放雄剑，雄剑沿着曲型弹道飞行对敌方造成400/485/570/655/740/825（+40%法术加成）点法术伤害。",
                    ],
                    [
                        "name": "剑来",
                        "desc": "干将立刻刷新飞剑技能，并唤出更多的剑来强化下一次飞剑技能。被动：莫邪时刻观察着战场，将增加15%视野距离，每一股飞剑命中敌人减少剑来一秒CD。",
                    ],
                ],
            ],
            [
                "name": "李信",
                "skill": [
                    [
                        "name": "急速突进",
                        "desc": "李信向指定方向进行突进；无畏冲锋：李信积蓄力量，解除减速效果，免疫控制并增加150点移动速度和每0.5秒50点生命回复，如果李信蓄力超过1秒，在蓄力结束时会提升30%攻击速度持续3秒，同时蓄力增加的移动速度也不会直接结束而是在3秒内缓慢结束。李信每次普攻命中敌人都可以减少一技能1秒的冷却时间；希望之跃：李信积蓄力量，结束后向指定方向突进并造成50/60/70/80（+50%物理加成）～150/180/210/240（+150%物理加成）点物理伤害并会附加目标已损生命值12%的物理伤害。蓄力1秒后伤害达到上限，蓄力打断返还40%的冷却时间，李信在技能蓄力的过程中免疫控制效果并减少20%所受到的伤害，免疫控制效果会延续到技能释放阶段",
                    ],
                    [
                        "name": "强力斩击",
                        "desc": "李信向指定方向斩出剑气，对路径上敌人造成250/300/350/400/450/500（+100%物理加成）点物理伤害和减速持续2秒；残暴撕裂：李信向指定方向斩出剑气，对路径上的敌人造成280/330/380/430（+80%物理加成）点物理伤害和50%减速持续2秒，被剑气命中的敌人还会被撕裂，使得李信的普通攻击会对其造成额外90/108/126/144点物理伤害，当剑气命中敌方英雄时，李信该形态下的普通攻击还可以回复25/30/35/40点生命值；迅烈之华：李信持续向指定方向斩出剑气，对路径上敌人造成100/120/140/160（+150%物理加成）点物理伤害，如果剑气命中敌人，则李信回复10%物理加成点生命值",
                    ],
                    [
                        "name": "力量觉醒·光",
                        "desc": "李信学习大招的瞬间解放魔道家族的力量，改变战斗形态至统御；暗影爆发：李信释放力量，短暂延迟后以释放点为中心对范围内敌人造成600/900/1200（+120%物理加成）点物理伤害和0.75秒击飞；光翼连斩：李信积蓄力量，结束后向指定方向斩出三道剑气，对路径上敌人造成150/200/250（+75%物理加成），最大为450/600/750（+225%物理加成）点物理伤害，当多道剑气命中同个目标时，从第二道剑气开始将只造成30%的伤害；蓄力1秒后伤害达到上限，蓄力打断会返还40%的冷却时间，李信在技能蓄力的过程中免疫控制效果并减少20%所受到的伤害，免疫控制效果会延续到技能释放阶段",
                    ],
                    [
                        "name": "力量觉醒·暗",
                        "desc": "李信学习大招的瞬间解放黑暗复仇的力量，改变战斗形态至狂暴；力量掌控：李信压制身体内狂暴的力量，转化为统御形态，变身过程无法被控制技能打断；力量解放：李信解放身体内狂暴的力量，转化为狂暴形态，变身过程无法被控制技能打断",
                    ],
                ],
            ],
            [
                "name": "花木兰",
                "skill": [
                    [
                        "name": "空裂斩",
                        "desc": "花木兰冲锋后向指定方向挥砍，对命中的目标造成80/90/100/110/120/130（+43%物理加成）点物理伤害；如果该技能命中目标，可在5秒内发起第二次空裂斩",
                    ],
                    [
                        "name": "旋舞之华",
                        "desc": "花木兰向指定方向投掷轻剑，对路径上的敌人造成180/200/220/240/260/280（+90%物理加成）点物理伤害，轻剑会在终点旋转3秒，对范围内敌人每0.5秒造成72（+36%物理加成）点物理伤害并减少50%移动速度，持续1秒；拾起轻剑会减少5秒旋舞之华的冷却时间",
                    ],
                    [
                        "name": "绽放刀锋",
                        "desc": "花木兰拔出重剑横扫，对附近的敌人造成200/280/360（+110%物理加成）点物理伤害，同时增加60点攻击力，持续5秒；拔出重剑后，会使用重剑技能",
                    ],
                ],
            ],
            [
                "name": "程咬金",
                "skill": [
                    [
                        "name": "爆裂双斧",
                        "desc": "程咬金向指定目标位置猛力一跃并挥动双斧斩击，对范围内敌人造成120/155/190/225/260/295（+50%物理加成）点物理伤害并造成50%的减速效果，持续2秒；被动：程咬金的普通攻击命中敌方英雄会减少1秒爆裂双斧的冷却时间。",
                    ],
                    [
                        "name": "激热回旋",
                        "desc": "程咬金转动双斧劈砍敌人，对范围内的敌人造成两段伤害，每段造成125/150/175/200/225/250（+60%物理加成）点物理伤害。",
                    ],
                    [
                        "name": "正义潜能",
                        "desc": "程咬金迸发正义热情，每秒回复8%最大生命，同时增加移动速度30%，持续5秒。",
                    ],
                ],
            ],
            [
                "name": "李信",
                "skill": [
                    [
                        "name": "急速突进",
                        "desc": "李信向指定方向进行突进；无畏冲锋：李信积蓄力量，解除减速效果，免疫控制并增加150点移动速度和每0.5秒50点生命回复，如果李信蓄力超过1秒，在蓄力结束时会提升30%攻击速度持续3秒，同时蓄力增加的移动速度也不会直接结束而是在3秒内缓慢结束。李信每次普攻命中敌人都可以减少一技能1秒的冷却时间；希望之跃：李信积蓄力量，结束后向指定方向突进并造成50/60/70/80（+50%物理加成）～150/180/210/240（+150%物理加成）点物理伤害并会附加目标已损生命值12%的物理伤害。蓄力1秒后伤害达到上限，蓄力打断返还40%的冷却时间，李信在技能蓄力的过程中免疫控制效果并减少20%所受到的伤害，免疫控制效果会延续到技能释放阶段",
                    ],
                    [
                        "name": "强力斩击",
                        "desc": "李信向指定方向斩出剑气，对路径上敌人造成250/300/350/400/450/500（+100%物理加成）点物理伤害和减速持续2秒；残暴撕裂：李信向指定方向斩出剑气，对路径上的敌人造成280/330/380/430（+80%物理加成）点物理伤害和50%减速持续2秒，被剑气命中的敌人还会被撕裂，使得李信的普通攻击会对其造成额外90/108/126/144点物理伤害，当剑气命中敌方英雄时，李信该形态下的普通攻击还可以回复25/30/35/40点生命值；迅烈之华：李信持续向指定方向斩出剑气，对路径上敌人造成100/120/140/160（+150%物理加成）点物理伤害，如果剑气命中敌人，则李信回复10%物理加成点生命值",
                    ],
                    [
                        "name": "力量觉醒·光",
                        "desc": "李信学习大招的瞬间解放魔道家族的力量，改变战斗形态至统御；暗影爆发：李信释放力量，短暂延迟后以释放点为中心对范围内敌人造成600/900/1200（+120%物理加成）点物理伤害和0.75秒击飞；光翼连斩：李信积蓄力量，结束后向指定方向斩出三道剑气，对路径上敌人造成150/200/250（+75%物理加成），最大为450/600/750（+225%物理加成）点物理伤害，当多道剑气命中同个目标时，从第二道剑气开始将只造成30%的伤害；蓄力1秒后伤害达到上限，蓄力打断会返还40%的冷却时间，李信在技能蓄力的过程中免疫控制效果并减少20%所受到的伤害，免疫控制效果会延续到技能释放阶段",
                    ],
                    [
                        "name": "力量觉醒·暗",
                        "desc": "李信学习大招的瞬间解放黑暗复仇的力量，改变战斗形态至狂暴；力量掌控：李信压制身体内狂暴的力量，转化为统御形态，变身过程无法被控制技能打断；力量解放：李信解放身体内狂暴的力量，转化为狂暴形态，变身过程无法被控制技能打断",
                    ],
                ],
            ],
            [
                "name": "花木兰",
                "skill": [
                    [
                        "name": "空裂斩",
                        "desc": "花木兰冲锋后向指定方向挥砍，对命中的目标造成80/90/100/110/120/130（+43%物理加成）点物理伤害；如果该技能命中目标，可在5秒内发起第二次空裂斩",
                    ],
                    [
                        "name": "旋舞之华",
                        "desc": "花木兰向指定方向投掷轻剑，对路径上的敌人造成180/200/220/240/260/280（+90%物理加成）点物理伤害，轻剑会在终点旋转3秒，对范围内敌人每0.5秒造成72（+36%物理加成）点物理伤害并减少50%移动速度，持续1秒；拾起轻剑会减少5秒旋舞之华的冷却时间",
                    ],
                    [
                        "name": "绽放刀锋",
                        "desc": "花木兰拔出重剑横扫，对附近的敌人造成200/280/360（+110%物理加成）点物理伤害，同时增加60点攻击力，持续5秒；拔出重剑后，会使用重剑技能",
                    ],
                ],
            ],
            [
                "name": "干将莫邪",
                "skill": [
                    [
                        "name": "护主邪冢",
                        "desc": "干将连续两次将剑冢用力向前推刺出并自身后移，剑冢造成300/350/400/450/500/550（+50%法术加成）点法术伤害并击飞击退敌人。剑冢击伤的敌人3秒内降低150/180/210/240/270/300点法术防御。被动：每次击败英雄或助攻，剑冢都为干将增加自身15点永久法术强度，最高20层。",
                    ],
                    [
                        "name": "雌雄双剑·近",
                        "desc": "凌空成剑，释放雄剑，雄剑沿着曲型弹道飞行对敌方造成400/485/570/655/740/825（+40%法术加成）点法术伤害。",
                    ],
                    [
                        "name": "雌雄双剑·远",
                        "desc": "凌空成剑，释放雄剑，雄剑沿着曲型弹道飞行对敌方造成400/485/570/655/740/825（+40%法术加成）点法术伤害。",
                    ],
                    [
                        "name": "剑来",
                        "desc": "干将立刻刷新飞剑技能，并唤出更多的剑来强化下一次飞剑技能。被动：莫邪时刻观察着战场，将增加15%视野距离，每一股飞剑命中敌人减少剑来一秒CD。",
                    ],
                ],
            ],
            [
                "name": "花木兰",
                "skill": [
                    [
                        "name": "空裂斩",
                        "desc": "花木兰冲锋后向指定方向挥砍，对命中的目标造成80/90/100/110/120/130（+43%物理加成）点物理伤害；如果该技能命中目标，可在5秒内发起第二次空裂斩",
                    ],
                    [
                        "name": "旋舞之华",
                        "desc": "花木兰向指定方向投掷轻剑，对路径上的敌人造成180/200/220/240/260/280（+90%物理加成）点物理伤害，轻剑会在终点旋转3秒，对范围内敌人每0.5秒造成72（+36%物理加成）点物理伤害并减少50%移动速度，持续1秒；拾起轻剑会减少5秒旋舞之华的冷却时间",
                    ],
                    [
                        "name": "绽放刀锋",
                        "desc": "花木兰拔出重剑横扫，对附近的敌人造成200/280/360（+110%物理加成）点物理伤害，同时增加60点攻击力，持续5秒；拔出重剑后，会使用重剑技能",
                    ],
                ],
            ],
        ]

        let models = myArray.map { (dic) -> HeroModel in
            HeroModel(fromDictionary: dic as! Dictionary)
        }

        return models
    }
}
