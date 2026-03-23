# 三合一

仓库地址：https://github.com/momoinGH/TE_github


tro_作为公共模块前缀，新的命名建议都用这个作为前缀


添加ComponentAction：
1. 如果发现现有ACTION不满足自己的需求，并且需求只为了几个预制件服务，可以用一个比较通用的组件tro_componentaction，这个组件在预制件文件里主客机共有的地方添加，代码简便


覆盖原有组件或预制件：
1. 如果是修改原有预制件，建议在模块/prefabs目录下创建对应文件名字的文件，然后在模块/prefabpost.lua文件里modimport导入，组件同理，在模块/components目录下创建同名文件然后导入，同样的全局函数也是这样，找到函数定义的文件在模块目录里创建该文件然后导入


海难小船逻辑：
1. 玩家上船后会设置tro_driver.boat变量，表示正在驾驶这个船，可以直接用inst:TroGetSWBoat()获取玩家正在驾驶的船
8. 相关组件：
   1. tro_driver：玩家身上航海组件
   2. shipwreckedboat：小船身上
   3. shipwreckedboatparts：船配件身上
9. 单机版用OverrideSymbol替换玩家贴图，玩家播放对应动画帆布和螺旋桨就能动起来，但是联机版不会动，目前不知道为什么，可能是因为联机和单机角色动画通道不一样
10. 标签说明：
    1.  shipwrecked_boat：小船标签
    2.  shipwrecked_boat_head：船头配件
    3.  shipwrecked_boat_tail：船尾配件
11. 小船配件必须有shipwrecked_boat_head或者shipwrecked_boat_tail标签


小房子逻辑：
1. 小房子是生成在虚空（地图外面）的
2. 通过tro_roomspawner组件每次获取一个新的坐标点作为房子中心开始生成房子
3. 每个小房子都有一个中心点对象interior_center，这个对象在小房子的中心位置，对象上会记录房子的宽高数据
4. 小房子的门对象会记录中心点对象，还有所连接的目标门对象，这用于在客户端上绘制小地图
5. 小房子横向为z右为正，纵向为x下为正，这是由进入房间时固定的相机角度决定的
6. 标签说明：
   1. playercrafted：是否是玩家建造的，玩家建造的东西可以拿可以摧毁，否则拿了会触发警卫或者不能摧毁
   2. interior_center：中心点对象的标签，一般用于检查玩家当前在不在小房间内


地形生成：
1. 每个task有一些锁locks，也有一些钥匙keys_given，解锁该task需要有这些锁的钥匙，解锁后就能获得该task的所有钥匙，有了这些钥匙就能用于解锁其他的task，相互依赖
2. 地形层级递进关系：layout、room、task、taskSet、location、level



哈姆雷特标签说明：
angry_at_player：仇恨玩家
atdesk：猪人在桌子上趴着



冰岛只有冬天，哈姆雷特、海难、海底没有夏天，提供了两个方法inst:TroIsWinter()和inst:TroIsSummer()来判断实体所处位置的季节，如果四季都要判断，建议把else留给春天的处理
针对world的snowlevel事件进行了hook，实体如果监听了这个事件倒是能拿到带有地形判断后的snowlevel