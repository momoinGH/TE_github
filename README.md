tro_作为公共模块前缀，新的命名建议都用这个作为前缀


海难小船逻辑：
1. 玩家上船后将装备小船，同时小船生成一个复制体挂在玩家身上
2. 复制体所有特征与小船一样，不过自己container里面没有东西，通过container_proxy和小船内容一致
4. 玩家下船时删除复制体，装备的小船掉落
5. 玩家退出游戏重进时，由于复制体不会保存，所以重新上线时会重新生成一个复制体
6. 动画数据小船和复制体应该一起修改
7. 在combat的GetAttacked中检查是否装备了船，扣除船的血量
8. 相关组件：
   1. pro_driver：玩家身上航海组件
   2. shipwreckedboat：小船身上
   3. shipwreckedboatparts：船配件身上


添加ComponentAction：
1. 建议在每个模块的componentactions.lua文件里添加，调用TRO_AddComponentAction方法来添加
2. 如果发现现有ACTION不满足自己的需求，并且需求只为了几个预制件服务，可以用一个比较通用的组件pro_componentaction，这个组件在预制件文件里主客机共有的地方添加，代码简便

