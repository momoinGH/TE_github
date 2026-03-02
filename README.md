tro_作为公共模块前缀，新的命名建议都用这个作为前缀


海难小船逻辑：
1. 玩家上船后会设置pro_driver.boat变量，表示正在驾驶这个船
8. 相关组件：
   1. pro_driver：玩家身上航海组件
   2. shipwreckedboat：小船身上
   3. shipwreckedboatparts：船配件身上
9. 单机版用OverrideSymbol替换玩家贴图，玩家播放对应动画帆布和螺旋桨就能动起来，但是联机版不会动，目前不知道为什么，可能是因为联机和单机角色动画通道不一样


添加ComponentAction：
1. 建议在每个模块的componentactions.lua文件里添加，调用TRO_AddComponentAction方法来添加
2. 如果发现现有ACTION不满足自己的需求，并且需求只为了几个预制件服务，可以用一个比较通用的组件pro_componentaction，这个组件在预制件文件里主客机共有的地方添加，代码简便

