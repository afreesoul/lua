---xx 命名空间
---@class xx
---@field CSEvent CSEvent
---@field Util Util
xx = xx or {}
---版本号
---@type string
xx.version = "1.0.0"
---打印版本号
print("xx(lua) version: " .. xx.version)
---id 种子
---@type number
local __uidSeed = 0
---获取一个新的 id
---@type fun():string
---@return string 返回新的 id
function xx.newUID()
    __uidSeed = __uidSeed + 1
    return string.format("xx_lua_%d", __uidSeed)
end
---@alias Handler fun(...:any[]):any
---用于封装的 self Handler 回调
---@type fun(handler:Handler,caller:any|nil,...:any):Handler
---@param handler Handler 需要封装的回调函数
---@param caller any|nil 需要封装的监听函数所属对象
---@vararg any
---@return Handler 封装的回调函数
function xx.Handler(handler, caller, ...)
    local cache = {...}
    if 0 == xx.arrayCount(cache) then
        cache = nil
    end
    return function(...)
        if caller then
            if cache then
                return handler(caller, unpack(cache), ...)
            else
                return handler(caller, ...)
            end
        else
            if cache then
                return handler(unpack(cache), ...)
            else
                return handler(...)
            end
        end
    end
end
---解构数组
---@type fun(data:table):...
unpack = unpack or table.unpack
---是否是 nil
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isNil(target)
    return nil == target
end
---是否是 boolean
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isBoolean(target)
    return "boolean" == type(target)
end
---是否是 number
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isNumber(target)
    return "number" == type(target)
end
---是否是 string
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isString(target)
    return "string" == type(target)
end
---是否是 function
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isFunction(target)
    return "function" == type(target)
end
---是否是 table
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isTable(target)
    return "table" == type(target)
end
---是否是 userdata
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isUserdata(target)
    return "userdata" == type(target)
end
---是否是 thread
---@type fun(target:any):boolean
---@param target any 数据对象
---@return boolean
function xx.isThread(target)
    return "thread" == type(target)
end
---清空表
---@type fun(map:table):table
---@param map table 表
---@return table map
function xx.tableClear(map)
    for key, _ in pairs(map) do
        map[key] = nil
    end
    return map
end
---拷贝表
---@type fun(map:table, recursive:boolean):table
---@param map table 表
---@param recursive boolean|nil true 表示需要深度拷贝，默认 false
---@return table 拷贝的表对象
function xx.tableClone(map, recursive)
    local copy = {}
    for key, value in pairs(map) do
        if "table" == type(value) and recursive then
            copy[key] = xx.tableClone(value, recursive)
        else
            copy[key] = value
        end
    end
    return copy
end
---合并表
---@type fun(map:table, ...:table):table
---@param map table 表
---@vararg table
---@return table map
function xx.tableMerge(map, ...)
    local mapList = {...}
    for i = 1, xx.arrayCount(mapList) do
        if xx.isTable(mapList[i]) then
            for k, v in pairs(mapList[i]) do
                map[k] = v
            end
        end
    end
    return map
end
---计算指定表键值对数量
---@type fun(map:table):number
---@param map table 表
---@return number 返回表数量
function xx.tableCount(map)
    local count = 0
    for _, __ in pairs(map) do
        count = count + 1
    end
    return count
end
---获取指定表的所有键
---@type fun(map:table):any[]
---@param map table 表
---@return any[] 键列表
function xx.tableKeys(map)
    local keys = {}
    for key, _ in pairs(map) do
        xx.arrayPush(keys, key)
    end
    return keys
end
---获取指定表的所有值
---@type fun(map:table):any[]
---@param map table 表
---@return any[] 值列表
function xx.tableValues(map)
    local values = {}
    for _, value in pairs(map) do
        xx.arrayPush(values, value)
    end
    return values
end
---获取数组最大索引
---@type fun(array:any[]):number
---@param array any[] 数组
---@return number 数组的最大索引
function xx.arrayCount(array)
    local index = 0
    for key, _ in pairs(array) do
        if xx.isNumber(key) and key > index then
            index = key
        end
    end
    return index
end
---清空数组
---@type fun(array:any[]):any[]
---@param array any[] 数组
---@return any[] array
function xx.arrayClear(array)
    for i = xx.arrayCount(array), 1, -1 do
        array[i] = nil
    end
    return array
end
---将指定数据插入数组中指定位置
---@type fun(array:any[],item:any,index:number|nil):any[]
---@param array any[] 数组
---@param item any 数据
---@param index number|nil 索引，默认 nil 表示插入数组末尾
---@return any[] array
function xx.arrayInsert(array, item, index)
    local count = xx.arrayCount(array)
    index = (not index or index > count) and count + 1 or (index < 1 and 1 or index)
    if index <= count then
        for i = count, index, -1 do
            array[i + 1] = array[i]
        end
    end
    array[index] = item
    return array
end
---将有大小区别的数据按升序插入有序数组
---@type fun(array:any[],value:any):any[]
---@param array any[] 数组
---@param value any 数据
---@return any[] array
function xx.arrayInsertASC(array, value)
    local index = 1
    for i = xx.arrayCount(array), 1, -1 do
        if array[i] <= value then
            index = i + 1
            break
        end
        array[i + 1] = array[i]
    end
    array[index] = value
    return array
end
---从数组中移除指定数据
---@type fun(array:any[], item:any):any[]
---@param array any[] 数组对象
---@param item any 需要移除的数据
---@return any[] array
function xx.arrayRemove(array, item)
    local iNew = 1
    for iOld = 1, xx.arrayCount(array) do
        if array[iOld] ~= item then
            if iNew ~= iOld then
                array[iNew] = array[iOld]
                array[iOld] = nil
            end
            iNew = iNew + 1
        else
            array[iOld] = nil
        end
    end
    return array
end
---删除数组中指定位置的数据并返回
---@type fun(array:any[],index:number):any|nil
---@param array any[] 数组
---@param index number 索引
---@return any|nil 删除的数据
function xx.arrayRemoveAt(array, index)
    local count = xx.arrayCount(array)
    if index and index >= 1 and index <= count then
        local item = array[index]
        if index < count then
            for i = index + 1, count do
                array[i - 1] = array[i]
            end
        end
        array[count] = nil
        return item
    end
end
---将多个数据插入数组末尾
---@type fun(array:any[],...:any):any[]
---@param array any[] 数组
---@vararg any
---@return any[] array
function xx.arrayPush(array, ...)
    local args = {...}
    local count = xx.arrayCount(array)
    for i = 1, xx.arrayCount(args) do
        array[count + i] = args[i]
    end
    return array
end
---删除数组最后一个数据并返回
---@type fun(array:any[]):any|nil
---@param array any[] 数组
---@return any|nil 返回删除的数据，如果失败则返回 nil
function xx.arrayPop(array)
    return xx.arrayRemoveAt(array, xx.arrayCount(array))
end
---将数据插入到最前面
---@type fun(array:any[],item:any):any[]
---@param array any[] 数组
---@param item any 数据
---@return any[] array
function xx.arrayUnshift(array, item)
    return xx.arrayInsert(array, item, 1)
end
---删除数组第一个数据并返回
---@type fun(array:any[]):any|nil
---@param array any[] 数组
---@return any|nil 返回删除的数据，如果失败则返回 nil
function xx.arrayShift(array)
    return xx.arrayRemoveAt(array, 1)
end
---查找数组中指定数据的索引
---@type fun(array:any[], item:any, from:number):number
---@param array any[] 数组对象
---@param item any 需要查找的数据
---@param from number|nil 从该索引开始查找（-1 表示最后一个元素），默认 1
---@return number 如果找到则返回对应索引（从 1 开始），否则返回 -1
function xx.arrayIndexOf(array, item, from)
    local count = xx.arrayCount(array)
    from = from and (from < 0 and count + from + 1 or from) or 1
    for index = from < 1 and 1 or from, count do
        if array[index] == item then
            return index
        end
    end
    return -1
end
---查找数组中指定数据的索引
---@type fun(array:any[], item:any, from:number):number
---@param array any[] 数组对象
---@param item any 需要查找的数据
---@param from number|nil 从该索引开始查找（-1 表示最后一个元素），默认 -1
---@return number 如果找到则返回对应索引（从 1 开始），否则返回 -1
function xx.arrayLastIndexOf(array, item, from)
    local count = xx.arrayCount(array)
    from = from and (from < 0 and count + from + 1 or from) or count
    for i = from > count and count or from, 1, -1 do
        if array[i] == item then
            return i
        end
    end
    return -1
end
---判断指定数组中是否存在指定数据
---@type fun(array:any[],item:any):boolean
---@param array any[] 数组
---@param item any 数据
---@return boolean 如果存在则返回 true，否则返回 false
function xx.arrayContains(array, item)
    for i = 1, xx.arrayCount(array) do
        if item == array[i] then
            return true
        end
    end
    return false
end
---从数组中构建指定范围的一个新数组
---@type fun(array:any[],start:number|nil,stop:number|nil):any[]
---@param array any[] 数组
---@param start number|nil 起始索引（-1 表示最后一个元素），默认 1
---@param stop number|nil 结束索引（-1 表示最后一个元素，新构建的数组包含该索引数据），默认 -1
---@return anyp[] 新数组
function xx.arraySlice(array, start, stop)
    local count = xx.arrayCount(array)
    start = start and (start < 0 and count + start + 1 or start) or 1
    stop = stop and (stop < 0 and count + stop + 1 or stop) or count
    local j = 1
    local result = {}
    for i = start < 1 and 1 or start, stop > count and count or stop do
        result[j] = array[i]
        j = j + 1
    end
    return result
end
---合并数组
---@type fun(array:any[], ...:any[]):any[]
---@param array 数组
---@vararg any[]
---@return any[] array
function xx.arrayMerge(array, ...)
    local index = xx.arrayCount(array) + 1
    local arrayList = {...}
    for i = 1, xx.arrayCount(arrayList) do
        if xx.isTable(arrayList[i]) then
            for j = 1, xx.arrayCount(arrayList[i]) do
                array[index] = arrayList[i][j]
                index = index + 1
            end
        end
    end
    return array
end
---判断当前协程是否可 yield
---@type fun():boolean
---@return boolean
coroutine.isyieldable = function()
    local _, isMain = coroutine.running()
    return not isMain
end
---自定义类
---@class SubClass
---@field __className 类名
---@field __superClass 基类
---@field __metatable 元数据
---类定义
---@class Class by wx771720@outlook.com 2019-08-07 15:04:24
---@param name string 类名
---@param super SubClass|nil 基类，如果不指定默认为 ObjectEx
---@return SubClass 返回类
local Class = {__nameClassMap = {}}
---@see Class
xx.Class = Class
---getter 取值
---@type fun(instance:ObjectEx, key:string):any
---@param instance ObjectEx 对象
---@param key string 属性键
---@return any
function Class.getter(instance, key)
    if not xx.isNil(instance.__proxy[key]) then
        return instance.__proxy[key]
    end
    if not xx.isNil(instance.__class) and not xx.isNil(instance.__class[key]) then
        return instance.__class[key]
    end
end
---setter 设置值
---@type fun(instance:ObjectEx, key:string, value:any)
---@param instance ObjectEx 对象
---@param key string 属性键
---@param value any 属性值
function Class.setter(instance, key, value)
    instance.__proxy[key] = value
end
---判断指定表是否是类
---@type fun(class:SubClass):boolean
---@param class SubClass 表
---@return boolean 如果是类则返回 true，否则返回 false
function Class.isClass(class)
    return xx.isTable(class) and xx.isString(class.__className) and xx.isTable(class.__metatable)
end
---指定表是否是实例
---@type fun(instance:ObjectEx):boolean
---@param instance ObjectEx 表
---@return boolean 如果是实例则返回 true，否则返回 false
function Class.isInstance(instance)
    return xx.isTable(instance) and Class.isClass(instance.__class)
end
---获取指定类名的类
---@type fun(name:string):SubClass
---@param name string 类名
---@return SubClass|nil 如果找到则返回类，否则返回 nil
function Class.getClass(name)
    return Class.__nameClassMap[name]
end
---判断对象是否是指定类的实例
---@type fun(instance:ObjectEx, class:SubClass):boolean
---@param instance ObjectEx 实例对象
---@param class SubClass 类
---@return boolean 如果 instance 对象是 class 的实例则返回 true，否则返回 false
function Class.instanceOf(instance, class)
    if Class.isInstance(instance) then
        local loopClass = instance.__class
        while loopClass do
            if loopClass == class then
                return true
            end
            loopClass = loopClass.__superClass
        end
    end
    return false
end
---@see Class#instanceOf
xx.instanceOf = Class.instanceOf
---[ctor]: 构造函数（从上往下），参数：...
---[ctored]: 构造函数（从下往上），参数：...
---[getter]: 获取属性值，参数：key, return 透传
---[setter]: 设置属性值，参数：key, value
---[call]: 对象执行函数，参数：...，return 透传
---[add]: 相加函数，参数：target，return 透传
---[sub]: 想减函数，参数：target，return 透传
---[equalTo]: 比较函数，参数：target，return boolean
---[lessThan]: 小于函数，参数：target，return boolean
---[lessEqual]: 小于等于函数，参数：target，return boolean
---[toString]: 转换为字符串，return string
local __instanceMetatable = {
    __index = function(instance, key)
        local getter = Class.getter(instance, "getter")
        if xx.isFunction(getter) then
            return getter(instance, key)
        end
        return Class.getter(instance, key)
    end,
    __newindex = function(instance, key, value)
        local setter = Class.getter(instance, "setter")
        if xx.isFunction(setter) then
            setter(instance, key, value)
        else
            Class.setter(instance, key, value)
        end
    end,
    __call = function(instance, ...)
        local callFunc = instance.call
        if xx.isFunction(callFunc) then
            return callFunc(instance, ...)
        end
    end,
    __add = function(instance, target)
        local addFunc = instance.add
        if xx.isFunction(addFunc) then
            return addFunc(instance, target)
        end
    end,
    __sub = function(instance, target)
        local subFunc = instance.sub
        if xx.isFunction(subFunc) then
            return subFunc(instance, target)
        end
    end,
    __eq = function(instance, target)
        local equalToFunc = instance.equalTo
        if xx.isFunction(equalToFunc) then
            return equalToFunc(instance, target)
        end
    end,
    __lt = function(instance, target)
        local lessThanFunc = instance.lessThan
        if xx.isFunction(lessThanFunc) then
            return lessThanFunc(instance, target)
        end
    end,
    __le = function(instance, target)
        local lessEqualFunc = instance.lessEqual
        if xx.isFunction(lessEqualFunc) then
            return lessEqualFunc(instance, target)
        end
    end,
    __tostring = function(instance)
        local toStringFunc = instance.toString
        if xx.isFunction(toStringFunc) then
            return toStringFunc(instance)
        end
    end
}
---新建类
---@type fun(name:string, super:SubClass):SubClass
---@param name string 类名，会覆盖已存在的同名类
---@param super SubClass|nil 基类
---@return SubClass 返回新建的类
function Class.newClass(name, super)
    local class =
        setmetatable(
        {__className = name, __superClass = super, __metatable = __instanceMetatable},
        {
            __index = super,
            __call = function(class, ...)
                local instance =
                    setmetatable({__class = class, __proxy = {}, __isConstructed = false}, class.__metatable)
                local ctorList = {}
                local ctoredList = {}
                local loopClass = class
                while loopClass do
                    local ctor = rawget(loopClass, "ctor")
                    if xx.isFunction(ctor) then
                        xx.arrayPush(ctorList, ctor)
                    end
                    local ctored = rawget(loopClass, "ctored")
                    if xx.isFunction(ctored) then
                        xx.arrayPush(ctoredList, ctored)
                    end
                    loopClass = loopClass.__superClass
                end
                for index = xx.arrayCount(ctorList), 1, -1 do
                    ctorList[index](instance, ...)
                end
                for index = 1, xx.arrayCount(ctoredList) do
                    ctoredList[index](instance, ...)
                end
                instance.__isConstructed = true
                return instance
            end
        }
    )
    Class.__nameClassMap[name] = class
    return class
end
---基类（所有通过 Class 定义的类都默认继承自该类）
---@class ObjectEx by wx771720@outlook.com 2019-08-07 14:33:35
---@field uid string 唯一标识
---@field __class SubClass 类型
---@field __proxy table 属性
---@field __isConstructed boolean 是否已构造完成
xx.ObjectEx = Class.newClass("ObjectEx")
---构造函数
function xx.ObjectEx:ctor()
    self.uid = xx.newUID()
end
---转换成字符串
---@return string
function xx.ObjectEx:toString()
    return self.uid
end
---setter
---@type fun(key:string|number, value:any)
---@param key string|number 属性键
---@param value any 属性值
function xx.ObjectEx:setter(key, value)
    local oldValue = self[key]
    if oldValue == value then
        return
    end
    Class.setter(self, key, value)
    if self.__isConstructed and xx.isFunction(self.onDynamicChanged) then
        self:onDynamicChanged(key, value, oldValue)
    end
end
setmetatable(
    Class,
    {
        __call = function(_, name, super)
            return Class.newClass(name, super or xx.ObjectEx)
        end
    }
)
---GID 类（由工具自动生成，请勿手动修改）
---@class GIdentifiers author wx771720[outlook.com]
GIdentifiers = GIdentifiers or {}
---已改变事件
---@param name string 改变的属性、字段等名字
---@param newValue any 改变后的值
---@param oldValue any 改变前的值
GIdentifiers.e_changed = "e_changed"
---完成事件
---@param ... any[] 携带的数据
GIdentifiers.e_complete = "e_complete"
---根节点改变事件
---@param oldRoot Node 之前的根节点
GIdentifiers.e_root_changed = "e_root_changed"
---将要添加到父节点事件
---@param child Node 添加的子节点
GIdentifiers.e_add = "e_add"
---已添加子节点事件
---@param child Node 添加的子节点
GIdentifiers.e_added = "e_added"
---将要移除子节点事件
---@param child Node 移除的子节点
GIdentifiers.e_remove = "e_remove"
---已移除子节点事件
---@param child Node 移除的子节点
GIdentifiers.e_removed = "e_removed"
---指针移入事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_enter = "e_enter"
---指针移出事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_exit = "e_exit"
---指针按下事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_down = "e_down"
---指针释放事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_up = "e_up"
---指针点击事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_click = "e_click"
---指针开始拖拽事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_drag_begin = "e_drag_begin"
---指针拖拽移动事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_drag_move = "e_drag_move"
---指针拖拽结束事件
---@param screenX float 屏幕 x 坐标
---@param screenY float 屏幕 y 坐标
---@param screenY PointerEventData 事件原始对象
GIdentifiers.e_drag_end = "e_drag_end"
---<summary>
---粒子结束时事件
---</summary>
GIdentifiers.e_particle_complete = "e_particle_complete"
---<summary>
---按 url 资源名字类型加载资源（字符串、字节数组）
---</summary>
---<para name="url">string 资源地址</para>
---<para name="type">string 资源类型，null 表示按 url 类型加载</para>
---<para name="tryCount">int 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试</para>
---<para name="tryDelay">int 加载超时后重试间隔时长（单位：毫秒）</para>
---<para name="timeout">int 加载超时时长（单位：毫秒）</para>
---<para name="onRetry">Callback 重试时回调</para>
---<para name="onComplete">Callback 加载完成后回调，参数：string|byte[]|null</para>
---<returns>string 加载 id</returns>
GIdentifiers.ni_load = "ni_load"
---<summary>
---停止加载
---</summary>
---<para name="id">string 加载 id</para>
GIdentifiers.ni_load_stop = "ni_load_stop"
---加载类型：二进制
GIdentifiers.load_type_binary = "binary"
---加载类型：字符串
GIdentifiers.load_type_string = "string"
---加载类型：Texture
GIdentifiers.load_type_texture = "texture"
---加载类型：Sprite
GIdentifiers.load_type_sprite = "sprite"
---加载类型：AudioClip
GIdentifiers.load_type_audioclip = "audioclip"
---加载类型：AssetBundle
GIdentifiers.load_type_assetbundle = "assetbundle"
---新建定时器
---@param duration number 回调执行间隔（单位：毫秒）
---@param count number 小于等于 0 表示无限次数
---@param onOnce Callback 指定间隔后执行回调，参数：number（实际经过的时长，单位：毫秒），number（当前是第几次执行）
---@param onComplete Callbac 指定次数执行完成后回调
---@return string 定时器 id
GIdentifiers.ni_timer_new = "ni_timer_new"
---暂停定时器
---@param id string 新建定时器时返回的 id
GIdentifiers.ni_timer_pause = "ni_timer_pause"
---继续定时器
---@param id string 新建定时器时返回的 id
GIdentifiers.ni_timer_resume = "ni_timer_resume"
---停止定时器
---@param id string 新建定时器时返回的 id
---@param trigger boolean 是否触发完成回调，默认 false
GIdentifiers.ni_timer_stop = "ni_timer_stop"
---修改定时器速率
---@param id string 新建定时器时返回的 id
---@param rate number 定时器速率，默认 1 表示恢复正常速率
GIdentifiers.ni_timer_rate = "ni_timer_rate"
------创建缓动器
------@param targets ... 缓动目标列表
------@return Tween
GIdentifiers.ni_tween_new = "ni_tween_new"
------停止缓动对象
------@param target any 缓动目标
------@param trigger bool 是否在停止时触发回调，默认 false
------@param toEnd bool 是否在停止时设置属性为结束值，默认 false
GIdentifiers.ni_tween_stop = "ni_tween_stop"
---启动通知
GIdentifiers.nb_lauch = "nb_lauch"
---初始化通知
GIdentifiers.nb_initialize = "nb_initialize"
---定时通知
---@param interval double 一帧耗时（单位：毫秒）
GIdentifiers.nb_timer = "nb_timer"
---暂时通知
GIdentifiers.nb_pause = "nb_pause"
---继续通知
GIdentifiers.nb_resume = "nb_resume"
---json 转换工具（TODO 引用符号：重复引用，循环引用）
---@class JSON by wx771720@outlook.com 2019-08-07 16:03:34
local JSON = {escape = "\\", comma = ",", colon = ":", null = "null"}
---@see JSON
xx.JSON = JSON
---将任意非 nil 数据转换成 json 字符串
---@type fun(data:any,toArray:boolean,toFunction:boolean):string
---@param data any 任意非 nil 数据
---@param toArray boolean 如果是数组，是否按数组格式输出，默认 true
---@param toFunction boolean 是否输出函数，默认 false
---@return string 返回 json 格式的字符串
function JSON.toString(data, toArray, toFunction, __tableList, __keyList)
    if not xx.isBoolean(toArray) then
        toArray = true
    end
    if not xx.isBoolean(toFunction) then
        toFunction = false
    end
    if not xx.isTable(__tableList) then
        __tableList = {}
    end
    local dataType = type(data)
    if "function" == dataType then
        return toFunction and '"Function"' or nil
    end
    if "string" == dataType then
        data = string.gsub(data, "\\", "\\\\")
        data = string.gsub(data, '"', '\\"')
        return '"' .. data .. '"'
    end
    if "number" == dataType then
        return tostring(data)
    end
    if "boolean" == dataType then
        return data and "true" or "false"
    end
    if "table" == dataType then
        xx.arrayPush(__tableList, data)
        local result
        if toArray and JSON.isArray(data) then
            result = "["
            for i = 1, xx.arrayCount(data) do
                if xx.isTable(v) and xx.arrayContains(__tableList, v) then
                    print("json loop refs warning : " .. JSON.toString(xx.arrayPush(xx.arraySlice(__keyList), k)))
                else
                    local valueString =
                        JSON.toString(
                        data[i],
                        toArray,
                        toFunction,
                        xx.arraySlice(__tableList),
                        __keyList and xx.arrayPush(xx.arraySlice(__keyList), i) or {i}
                    )
                    result = result .. (i > 1 and "," or "") .. (valueString or JSON.null)
                end
            end
            result = result .. "]"
        else
            result = "{"
            local index = 0
            for k, v in pairs(data) do
                if xx.isTable(v) and xx.arrayContains(__tableList, v) then
                    print("json loop refs warning : " .. JSON.toString(xx.arrayPush(xx.arraySlice(__keyList), k)))
                else
                    local valueString =
                        JSON.toString(
                        v,
                        toArray,
                        toFunction,
                        xx.arraySlice(__tableList),
                        __keyList and xx.arrayPush(xx.arraySlice(__keyList), k) or {k}
                    )
                    if valueString then
                        result = result .. (index > 0 and "," or "") .. ('"' .. k .. '":') .. valueString
                        index = index + 1
                    end
                end
            end
            result = result .. "}"
        end
        return result
    end
end
---判断指定表是否是数组（不包含字符串索引的表）
---@type fun(target:any):boolean
---@param target any 表
---@return boolean 如果不包含字符串索引则返回 true，否则返回 false
JSON.isArray = function(target)
    if xx.isTable(target) then
        for k, v in pairs(target) do
            if xx.isString(k) then
                return false
            end
        end
        return true
    end
    return false
end
---将字符串转换成 table 对象
---@type fun(text:string):any
---@param text string json 格式的字符串
---@return any|nil 如果解析成功返回对应数据，否则返回 nil
JSON.toJSON = function(text)
    if '"' == string.sub(text, 1, 1) and '"' == string.sub(text, -1, -1) then
        return string.sub(JSON.findMeta(text), 2, -2)
    end
    local lowerText = string.lower(text)
    if "false" == lowerText then
        return false
    elseif "true" == lowerText then
        return true
    end
    if JSON.null == lowerText then
        return
    end
    local number = tonumber(text)
    if number then
        return number
    end
    if "[" == string.sub(text, 1, 1) and "]" == string.sub(text, -1, -1) then
        local remain = string.gsub(text, "[\r\n]+", "")
        remain = string.sub(remain, 2, -2)
        local array, index, value = {}, 1
        while #remain > 0 do
            value, remain = JSON.findMeta(remain)
            if value then
                value = JSON.toJSON(value)
                array[index] = value
                index = index + 1
            end
        end
        return array
    end
    if "{" == string.sub(text, 1, 1) and "}" == string.sub(text, -1, -1) then
        local remain = string.gsub(text, "[\r\n]+", "")
        remain = string.sub(remain, 2, -2)
        local key, value
        local map = {}
        while #remain > 0 do
            key, remain = JSON.findMeta(remain)
            value, remain = JSON.findMeta(remain)
            if key and #key > 0 and value then
                key = JSON.toJSON(key)
                value = JSON.toJSON(value)
                if key and value then
                    map[key] = value
                end
            end
        end
        return map
    end
end
---查找字符串中的 json 元数据
---@type fun(text:string):string, string
---@param text string json 格式的字符串
---@return string,string 元数据,剩余字符串
JSON.findMeta = function(text)
    local stack = {}
    local index = 1
    local lastChar = nil
    while index <= #text do
        local char = string.sub(text, index, index)
        if '"' == char then
            if char == lastChar then
                xx.arrayPop(stack)
                lastChar = #stack > 0 and stack[#stack] or nil
            else
                xx.arrayPush(stack, char)
                lastChar = char
            end
        elseif '"' ~= lastChar then
            if "{" == char then
                xx.arrayPush(stack, "}")
                lastChar = char
            elseif "[" == char then
                xx.arrayPush(stack, "]")
                lastChar = char
            elseif "}" == char or "]" == char then
                assert(char == lastChar, text .. " " .. index .. " not expect " .. char .. "<=>" .. lastChar)
                xx.arrayPop(stack)
                lastChar = #stack > 0 and stack[#stack] or nil
            elseif JSON.comma == char or JSON.colon == char then
                if not lastChar then
                    return string.sub(text, 1, index - 1), string.sub(text, index + 1)
                end
            end
        elseif JSON.escape == char then
            text = string.sub(text, 1, index - 1) .. string.sub(text, index + 1)
        end
        index = index + 1
    end
    return string.sub(text, 1, index - 1), string.sub(text, index + 1)
end
---计算指定的贝塞尔值
---@type fun(percent:number,...:number):number
---@param percent number 百分比
---@vararg number
---@return number 返回贝塞尔对应值
function xx.bezier(percent, ...)
    local values = {...}
    local count = xx.arrayCount(values) - 1
    while count > 0 do
        for i = 1, count do
            values[i] = values[i] + (values[i + 1] - values[i]) * percent
        end
        count = count - 1
    end
    return 0 == count and values[1] or 0
end
---从参数列表中获取回调参数
---@type fun(...:any):Callback
---@vararg any
---@return Callback|nil 如果找到则返回 Callback 对象，否则返回 nil
function xx.getCallback(...)
    local args = {...}
    local count = xx.arrayCount(args)
    if count > 0 then
        if xx.instanceOf(args[count], xx.Callback) then
            return args[count]
        end
    end
end
----从参数列表中获取异步对象参数
---@type fun(...:any):Promise
---@vararg any
---@return Promise 如果找到则返回 Promise 对象，否则返回 nil
function xx.getPromise(...)
    local args = {...}
    local count = xx.arrayCount(args)
    if count > 0 then
        if xx.instanceOf(args[count], xx.Promise) then
            return args[count]
        end
    end
end
---从参数列表中获取信号参数
---@type fun(...:any):Signal
---@vararg any
---@return Signal|nil 如果找到则返回 Signal 对象，否则返回 nil
function xx.getSignal(...)
    local args = {...}
    local count = xx.arrayCount(args)
    if count > 0 then
        if xx.instanceOf(args[count], xx.Signal) then
            return args[count]
        end
    end
end
---@type table<string, any> 类名 - 实例
local __singleton = {}
---添加一个类的实例作为其单例使用
---@type fun(instance:any):any
---@param instance any 对象
---@return any instance
function xx.addInstance(instance)
    if instance and instance.__class and instance.__class.__className then
        __singleton[instance.__class.__className] = instance
    end
    return instance
end
---移除一个类的单例实例
---@type fun(name:string):any
---@param name string 类名
---@return any 如果存在指定实例则返回，否则返回 nil
function xx.delInstance(name)
    local instance = __singleton[name]
    __singleton[name] = nil
    return instance
end
---获取一个类的单例实例
---@type fun(name:string):any
---@param name string 类名
---@return any 如果存在指定类名则返回对应单例对象，否则返回 nil
function xx.getInstance(name)
    if name then
        if __singleton[name] then
            return __singleton[name]
        end
        local class = xx.Class.getClass(name)
        if class then
            local instance = class()
            __singleton[name] = instance
            return instance
        end
    end
end
---位数组
---@class Bits
---@field numBits number 位数
local Bits
---位操作
---@class Bit:ObjectEx by wx771720@outlook.com 2020-01-02 18:15:39
local Bit = xx.Class("Bit")
---@see Bit
xx.Bit = Bit
---位数 - 最小值
---@type table<number,number>
Bit._bitMinMap = {1}
for i = 2, 64 do
    Bit._bitMinMap[i] = 2 * Bit._bitMinMap[i - 1]
end
---位数组缓存
---@type Bits[]
Bit._caches = {}
---位数组缓存数量
---@type number
Bit._numCaches = 0
---新建位数组
---@type fun(numBits:number,bit:number):Bits
---@param numBits number 位数
---@param bit number 初始化位的值，默认 0
---@return Bits 位数组
function Bit.new(numBits, bit)
    ---@type Bits
    local bits
    if Bit._numCaches > 0 then
        bits = Bit._caches[Bit._numCaches]
        Bit._caches[Bit._numCaches] = nil
        Bit._numCaches = Bit._numCaches - 1
    else
        bits = {}
    end
    bits.numBits = numBits
    bit = bit or 0
    for i = 1, bits.numBits do
        bits[i] = bit
    end
    return bits
end
---拷贝位数组
---@type fun(bits:Bits,beginBit:number,endBit:number):Bits
---@param bits Bits 位数组
---@param beginBit number 起始位，默认 nil 表示 1
---@param endBit number 结束位，默认 nil 表示 bits.numBits
---@return Bits 返回拷贝的位数组
function Bit.clone(bits, beginBit, endBit)
    beginBit = beginBit or 1
    endBit = endBit or bits.numBits
    local copy
    if endBit >= beginBit then
        copy = Bit.new(endBit - beginBit + 1)
        for i = 1, copy.numBits do
            if i + beginBit - 1 > bits.numBits then
                break
            end
            copy[i] = bits[i + beginBit - 1]
        end
    else
        copy = Bit.new(beginBit - endBit + 1)
        for i = 1, copy.numBits do
            if beginBit - i + 1 > bits.numBits then
                break
            end
            copy[i] = bits[beginBit - i + 1]
        end
    end
    return copy
end
---缓存位数组
---@type fun(...:Bits)
---@vararg Bits
function Bit.cache(...)
    for _, bits in ipairs({...}) do
        xx.arrayInsert(Bit._caches, bits)
    end
end
---重置位数组
---@type fun(bits:Bits,bit:number):Bits
---@param bits Bits 位数组
---@param bit number 初始化位的值，默认 0
---@return Bits bits
function Bit.reset(bits, bit)
    bit = bit or 0
    for i = 1, bits.numBits do
        bits[i] = bit
    end
    return bits
end
---判断位数组是否全是 0
---@type fun(bits:Bits,beginBit:number,endBit:number):boolean
---@param bits Bits 位数组
---@param beginBit number 起始位，默认 nil 表示 1
---@param endBit number 结束位，默认 nil 表示 bits.numBits
---@return boolean
function Bit.isEmpty(bits, beginBit, endBit)
    beginBit = beginBit or 1
    endBit = endBit or bits.numBits
    for i = beginBit, endBit do
        if 1 == bits[i] then
            return false
        end
    end
    return true
end
---将整数转换为位数组
---@type fun(value:number,numBits:number):Bits
---@param value number 数值
---@param numBits number 位数
---@return Bits 返回位数组
function Bit.intBits(value, numBits)
    numBits = numBits or 32
    local bits
    if value < 0 then
        bits = Bit.intBits(-value - 1, numBits)
        Bit.bitsNOT(bits)
        bits[numBits] = 1
    else
        bits = Bit.new(numBits)
        for i = numBits, 1, -1 do
            if Bit._bitMinMap[i] > 0 and value >= Bit._bitMinMap[i] then
                bits[i] = 1
                value = value - Bit._bitMinMap[i]
            elseif Bit._bitMinMap[i] < 0 and -value <= Bit._bitMinMap[i] then
                bits[i] = 1
                value = value + Bit._bitMinMap[i]
            end
        end
    end
    return bits
end
---将单精度小数转换为位数组
---@type fun(value:number,numBits:number):Bits
---@param value number 数值
---@param numBits number 位数，默认 32，只能是 32 或者 64
---@return Bits 返回位数组
function Bit.decimalBits(value, numBits)
    local bits = Bit.new(64 == numBits and 64 or 32)
    if 0 == value then
        return bits
    end
    if value < 0 then
        bits[bits.numBits] = 1
        value = -value
    end
    local bitsAll = Bit.new(bits.numBits * 2)
    local beginBit, endBit
    for i = bits.numBits, 1, -1 do
        if Bit._bitMinMap[i] > 0 and value >= Bit._bitMinMap[i] then
            endBit = bits.numBits + 1 - i
            beginBit = beginBit or endBit
            bitsAll[endBit] = 1
            value = value - Bit._bitMinMap[i]
        elseif Bit._bitMinMap[i] < 0 and -value <= Bit._bitMinMap[i] then
            endBit = bits.numBits + 1 - i
            beginBit = beginBit or endBit
            bitsAll[endBit] = 1
            value = value + Bit._bitMinMap[i]
        end
    end
    for i = 1, bits.numBits do
        value = value * 2
        if value >= 1 then
            endBit = bits.numBits + i
            beginBit = beginBit or endBit
            bitsAll[endBit] = 1
            value = value - 1
        end
        if 0 == value then
            break
        end
    end
    if beginBit and endBit then
        --- 指数偏移，指数位数，小数位数
        local offset, numExponents, numDecimals
        if 32 == bits.numBits then
            offset, numExponents, numDecimals = 127, 8, 23
        else
            offset, numExponents, numDecimals = 1023, 11, 52
        end
        local bitsExponent = Bit.intBits(offset + bits.numBits - beginBit, 12)
        for i = 1, numExponents do
            bits[numDecimals + i] = bitsExponent[i]
        end
        Bit.cache(bitsExponent)
        for i = numDecimals, 1, -1 do
            beginBit = beginBit + 1
            if beginBit > endBit then
                break
            end
            bits[i] = bitsAll[beginBit]
        end
        if beginBit < endBit and 1 == bitsAll[beginBit + 1] then
            local carry
            bits, carry = Bit.bitsPlusOnce(bits, 1, numDecimals)
            if carry then
                if 1 == bits[1] then
                    bits, carry = Bit.bitsPlusOnce(bits, 1, numDecimals)
                end
                for i = 1, numDecimals - 1 do
                    bits[i] = bits[i + 1]
                end
                bits[numDecimals] = carry and 1 or 0
                Bit.bitsPlusOnce(bits, numDecimals + 1, bits.numBits - 1)
            end
        end
    end
    Bit.cache(bitsAll)
    return bits
end
---位数组加1
---@type fun(bits:Bits,beginBit:number,endBit:number):Bits,boolean
---@param bits Bits 位数组
---@param beginBit number 起始位，默认 nil 表示 1
---@param endBit number 结束位，默认 nil 表示 bits.numBits
---@return Bits,boolean 返回 bits，是否需要进位
function Bit.bitsPlusOnce(bits, beginBit, endBit)
    for i = beginBit or 1, endBit or bits.numBits do
        if 1 == bits[i] then
            bits[i] = 0
        else
            bits[i] = 1
            return bits, false
        end
    end
    return bits, true
end
---将位数组转换为数值
---@type fun(bits:Bits,beginBit:number,endBit:number):number
---@param bits Bits 位数组
---@param beginBit number 起始位，默认 nil 表示 1
---@param endBit number 结束位，默认 nil 表示 bits.numBits
---@return number
function Bit.number(bits, beginBit, endBit)
    beginBit = beginBit or 1
    endBit = endBit or bits.numBits
    if 1 == beginBit and 64 == endBit and 1 == bits[endBit] then
        return -Bit.number(Bit.bitsNOT(bits), beginBit, endBit) - 1
    end
    local value = 0
    for i = beginBit, endBit do
        if 1 == bits[i] then
            value = value + Bit._bitMinMap[i - beginBit + 1]
        end
    end
    return value
end
---将位数组转换为浮点数
---@type fun(bits:Bits):number
---@param bits Bits 位数组
---@return number
function Bit.decimal(bits)
    if Bit.isEmpty(bits) then
        return 0
    end
    --- 指数偏移，指数位数，小数位数
    local offset, numExponents, numDecimals
    if 32 == bits.numBits then
        offset, numExponents, numDecimals = 127, 8, 23
    else
        offset, numExponents, numDecimals = 1023, 11, 52
    end
    local exponent = Bit.number(bits, numDecimals + 1, bits.numBits - 1)
    local dotOffset = exponent - offset
    if dotOffset > bits.numBits or dotOffset < -bits.numBits then
        return 0
    end
    local int = 0
    if 0 == dotOffset then
        int = 1
    elseif dotOffset > 0 then
        local intBits = Bit.clone(bits, numDecimals - dotOffset + 1, numDecimals + 1)
        intBits[intBits.numBits] = 1
        int = Bit.number(intBits)
        Bit.cache(intBits)
    end
    local decimal, decimalBits = 0
    if 0 == dotOffset then -- 1.xxxxx
        decimalBits = Bit.clone(bits, numDecimals, 1)
    elseif dotOffset > 0 then --xx.xxxxx
        if numDecimals > dotOffset then
            decimalBits = Bit.clone(bits, numDecimals - dotOffset, 1)
        end
    else -- 0.xxxxx
        decimalBits = Bit.clone(bits, numDecimals - dotOffset, 1)
        decimalBits[-dotOffset] = 1
        for i = 1, -dotOffset - 1 do
            decimalBits[i] = 0
        end
    end
    if decimalBits then
        local bitValue = 0.5
        for i = 1, bits.numBits do
            if 1 == decimalBits[i] then
                decimal = decimal + bitValue
            end
            bitValue = bitValue / 2
        end
        Bit.cache(decimalBits)
    end
    local value = int + decimal
    return 1 == bits[bits.numBits] and -value or value
end
---将数值转换为指定位数的有符号数值
---@type fun(value:number,numBits:number):number
---@param value number 数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.int(value, numBits)
    numBits = numBits or 32
    if numBits < 64 then
        local bits = Bit.intBits(value, numBits)
        if 1 == bits[bits.numBits] then
            value = -Bit.number(Bit.bitsNOT(bits)) - 1
        else
            value = 0
            for i = 1, bits.numBits do
                if 1 == bits[i] then
                    value = value + Bit._bitMinMap[i]
                end
            end
        end
        Bit.cache(bits)
    end
    return value
end
---将数值转换为指定位数的有符号数值
---@type fun(value:number,numBits:number):number
---@param value number 数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.uint(value, numBits)
    numBits = numBits or 32
    local bits = Bit.intBits(value, numBits)
    value = 0
    for i = 1, bits.numBits do
        if 1 == bits[i] and Bit._bitMinMap[i] > 0 then
            value = value + Bit._bitMinMap[i]
        end
    end
    Bit.cache(bits)
    return value
end
---按位取反
---@type fun(bits:Bits):Bits
---@param bits Bits 位数组
---@return Bits bits
function Bit.bitsNOT(bits)
    for i = 1, bits.numBits do
        bits[i] = 1 == bits[i] and 0 or 1
    end
    return bits
end
---按位与
---@type fun(aBits:Bits,bBits:Bits,bits:Bits):Bits
---@param aBits Bits 源位数组
---@param bBits Bits 源位数组
---@param bits Bits 输出的位数组
---@return Bits bits
function Bit.bitsAND(aBits, bBits, bits)
    for i = 1, bits.numBits do
        bits[i] = (1 == aBits[i] and 1 == bBits[i]) and 1 or 0
    end
    return bits
end
---按位或
---@type fun(aBits:Bits,bBits:Bits,bits:Bits):Bits
---@param aBits Bits 源位数组
---@param bBits Bits 源位数组
---@param bits Bits 输出的位数组
---@return Bits bits
function Bit.bitsOR(aBits, bBits, bits)
    for i = 1, bits.numBits do
        bits[i] = (0 == aBits[i] and 0 == bBits[i]) and 0 or 1
    end
    return bits
end
---按位异或
---@type fun(aBits:Bits,bBits:Bits,bits:Bits):Bits
---@param aBits Bits 源位数组
---@param bBits Bits 源位数组
---@param bits Bits 输出的位数组
---@return Bits bits
function Bit.bitsXOR(aBits, bBits, bits)
    for i = 1, bits.numBits do
        bits[i] = aBits[i] == bBits[i] and 0 or 1
    end
    return bits
end
---循环位移操作
---@type fun(bits:Bits,offset:number):Bits
---@param bits Bits 位数组
---@param offset number 负数左移，正数右移，默认 nil 或者 0 取整
---@return Bits bits
function Bit.bitsRotate(bits, offset)
    local copy = Bit.clone(bits)
    Bit.reset(bits)
    offset = offset and -offset or 0
    for i = 1, bits.numBits do
        if 1 == copy[i] then
            i = i + offset
            while i < 1 do
                i = i + bits.numBits
            end
            while i > bits.numBits do
                i = i - bits.numBits
            end
            bits[i] = 1
        end
    end
    Bit.cache(copy)
    return bits
end
---逻辑位移操作（用 0 补位）
---@type fun(bits:Bits,offset:number):Bits
---@param bits Bits 位数组
---@param offset number 负数左移，正数右移，默认 nil 或者 0 取整
---@return Bits bits
function Bit.bitsShift(bits, offset)
    local copy = Bit.clone(bits)
    Bit.reset(bits)
    offset = offset and -offset or 0
    for i = 1, bits.numBits do
        if 1 == copy[i] then
            i = i + offset
            if i >= 1 and i <= bits.numBits then
                bits[i] = 1
            end
        end
    end
    Bit.cache(copy)
    return bits
end
---算术位移操作（保留符号位）
---@type fun(bits:Bits,offset:number):Bits
---@param bits Bits 位数组
---@param offset number 负数左移，正数右移，默认 nil 或者 0 取整
---@return Bits bits
function Bit.bitsAShift(bits, offset)
    if 0 == bits[bits.numBits] or offset <= 0 then
        return Bit.bitsShift(bits, offset)
    end
    offset = offset and -offset or 0
    local numBits = bits.numBits - 1
    local copy = Bit.clone(bits)
    Bit.reset(bits, 1)
    for i = 1, numBits do
        if 0 == copy[i] then
            i = i + offset
            if i >= 1 and i <= numBits then
                bits[i] = 0
            end
        end
    end
    Bit.cache(copy)
    return bits
end
---取反
---@type fun(value:number,numBits:numBits):number
---@param value number 数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.bnot(value, numBits)
    numBits = numBits or 32
    local bits = Bit.bitsNOT(Bit.intBits(value, numBits))
    value = Bit.number(bits)
    Bit.cache(bits)
    return value
end
---与操作
---@type fun(a:number,b:number,numBits:number):number
---@param a number 源数值
---@param b number 源数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.band(a, b, numBits)
    numBits = numBits or 32
    local aBits = Bit.intBits(a, numBits)
    local bBits = Bit.intBits(b, numBits)
    local bits = Bit.bitsAND(aBits, bBits, Bit.new(numBits))
    a = Bit.number(bits)
    Bit.cache(aBits, bBits, bits)
    return a
end
---或操作
---@type fun(a:number,b:number,numBits:number):number
---@param a number 源数值
---@param b number 源数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.bor(a, b, numBits)
    numBits = numBits or 32
    local aBits = Bit.intBits(a, numBits)
    local bBits = Bit.intBits(b, numBits)
    local bits = Bit.bitsOR(aBits, bBits, Bit.new(numBits))
    a = Bit.number(bits)
    Bit.cache(aBits, bBits, bits)
    return a
end
---异或操作
---@type fun(a:number,b:number,numBits:number):number
---@param a number 源数值
---@param b number 源数值
---@param numBits number 位数，默认 32 位
---@return number
function Bit.bxor(a, b, numBits)
    numBits = numBits or 32
    local aBits = Bit.intBits(a, numBits)
    local bBits = Bit.intBits(b, numBits)
    local bits = Bit.bitsXOR(aBits, bBits, Bit.new(numBits))
    a = Bit.number(bits)
    Bit.cache(aBits, bBits, bits)
    return a
end
---循环位移操作
---@type fun(value:number,offset:number,numBits:number):number
---@param value number 数值
---@param offset number 移动位数，负数左移，正数右移，默认 nil 或者 0 取整
---@param numBits number 位数，默认 32 位
---@return number
function Bit.rotate(value, offset, numBits)
    numBits = numBits or 32
    local bits = Bit.intBits(value, numBits)
    if not offset or 0 == offset % bits.numBits then
        value = Bit.number(bits)
    else
        value = Bit.number(Bit.bitsRotate(bits, offset))
    end
    Bit.cache(bits)
    return value
end
---逻辑位移操作（用 0 补位）
---@type fun(value:number,offset:number,numBits:number):number
---@param value number 数值
---@param offset number 移动位数，负数左移，正数右移，默认 nil 或者 0 取整
---@param numBits number 位数，默认 32 位
---@return number
function Bit.shift(value, offset, numBits)
    numBits = numBits or 32
    local bits = Bit.intBits(value, numBits)
    if not offset or 0 == offset then
        value = Bit.number(bits)
    else
        value = Bit.number(Bit.bitsShift(bits, offset))
    end
    Bit.cache(bits)
    return value
end
---算术位移操作（保留符号位）
---@type fun(value:number,offset:number,numBits:number):number
---@param value number 数值
---@param offset number 移动位数，负数左移，正数右移，默认 nil 或者 0 取整
---@param numBits number 位数，默认 32 位
---@return number
function Bit.ashift(value, offset, numBits)
    numBits = numBits or 32
    if value >= 0 or not offset or offset <= 0 then
        return Bit.shift(value, offset, numBits)
    end
    local bits = Bit.intBits(value, numBits)
    value = Bit.number(Bit.bitsAShift(bits, offset))
    Bit.cache(bits)
    return value
end
---Protobuf 字段信息
---@class PBField:ObjectEx by wx771720@outlook.com 2019-12-31 10:51:14
---@field parent PBMessage 所属的消息信息
---@field name string 字段名
---@field id number 字段 id
---@field package string 值的类型所在包名
---@field type string 值的类型
---@field message PBMessage 值消息信息
---@field enum PBEnum 值枚举信息
---
---@field optional boolean 是否是可选的
---@field required boolean 是否是必须的
---@field repeated boolean 是否是数组
---@field packed boolean 是否使用 Length-delimited 格式编码数组
---@field map boolean 是否是表
---
---@field keyPackage string 键的类型所在包名
---@field keyType string 键的类型
---@field keyMessage PBMessage 键消息信息
---@field keyEnum PBEnum 键枚举信息
local PBField = xx.Class("PBField")
---构造函数
function PBField:ctor(name, package, type, id)
    self.optional, self.required, self.repeated, self.packed, self.map = true, false, false, true, false
    self.name, self.package, self.type, self.id, self.wireType = name, package, type, id
end
---Protobuf 消息信息
---@class PBMessage:ObjectEx by wx771720@outlook.com 2019-12-31 16:00:40
---@field root PBRoot 根
---@field name string 消息名
---@field fieldIDs number[] 字段 id 列表
---@field fieldIDMap table<number,PBField> 字段 id对应信息
local PBMessage = xx.Class("PBMessage")
---构造函数
function PBMessage:ctor(root, name)
    self.fieldIDs = {}
    self.fieldIDMap = {}
    self.root = root
    self.name = name
end
---Protobuf 枚举信息
---@class PBEnum:ObjectEx by wx771720@outlook.com 2019-12-31 16:01:10
---@field root PBRoot 根
---@field name string 枚举名
---@field idNameMap table<number,string> id 对应名字
---@field nameIDMap table<string,number> 名字对应 id
local PBEnum = xx.Class("PBEnum")
---构造函数
function PBEnum:ctor(root, name)
    self.idNameMap = {}
    self.nameIDMap = {}
    self.root = root
    self.name = name
end
---Protobuf 根信息
---@class PBRoot:ObjectEx by wx771720@outlook.com 2019-12-31 16:04:40
---@field package string 包名
---@field enumMap table<string,PBEnum> 枚举名对应信息
---@field messageMap table<string,PBMessage> 消息名对应信息
local PBRoot = xx.Class("PBRoot")
---构造函数
function PBRoot:ctor(package)
    self.enumMap = {}
    self.messageMap = {}
    self.package = package
end
---Protobuf 写
---@class PBWriter:ObjectEx by wx771720@outlook.com 2019-12-31 11:31:53
---@field buffer number[] 字节数组
---@field length number 长度
local PBWriter = xx.Class("PBWriter")
---构造函数
function PBWriter:ctor()
    self.buffer = {}
    self.length = 0
end
---缓存池
---@type PBWriter[]
PBWriter._pool = {}
---@return PBWriter
function PBWriter.instance()
    if #PBWriter._pool > 0 then
        local writer = PBWriter._pool[#PBWriter._pool]
        PBWriter._pool[#PBWriter._pool] = nil
        return writer
    end
    return PBWriter()
end
function PBWriter:destory()
    self.length = 0
    PBWriter._pool[#PBWriter._pool + 1] = self
end
---在末尾定入 Protobuf 写中的数据
---@type fun(writer:PBWriter):PBWriter
---@param writer PBWriter Protobuf 写
---@return PBWriter self
function PBWriter:write(writer)
    for i = 1, writer.length do
        self.length = self.length + 1
        self.buffer[self.length] = writer.buffer[i]
    end
    return self
end
---写入 varint 类型数值
---@type fun(value:number,numBits:number)
---@param value number 数值
---@param numBits number 位数，默认 32 位
function PBWriter:_varint(value, numBits)
    numBits = numBits or 32
    if value >= 0 then
        while value > 127 do
            self.length = self.length + 1
            self.buffer[self.length] = xx.Bit.uint(xx.Bit.bor(xx.Bit.band(value, 127, numBits), 128, numBits), numBits)
            value = xx.Bit.shift(value, 7, numBits)
        end
        self.length = self.length + 1
        self.buffer[self.length] = value
    else -- 写入负数
        for i = 1, 9 do
            self.length = self.length + 1
            self.buffer[self.length] = xx.Bit.uint(xx.Bit.bor(xx.Bit.band(value, 127, 64), 128, 64), 64)
            value = xx.Bit.ashift(value, 7, 64)
        end
        self.length = self.length + 1
        self.buffer[self.length] = 1
    end
end
---写入固定长度数值
---@type fun(bits:Bits)
---@param bits bits 位数组
function PBWriter:_fixed(bits)
    local byteBits = xx.Bit.new(8)
    for i = 1, bits.numBits do
        if 0 == i % 8 then
            byteBits[8] = bits[i]
            self.length = self.length + 1
            self.buffer[self.length] = xx.Bit.uint(xx.Bit.number(byteBits), 8)
        else
            byteBits[i % 8] = bits[i]
        end
    end
    xx.Bit.cache(byteBits)
end
---写入有符号 32 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:int32(value)
    self:_varint(value)
    return self
end
---写入无符号 32 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:uint32(value)
    self:_varint(value)
    return self
end
---写入 zigzag 编码的 32 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:sint32(value)
    self:uint32(xx.Bit.bxor(xx.Bit.shift(value, -1), xx.Bit.ashift(value, 31)))
    return self
end
---写入有符号 64 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:int64(value)
    self:_varint(value, 64)
    return self
end
---写入无符号 64 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:uint64(value)
    self:_varint(value, 64)
    return self
end
---写入 zigzag 编码的 64 位整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:sint64(value)
    self:uint64(xx.Bit.bxor(xx.Bit.shift(value, -1, 64), xx.Bit.ashift(value, 63, 64), 64))
    return self
end
---写入布尔值
---@type fun(value:boolean):PBWriter
---@param value boolean
---@return PBWriter self
function PBWriter:bool(value)
    self.length = self.length + 1
    self.buffer[self.length] = value and 1 or 0
    return self
end
---写入 32 位固定长度整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:fixed32(value)
    local bits = xx.Bit.intBits(value)
    self:_fixed(bits)
    xx.Bit.cache(bits)
    return self
end
---写入 32 位固定长度整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:sfixed32(value)
    self:fixed32(value)
    return self
end
---写入单精度浮点数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:float(value)
    local bits = xx.Bit.decimalBits(value)
    self:_fixed(bits)
    xx.Bit.cache(bits)
    return self
end
---写入 64 位固定长度整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:fixed64(value)
    local bits = xx.Bit.intBits(value, 64)
    self:_fixed(bits)
    xx.Bit.cache(bits)
    return self
end
---写入 64 位固定长度整数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:sfixed64(value)
    self:fixed64(value)
    return self
end
---写入双精度浮点数
---@type fun(value:number):PBWriter
---@param value number
---@return PBWriter self
function PBWriter:double(value)
    local bits = xx.Bit.decimalBits(value, 64)
    self:_fixed(bits)
    xx.Bit.cache(bits)
    return self
end
---写入 utf8 编码的字符串
---@type fun(value:string):PBWriter
---@param value string
---@return PBWriter self
function PBWriter:string(value)
    self:uint32(#value)
    for i = 1, #value do
        self.length = self.length + 1
        self.buffer[self.length] = string.byte(value, i)
    end
    return self
end
---写入 utf8 编码的字符串
---@type fun(value:string):PBWriter
---@param value string
---@return PBWriter self
function PBWriter:bytes(value)
    return self:string(value)
end
---Protobuf 读
---@class PBReader:ObjectEx by wx771720@outlook.com 2020-01-01 11:26:25
---@field buffer string 数据
---@field length number 长度
---@field position number 当前读取位置
local PBReader = xx.Class("PBReader")
---构造函数
function PBReader:ctor(buffer)
    self.buffer = buffer
    self.length = #buffer
    self.position = 1
end
---读取 varint 数值，并写入 bits
---@type fun(bits:Bits):Bits
---@param bits Bits 位数组
---@return Bits bits
function PBReader:_varint(bits)
    local offset, byte, byteBits = 1
    repeat
        byte = string.byte(self.buffer, self.position)
        self.position = self.position + 1
        byteBits = xx.Bit.intBits(byte, 8)
        for i = 1, 7 do
            bits[offset] = byteBits[i]
            offset = offset + 1
        end
        xx.Bit.cache(byteBits)
    until byte <= 127
    return bits
end
---读取固定长度字节，并写入 bits
---@type fun(bits:Bits):Bits
---@param bits Bits 位数组
---@return Bits bits
function PBReader:_fixed(bits)
    local offset, byte, byteBits = 1
    for i = 1, bits.numBits / 8 do
        byte = string.byte(self.buffer, self.position)
        self.position = self.position + 1
        byteBits = xx.Bit.intBits(byte, 8)
        for j = 1, 8 do
            bits[offset] = byteBits[j]
            offset = offset + 1
        end
        xx.Bit.cache(byteBits)
    end
    return bits
end
---读取有符号 32 位整数
---@type fun():number
---@return number
function PBReader:int32()
    local bits = self:_varint(xx.Bit.new(64))
    local value = xx.Bit.int(xx.Bit.number(bits))
    xx.Bit.cache(bits)
    return value
end
---读取无符号 32 位整数
---@type fun():number
---@return number
function PBReader:uint32()
    local bits = self:_varint(xx.Bit.new(32))
    local value = xx.Bit.uint(xx.Bit.number(bits))
    xx.Bit.cache(bits)
    return value
end
---读取 zigzag 编码的 32 位整数
---@type fun():number
---@return number
function PBReader:sint32()
    local value = self:uint32()
    return xx.Bit.int(xx.Bit.bxor(xx.Bit.shift(value, 1), -xx.Bit.band(value, 1)))
end
---读取有符号 64 位整数
---@type fun():number
---@return number
function PBReader:int64()
    local bits = self:_varint(xx.Bit.new(64))
    local value = xx.Bit.number(bits)
    xx.Bit.cache(bits)
    return value
end
---读取无符号 64 位整数
---@type fun():number
---@return number
function PBReader:uint64()
    local bits = self:_varint(xx.Bit.new(64))
    local value = xx.Bit.uint(xx.Bit.number(bits), 64)
    xx.Bit.cache(bits)
    return value
end
---读取 zigzag 编码的 64 位整数
---@type fun():number
---@return number
function PBReader:sint64()
    local value = self:uint64()
    return xx.Bit.bxor(xx.Bit.shift(value, 1, 64), -xx.Bit.band(value, 1, 64), 64)
end
---读取布尔值
---@type fun():boolean
---@return boolean
function PBReader:bool()
    local value = string.byte(self.buffer, self.position)
    self.position = self.position + 1
    return 0 ~= value
end
---读取 32 位固定长度整数
---@type fun():number
---@return number
function PBReader:fixed32()
    local bits = self:_fixed(xx.Bit.new(32))
    local value = xx.Bit.uint(xx.Bit.number(bits))
    xx.Bit.cache(bits)
    return value
end
---读取 zigzag 编码的 32 位固定长度整数
---@type fun():number
---@return number
function PBReader:sfixed32()
    return self:fixed32()
end
---读取单精度浮点数
---@type fun():number
---@return number
function PBReader:float()
    local bits = self:_fixed(xx.Bit.new(32))
    local value = xx.Bit.decimal(bits)
    xx.Bit.cache(bits)
    return value
end
---读取 64 位固定长度整数
---@type fun():number
---@return number
function PBReader:fixed64()
    local bits = self:_fixed(xx.Bit.new(64))
    local value = xx.Bit.uint(xx.Bit.number(bits), 64)
    xx.Bit.cache(bits)
    return value
end
---读取 zigzag 编码的 64 位固定长度整数
---@type fun():number
---@return number
function PBReader:sfixed64()
    return self:fixed64()
end
---读取双精度浮点数
---@type fun():number
---@return number
function PBReader:double()
    local bits = self:_fixed(xx.Bit.new(64))
    local value = xx.Bit.decimal(bits, 64)
    xx.Bit.cache(bits)
    return value
end
---读取 utf8 编码的字符串
---@type fun():string
---@return string
function PBReader:string()
    local length = self:uint32()
    local value = string.sub(self.buffer, self.position, self.position + length - 1)
    self.position = self.position + length
    return value
end
---读取 utf8 编码的字符串
---@type fun():string
---@return string
function PBReader:bytes()
    return self:string()
end
---Protobuf 解析器
---@class PBParser:ObjectEx by wx771720@outlook.com 2020-01-01 17:22:48
---@field lines string[] 行列表
---@field index number 当前读取行数
---@field numLines number 行数
local PBParser = xx.Class("PBParser")
---构造函数
function PBParser:ctor(content)
    self.index = 1
    self.lines = {}
    self.numLines = 0
    for line in string.gmatch(content, "[^\r\n]+") do
        if #string.gsub(line, "%s+", "") > 0 then
            self.numLines = self.numLines + 1
            self.lines[self.numLines] = line
        end
    end
end
---读取行
---@type fun():string
---@return string
function PBParser:readLine()
    self.index = self.index + 1
    return self.lines[self.index - 1]
end
---判断是否是结束行
---@type fun(line:string):boolean
---@param line string 行
---@return boolean
function PBParser:isClosureLine(line)
    return nil ~= string.match(line, "}")
end
---判断是否是包名行
---@type fun(line:string):boolean
---@param line string 行
---@return boolean
function PBParser:isPackageLine(line)
    return nil ~= string.match(line, "^package ")
end
---获取包名
---@type fun(line:string):string
---@param line string 行
---@return string 返回包名
function PBParser:getPackageName(line)
    return string.gsub(string.match(line, "[^;]+", #"package " + 1), "%s+", "")
end
---判断是否是消息行
---@type fun(line:string):boolean
---@param line string 行
---@return boolean
function PBParser:isMessageLine(line)
    return nil ~= string.match(line, "^message ")
end
---获取消息名
---@type fun(line:string):string
---@param line string 行
---@return string 返回消息名
function PBParser:getMessageName(line)
    return string.gsub(string.match(line, "[^%s{]+", #"message " + 1), "%s+", "")
end
---获取消息字段
---@type fun(line:string):PBField
---@param line string 行
---@return PBField 字段信息
function PBParser:getMessageField(line)
    local before = string.match(line, "[^=]+")
    if not before then
        return
    end
    local after = string.match(line, "=[^;]+")
    if not after then
        return
    end
    before = string.gsub(before, "%s+$", "")
    local name = string.match(before, "[^%s]+$")
    before = string.gsub(before, "%s*" .. name .. "%s*$", "")
    local repeated = nil ~= string.match(before, "repeated")
    if repeated then
        before = string.gsub(before, "%s*repeated%s*", "")
    end
    local required = nil ~= string.match(before, "required")
    if required then
        before = string.gsub(before, "%s*required%s*", "")
    end
    local optional = nil ~= string.match(before, "optional") or not required
    if optional then
        before = string.gsub(before, "%s*optional%s*", "")
    end
    local package, type, keyPackage, keyType
    local map = string.match(before, "map%s*<%s*[^%s]+%s*,%s*[^%s]+%s*>")
    if map then -- map
        map = string.gsub(string.gsub(map, "map%s*<", ""), "[%s>]", "")
        keyType = string.match(map, "[^,]+")
        type = string.match(map, "[^,]+$")
        map = true
        keyPackage = string.match(keyType, "[^\\.]+$")
        if keyPackage == keyType then
            keyPackage = nil
        else
            keyType, keyPackage = keyPackage, string.gsub(keyType, "." .. keyPackage .. "$", "")
        end
    else -- 基础类型，消息，枚举
        type = string.match(before, "[^%s]+$")
        if not type then
            return
        end
        map = false
    end
    package = string.match(type, "[^\\.]+$")
    if package == type then
        package = nil
    else
        type, package = package, string.gsub(type, "." .. package .. "$", "")
    end
    local id = string.match(after, "%d+")
    if not id then
        return
    end
    id = tonumber(id)
    local packed = nil == string.match(line, "packed%s*=%s*false")
    local field = PBField(name, package, type, id)
    field.optional = optional
    field.required = required
    field.repeated = repeated
    field.packed = packed
    field.map = map
    if map then
        field.keyPackage = keyPackage
        field.keyType = keyType
    end
    return field
end
---判断是否是枚举行
---@type fun(line:string):boolean
---@param line string 行
---@return boolean
function PBParser:isEnumLine(line)
    return nil ~= string.match(line, "^enum ")
end
---获取枚举名
---@type fun(line:string):string
---@param line string 行
---@return string 返回枚举名
function PBParser:getEnumName(line)
    return string.gsub(string.match(line, "[^%s{]+", #"enum " + 1), "%s+", "")
end
---获取枚举项
---@type fun(line:string):string,id
---@param line string 行
---@return string,id 名字, id
function PBParser:getEnumItem(line)
    local name = string.match(line, "[^=]+")
    if not name then
        return
    end
    local id = string.match(line, "=[^;]+")
    if not id then
        return
    end
    name = string.gsub(name, "%s+", "")
    id = string.gsub(id, "[=%s]+", "")
    return name, tonumber(id)
end
---Protobu 编码解码
---@class Protobuf:ObjectEx by wx771720@outlook.com 2019-12-31 10:46:50
local Protobuf = xx.Class("Protobuf")
---@see Protobuf
xx.Protobuf = Protobuf
---构造函数
function Protobuf:ctor()
end
Protobuf.pb_int32 = "int32"
Protobuf.pb_uint32 = "uint32"
Protobuf.pb_sint32 = "sint32"
Protobuf.pb_int64 = "int64"
Protobuf.pb_uint64 = "uint64"
Protobuf.pb_sint64 = "sint64"
Protobuf.pb_bool = "bool"
Protobuf.pb_fixed64 = "fixed64"
Protobuf.pb_sfixed64 = "sfixed64"
Protobuf.pb_double = "double"
Protobuf.pb_string = "string"
Protobuf.pb_bytes = "bytes"
Protobuf.pb_fixed32 = "fixed32"
Protobuf.pb_sfixed32 = "sfixed32"
Protobuf.pb_float = "float"
---类型默认值
Protobuf.default = 0
---类型对应默认值
---@type table<string,any>
Protobuf.typeDefaultMap = {bool = false, string = "", bytes = ""}
---类型对应 wire 值
---@type table<string, number>
Protobuf.typeWireMap = {}
---wire 对应类型列表
---@type table<number,string[]>
Protobuf.wireTypesMap = {
    [0] = {
        Protobuf.pb_int32,
        Protobuf.pb_uint32,
        Protobuf.pb_sint32,
        Protobuf.pb_int64,
        Protobuf.pb_uint64,
        Protobuf.pb_sint64,
        Protobuf.pb_bool
    },
    [1] = {Protobuf.pb_fixed64, Protobuf.pb_sfixed64, Protobuf.pb_double},
    [2] = {Protobuf.pb_string, Protobuf.pb_bytes},
    [5] = {Protobuf.pb_fixed32, Protobuf.pb_sfixed32, Protobuf.pb_float}
}
---初始化 typeWireMap 表
for wire, types in pairs(Protobuf.wireTypesMap) do
    for _, type in ipairs(types) do
        Protobuf.typeWireMap[type] = wire
    end
end
---数组可使用 packed 编码的类型
---@type table<string, boolean>
Protobuf.typePackedMap = {
    [Protobuf.pb_int32] = true,
    [Protobuf.pb_uint32] = true,
    [Protobuf.pb_sint32] = true,
    [Protobuf.pb_int64] = true,
    [Protobuf.pb_uint64] = true,
    [Protobuf.pb_sint64] = true,
    [Protobuf.pb_bool] = true,
    [Protobuf.pb_fixed64] = true,
    [Protobuf.pb_sfixed64] = true,
    [Protobuf.pb_double] = true,
    [Protobuf.pb_fixed32] = true,
    [Protobuf.pb_sfixed32] = true,
    [Protobuf.pb_float] = true
}
---默认包名
---@type string
Protobuf.defaultPackageName = "xx_default_package"
---包名对应根
---@type table<string,PBRoot>
Protobuf.packageRootMap = {[Protobuf.defaultPackageName] = PBRoot()}
---解析 proto 配置文件
---@type fun(source:string)
---@param source string proto 配置文件内容
function Protobuf.parse(source)
    ---@type PBRoot
    local root = Protobuf.packageRootMap[Protobuf.defaultPackageName]
    ---@type table<string,PBMessage[]>
    local packageMessagesMap = {[Protobuf.defaultPackageName] = {}}
    local parser = PBParser(source)
    while parser.index <= parser.numLines do
        local line = parser:readLine()
        if parser:isMessageLine(line) then -- 消息
            local message = PBMessage(root, parser:getMessageName(line))
            if not parser:isClosureLine(line) then
                Protobuf._parseMessage(parser, message)
            end
            root.messageMap[message.name] = message
            table.insert(packageMessagesMap[root.package or Protobuf.defaultPackageName], message)
        elseif parser:isEnumLine(line) then -- 枚举
            local enum = PBEnum(root, parser:getEnumName(line))
            if not parser:isClosureLine(line) then
                Protobuf._parseEnum(parser, enum)
            end
            root.enumMap[enum.name] = enum
        elseif parser:isPackageLine(line) then -- 包名
            local packageName = parser:getPackageName(line)
            if Protobuf.packageRootMap[packageName] then
                root = Protobuf.packageRootMap[packageName]
            else
                root = PBRoot(packageName)
                Protobuf.packageRootMap[packageName] = root
            end
            if not packageMessagesMap[packageName] then
                packageMessagesMap[packageName] = {}
            end
        end
    end
    for package, messages in pairs(packageMessagesMap) do
        if package == Protobuf.defaultPackageName then
            package = nil
        end
        for _, message in ipairs(messages) do
            for _, field in pairs(message.fieldIDMap) do
                if not Protobuf.typeWireMap[field.type] then
                    field.message = Protobuf.getMessage(field.package or package, field.type)
                    if not field.message then
                        field.enum = Protobuf.getEnum(field.package or package, field.type)
                    end
                end
                if field.map and not Protobuf.typeWireMap[field.keyType] then
                    field.keyMessage = Protobuf.getMessage(field.keyPackage or package, field.keyType)
                    if not field.keyMessage then
                        field.keyEnum = Protobuf.getEnum(field.keyPackage or package, field.keyType)
                    end
                end
            end
        end
    end
end
---解析消息信息
---@type fun(parser:PBParser,message:PBMessage)
---@param parser PBParser Protobuf 解析器
---@param message PBMessage 消息信息
function Protobuf._parseMessage(parser, message)
    ---@type string
    local line
    ---@type PBField
    local field
    repeat
        line = parser:readLine()
        field = parser:getMessageField(line)
        if field then
            field.parent = message
            table.insert(message.fieldIDs, field.id)
            message.fieldIDMap[field.id] = field
        end
        if parser:isClosureLine(line) then
            return
        end
    until false
end
---解析枚举信息
---@type fun(parser:PBParser,enum:PBEnum)
---@param parser PBParser Protobuf 解析器
---@param enum PBEnum 枚举信息
function Protobuf._parseEnum(parser, enum)
    local line, name, id
    repeat
        line = parser:readLine()
        name, id = parser:getEnumItem(line)
        if name and id then
            enum.idNameMap[id] = name
            enum.nameIDMap[name] = id
        end
        if parser:isClosureLine(line) then
            return
        end
    until false
end
---获取指定消息信息
---@type fun(packageName:string,messageName:string,value:any):PBMessage
---@param packageName string 包名
---@param messageName string 消息名
---@return PBMessage
function Protobuf.getMessage(packageName, messageName)
    if packageName then
        if Protobuf.packageRootMap[packageName] then
            return Protobuf.packageRootMap[packageName].messageMap[messageName]
        end
    else
        for packageName, root in pairs(Protobuf.packageRootMap) do
            if root.messageMap[messageName] then
                return root.messageMap[messageName]
            end
        end
    end
end
---获取指定枚举信息
---@type fun(packageName:string,enumName:string,value:any):PBEnum
---@param packageName string 包名
---@param enumName string 枚举名
---@return PBEnum
function Protobuf.getEnum(packageName, enumName)
    if packageName then
        if Protobuf.packageRootMap[packageName] then
            return Protobuf.packageRootMap[packageName].enumMap[enumName]
        end
    else
        for packageName, root in pairs(Protobuf.packageRootMap) do
            if root.enumMap[enumName] then
                return root.enumMap[enumName]
            end
        end
    end
end
---解码
---@type fun(packageName:string,messageName:string,buffer:string):any
---@param packageName string 包名
---@param messageName string 消息名
---@param buffer string 编码后的数据
---@return any 解码后的数据
function Protobuf.decode(packageName, messageName, buffer)
    ---@type PBReader
    local reader = PBReader(buffer)
    local message = Protobuf.getMessage(packageName, messageName)
    if message then
        return Protobuf._decode(message, reader, reader.length)
    end
end
---解码数据
---@type fun(message:PBMessage,reader:PBReader,length:number):any
---@param message PBMessage 消息信息
---@param reader PBReader 读
---@param length number 读取的长度
---@return any 解码后的数据
function Protobuf._decode(message, reader, length)
    local value = {}
    ---@type number
    local id
    ---@type number
    local to = reader.position + length
    repeat
        id = Protobuf._decodeTag(reader:uint32()) -- 读 tag
        local field = message.fieldIDMap[id]
        if field.map then -- 表
            if not value[field.name] then
                value[field.name] = {}
            end
            local fieldTo = reader:uint32() + reader.position -- 表结束位置
            local mapID, k, v
            repeat
                mapID = Protobuf._decodeTag(reader:uint32())
                if 1 == mapID then
                    k = Protobuf._readFrom(reader, field.keyType, field.keyMessage, field.enum)
                elseif 2 == mapID then
                    v = Protobuf._readFrom(reader, field.type, field.message, field.enum)
                end
                if k and v then
                    value[field.name][k] = v
                    k, v = nil, nil
                end
            until reader.position >= fieldTo
        elseif field.repeated then --数组
            if not value[field.name] then
                value[field.name] = {}
            end
            local length = #value[field.name]
            if field.packed and (Protobuf.typePackedMap[field.type] or field.enum) then -- packed 格式
                local fieldTo = reader:uint32() + reader.position -- 数组结束位置
                repeat
                    length = length + 1
                    value[field.name][length] = Protobuf._readFrom(reader, field.type, field.message, field.enum)
                until reader.position >= fieldTo
            else
                length = length + 1
                value[field.name][length] = Protobuf._readFrom(reader, field.type, field.message, field.enum)
            end
        else
            value[field.name] = Protobuf._readFrom(reader, field.type, field.message, field.enum)
        end
    until reader.position >= to
    return value
end
---从 PBReader 中读取数据
---@type fun(reader:PBReader,type:string,message:PBMessage,enum:PBEnum):any
---@param reader PBReader Protobuf 读
---@param type string 字段类型
---@param message PBMessage 消息信息
---@param enum PBEnum 枚举信息
---@return any 解码后的数据
function Protobuf._readFrom(reader, type, message, enum)
    if Protobuf.typeWireMap[type] then -- 基础类型
        return reader[type](reader)
    elseif message then -- 自定义类型
        return Protobuf._decode(message, reader, reader:uint32())
    elseif enum then -- 枚举
        return reader:int32()
    else -- 错误的类型
        error("protobuf decode can not find the type : " .. type)
    end
end
---解码 tag
---@type fun(tag:number):number,number
---@param tag number tag
---@return number,id id,wireType
function Protobuf._decodeTag(tag)
    return xx.Bit.uint(xx.Bit.shift(tag, 3)), xx.Bit.uint(xx.Bit.band(tag, 3))
end
---编码
---@type fun(packageName:string,messageName:string,value:any):string
---@param packageName string 包名
---@param messageName string 消息名
---@param value any 数据
---@return string 编码后的数据
function Protobuf.encode(packageName, messageName, value)
    ---@type PBWriter
    local writer = PBWriter.instance()
    local message = Protobuf.getMessage(packageName, messageName)
    if message then
        Protobuf._encode(message, value, writer)
    end
    for i = writer.length + 1, #writer.buffer do
        writer.buffer[i] = nil
    end
    local result = string.char(unpack(writer.buffer))
    writer:destory()
    return result
end
---编码消息
---@type fun(message:PBMessage,value:any,writer:PBWriter)
---@param message PBMessage 消息信息
---@param value any 数据
---@param writer PBWriter Protobuf 写
function Protobuf._encode(message, value, writer)
    for fieldID, field in pairs(message.fieldIDMap) do
        if nil ~= value[field.name] then
            if field.map then -- 表
                for k, v in pairs(value[field.name]) do
                    if nil ~= v then
                        ---@type PBWriter
                        local fieldWriter = PBWriter.instance()
                        Protobuf._writeTo(fieldWriter, 1, field.keyType, field.keyMessage, field.keyEnum, k) -- 写入键
                        Protobuf._writeTo(fieldWriter, 2, field.type, field.message, field.enum, v) -- 写入值
                        writer:uint32(Protobuf._encodeTag(field.id, 2)) -- 写入 tag
                        writer:uint32(fieldWriter.length) -- 写入长度
                        writer:write(fieldWriter) -- 写入值
                        fieldWriter:destory()
                    end
                end
            elseif field.repeated then -- 数组
                if #value[field.name] > 0 then
                    if field.packed and (Protobuf.typePackedMap[field.type] or field.enum) then -- packed 格式
                        ---@type PBWriter
                        local fieldWriter = PBWriter.instance()
                        for _, v in ipairs(value[field.name]) do
                            if field.enum then
                                fieldWriter:int32(v) -- 写入值
                            else
                                fieldWriter[field.type](fieldWriter, v) -- 写入值
                            end
                        end
                        writer:uint32(Protobuf._encodeTag(field.id, 2)) -- 写入 tag
                        writer:uint32(fieldWriter.length) -- 写入长度
                        writer:write(fieldWriter) -- 写入值
                        fieldWriter:destory()
                    else
                        for _, v in ipairs(value[field.name]) do
                            Protobuf._writeTo(writer, field.id, field.type, field.message, field.enum, v)
                        end
                    end
                end
            else
                Protobuf._writeTo(writer, field.id, field.type, field.message, field.enum, value[field.name])
            end
        end
    end
end
---将 value 写入 PBWriter
---@type fun(writer:PBWriter,id:number,type:string,message:PBMessage,enum:PBEnum,value:any)
---@param writer PBWriter
---@param id number 字段 id
---@param type string 字段类型
---@param message PBMessage 消息信息
---@param enum PBEnum 枚举信息
---@param value any 值
function Protobuf._writeTo(writer, id, type, message, enum, value)
    if Protobuf.typeWireMap[type] then -- 基础类型
        writer:uint32(Protobuf._encodeTag(id, Protobuf.typeWireMap[type])) -- 写入 tag
        writer[type](writer, value) -- 写入值
    elseif message then -- 自定义类型
        ---@type PBWriter
        local fieldWriter = PBWriter.instance()
        Protobuf._encode(message, value, fieldWriter)
        writer:uint32(Protobuf._encodeTag(id, 2)) -- 写入 tag
        writer:uint32(fieldWriter.length) -- 写入长度
        writer:write(fieldWriter) -- 定入值
        fieldWriter:destory()
    elseif enum then -- 枚举
        writer:uint32(Protobuf._encodeTag(id, 0)) -- 写入 tag
        writer:int32(value) -- 写入值
    else -- 错误的类型
        error("protobuf encode can not find the type : " .. type)
    end
end
---编码 tag
---@type fun(id:number,wireType:number):number
---@param id number 字段 id
---@param wireType number 编码类型
---@return number tag
function Protobuf._encodeTag(id, wireType)
    return xx.Bit.uint(xx.Bit.bor(xx.Bit.shift(id, -3), wireType))
end
---回调类
---@class Callback:ObjectEx by wx771720@outlook.com 2019-08-07 14:43:55
---@field handler Handler 回调方法
---@field caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@field cache any[]
local Callback = xx.Class("xx.Callback")
---@see Callback
xx.Callback = Callback
---构造函数
---@param handler Handler 回调方法
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@vararg any
function Callback:ctor(handler, caller, ...)
    self.handler = handler
    self.caller = caller
    self.cache = xx.arrayPush({}, ...)
end
---比较函数
---@param target Callback 需要比较的回调对象
---@return boolean 如果相同返回 true，否则返回 false
function Callback:equalTo(target)
    return self.handler == target.handler and self.caller == target.caller
end
---比较函数
---@param handler Handler 回调方法
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@return boolean 如果相同返回 true，否则返回 false
function Callback:equalBy(handler, caller)
    return self.handler == handler and self.caller == caller
end
---触发回调
---@type fun(...:any):any
---@vararg any
---@return any 透传回调方法的返回
function Callback:call(...)
    local args = {...}
    if xx.arrayCount(self.cache) > 0 or xx.arrayCount(args) > 0 then
        if self.caller then
            return self.handler(self.caller, unpack(xx.arrayPush(xx.arraySlice(self.cache), ...)))
        else
            return self.handler(unpack(xx.arrayPush(xx.arraySlice(self.cache), ...)))
        end
    else
        if self.caller then
            return self.handler(self.caller)
        else
            return self.handler()
        end
    end
end
---在指定回调对象列表中查找指定的回调方法及所属对象的索引
---@type fun(list:Callback[], handler:Handler, caller:any|nil):number
---@param list Callback[] 回调对象列表
---@param handler Handler 回调方法
---@param caller any|nil 回调方法所属的对象
---@return number 如果找到返回对应索引（从 1 开始），否则返回 -1
function Callback.getIndex(list, handler, caller)
    for index = 1, xx.arrayCount(list) do
        if list[index] and list[index]:equalBy(handler, caller) then
            return index
        end
    end
    return -1
end
---@class PromiseNext
---@field promise Promise 异步对象
---@field onFulfilled Handler 完成回调
---@field onRejected Handler 拒绝回调
local PromiseNext
---异步类
---@class Promise:ObjectEx by wx771720@outlook.com 2019-12-24 14:21:47
---
---@field value any[] 结果
---@field reason string 拒因
---
---@field _state string 当前状态
---@field _queue PromiseNext[] 结束后依赖的异步列表
local Promise = xx.Class("xx.Promise")
---@see Promise
xx.Promise = Promise
---异步状态：等待态
Promise.state_pending = "pending"
---异步状态：完成态
Promise.state_fulfilled = "fulfilled"
---异步状态：拒绝态
Promise.state_rejected = "rejected"
---异步对象列表
---@type Promise[]
Promise.queue = {}
---异步对象 - 回调函数
---@type table<Promise,Handler>
Promise.promiseAsyncMap = {}
---构造函数
function Promise:ctor(handler)
    self._state = Promise.state_pending
    self._queue = {}
    xx.arrayPush(Promise.queue, self)
    if handler then
        local result = {pcall(handler, xx.Handler(self.resolve, self), xx.Handler(self.reject, self))}
        if not result[1] then
            self:reject(result[2])
        end
    end
end
---异步是否是等待态
---@type fun():boolean
---@return boolean
function Promise:isPending()
    return Promise.state_pending == self._state
end
---异步是否是完成态
---@type fun():boolean
---@return boolean
function Promise:isFulfilled()
    return Promise.state_fulfilled == self._state
end
---异步是否是拒绝态
---@type fun():boolean
---@return boolean
function Promise:isRejected()
    return Promise.state_rejected == self._state
end
---完成
---@type fun(...:any)
---@vararg any
function Promise:resolve(...)
    if self:isPending() then
        self._state, self.value = Promise.state_fulfilled, xx.arrayPush({}, ...)
    end
end
---拒绝
---@type fun(reason:string)
---@param reason string 拒因
function Promise:reject(reason)
    if self:isPending() then
        self._state, self.reason = Promise.state_rejected, reason
    end
end
---拒绝并吃掉错误
function Promise:cancel()
    if self:isPending() then
        ---@type fun(promise:Promise)
        local catchNext
        catchNext = function(promise)
            if 0 == xx.arrayCount(promise._queue) then
                promise:catch()
            else
                for _, promiseNext in ipairs(promise._queue) do
                    catchNext(promiseNext.promise)
                end
            end
        end
        catchNext(self)
        self:reject("promise canceled")
    end
end
---异步结束后回调
---@type fun(onFulfilled:function,onRejected:function):Promise
---@param onFulfilled function 完成态回调
---@param onRejected function 拒绝态回调
---@return Promise 返回一个新的异步对象
function Promise:next(onFulfilled, onRejected)
    local promise = Promise()
    xx.arrayPush(self._queue, {promise = promise, onFulfilled = onFulfilled, onRejected = onRejected})
    return promise
end
---异步拒绝后回调
---@type fun(onRejected:function):Promise
---@param onRejected function|nil 拒绝态回调，nil 表示吃掉错误
---@return Promise 返回一个新的异步对象
function Promise:catch(onRejected)
    return self:next(
        nil,
        onRejected or function(reason)
            end
    )
end
---异步结束后回调
---@type fun(callback:function):Promise
---@param callback function 回调函数
---@return Promise 返回一个新的异步对象
function Promise:finally(callback)
    return self:next(
        function(...)
            callback()
            return ...
        end,
        function(reason)
            pcall(callback)
            error(reason)
        end
    )
end
---指定异步对象全部变成完成态，或者其中一个变成拒绝态时结束
---@type fun(...:Promise):Promise
---@vararg Promise
---@return Promise 返回一个新的异步对象
function Promise.all(...)
    local promises = xx.arrayPush({}, ...)
    return Promise(
        function(resolve, reject)
            local count = xx.arrayCount(promises)
            if count > 0 then
                local values = {}
                for i = 1, count do
                    promises[i]:next(
                        function(...)
                            values[i] = xx.arrayPush({}, ...)
                            count = count - 1
                            if 0 == count then
                                resolve(unpack(values))
                            end
                            return ...
                        end,
                        function(reason)
                            reject(reason)
                            error(reason)
                        end
                    )
                end
            else
                resolve()
            end
        end
    )
end
---指定异步对象其中一个变成完成态或者拒绝态时结束
---@type fun(...:Promise):Promise
---@vararg Promise
---@return Promise 返回一个新的异步对象
function Promise.race(...)
    local promises = xx.arrayPush({}, ...)
    return Promise(
        function(resolve, reject)
            for i = 1, xx.arrayCount(promises) do
                promises[i]:next(
                    function(...)
                        resolve(...)
                        return ...
                    end,
                    function(reason)
                        reject(reason)
                        error(reason)
                    end
                )
            end
        end
    )
end
---帧循环驱动异步
---@type fun()
function Promise.asyncLoop()
    for promise, handler in pairs(Promise.promiseAsyncMap) do
        Promise.promiseAsyncMap[promise] = nil
        local result = {
            coroutine.resume(
                coroutine.create(
                    function()
                        local result = {pcall(handler)}
                        if result[1] then -- 回调成功
                            if xx.instanceOf(result[2], Promise) then -- 返回异步
                                ---@type Promise
                                local promiseResult = result[2]
                                promiseResult:next(
                                    function(...) -- 异步完成
                                        promise:resolve(...)
                                        return ...
                                    end,
                                    function(reason) -- 异步拒绝
                                        promise:reject(reason)
                                        error(reason)
                                    end
                                )
                            else -- 返回值
                                xx.arrayRemoveAt(result, 1)
                                promise:resolve(unpack(result))
                            end
                        else -- 回调失败
                            promise:reject(result[2])
                        end
                    end
                )
            )
        }
        if not result[1] then
            promise:reject(result[2])
        end
    end
    for i = xx.arrayCount(Promise.queue), 1, -1 do
        local promise = Promise.queue[i]
        if promise:isFulfilled() or promise:isRejected() then
            xx.arrayRemoveAt(Promise.queue, i)
            for _, promiseNext in ipairs(promise._queue) do
                local result
                if promise:isFulfilled() then -- 完成回调
                    if promiseNext.onFulfilled then
                        result = {pcall(promiseNext.onFulfilled, unpack(promise.value))}
                    else
                        promiseNext.promise:resolve(unpack(promise.value))
                    end
                elseif promise:isRejected() then -- 拒绝回调
                    if promiseNext.onRejected then
                        result = {pcall(promiseNext.onRejected, promise.reason)}
                    else
                        promiseNext.promise:reject(promise.reason)
                    end
                end
                if result then -- 已回调
                    if result[1] then -- 回调成功
                        if xx.instanceOf(result[2], Promise) then -- 返回异步
                            ---@type Promise
                            local promiseResult = result[2]
                            promiseResult:next(
                                function(...) -- 异步完成
                                    promiseNext.promise:resolve(...)
                                    return ...
                                end,
                                function(reason) -- 异步拒绝
                                    promiseNext.promise:reject(reason)
                                    error(reason)
                                end
                            )
                        else -- 返回值
                            xx.arrayRemoveAt(result, 1)
                            promiseNext.promise:resolve(unpack(result))
                        end
                    else -- 回调失败
                        promiseNext.promise:reject(result[2])
                    end
                end
            end
            if promise:isRejected() and 0 == xx.arrayCount(promise._queue) then
                error(promise.reason)
            end
        end
    end
end
---在新协程中调用指定方法
---@type fun(handler:Handler,caller:any,...:any):Promise
---@param handler Handler 需要异步调用的函数
---@param caller any 需要异步调用的函数所属对象
---@vararg any
---@return Promise 异步对象
function Promise.async(handler, caller, ...)
    local promise = Promise()
    Promise.promiseAsyncMap[promise] = xx.Handler(handler, caller, ...)
    return promise
end
---等待异步完成，返回数据最后一个参数为 boolean 值，true 表示 resolved，false 表示 rejected（不能在主线程中调用）
---@type fun(promise:Promise):any
---@param promise Promise 异步对象
---@return any 异步完成返回的数据
function Promise.await(promise)
    assert(coroutine.isyieldable(), "can not yield")
    local co = coroutine.running()
    promise:next(
        function(...) -- 完成
            local result = {coroutine.resume(co, true, ...)}
            if not result[1] then
                error(result[2])
            end
            return ...
        end,
        function(reason) -- 拒绝
            local result = {coroutine.resume(co, false, reason)}
            if not result[1] then
                error(result[2])
            end
            error(reason)
        end
    )
    local result = {coroutine.yield()}
    if not result[1] then -- 拒绝后直接结束协程
        error(result[2])
    end
    xx.arrayRemoveAt(result, 1)
    return unpack(result)
end
---@see Promise#async
xx.async = Promise.async
---@see Promise#await
xx.await = Promise.await
---在新协程中调用指定方法
---@type fun(handler:function|function[],caller:any,...:any):Promise
---@param handler function|function[] 协程函数，或者用表封装的函数（只关心表中第一个元素）
---@param caller any 需要异步调用的函数所属对象
---@vararg any
---@return Promise 返回异步对象
async = function(handler, caller, ...)
    if xx.isFunction(handler) then
        return Promise.async(handler, caller, ...)
    elseif xx.isTable(handler) and xx.isFunction(handler[1]) then
        return Promise.async(handler[1], unpack(xx.arraySlice(handler, 2)))
    end
    error "async only support function"
end
---暂停当前协程，等待异步结束（不能在主线程中调用）
---@type fun(promise:Promise|Promise[]):...
---@param promise Promise|Promise[] 异步对象，或者用表封装的异步对象（只关心表中第一个元素）
---@return ... 返回异步对象结果（unpack(Promise.value)）
await = function(promise)
    if xx.instanceOf(promise, Promise) then
        return Promise.await(promise)
    elseif xx.isTable(promise) and xx.instanceOf(promise[1], Promise) then
        return Promise.await(promise[1])
    end
    error "await only support Promise"
end
---信号类
---@class Signal:ObjectEx by wx771720@outlook.com 2019-08-07 15:08:49
---@field target any|nil 关联的对象
---
---@field _callbacks Callback[] 回调列表
---@field _promises Promise[] 等待列表
local Signal = xx.Class("xx.Signal")
---@see Signal
xx.Signal = Signal
---构造方法
---@param target any|nil 关联的对象
function Signal:ctor(target)
    self.target = target
    self._callbacks = {}
    self._promises = {}
end
---添加回调
---@type fun(handler:Handler, caller:any, ...:any):Signal
---@param handler handler 回调函数
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@vararg any
---@return Signal self
function Signal:addListener(handler, caller, ...)
    local callback
    local index = xx.Callback.getIndex(self._callbacks, handler, caller)
    if index < 0 then
        callback = xx.Callback(handler, caller, ...)
    else
        callback = self._callbacks[index]
        callback.cache = xx.arrayPush({}, ...)
        xx.arrayRemoveAt(self._callbacks, index)
    end
    callback["callOnce"] = false
    xx.arrayPush(self._callbacks, callback)
    return self
end
---添加回调
---@type fun(handler:Handler, caller:any, ...:any):Signal
---@param handler Handler 回调函数
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@vararg any
---@return Signal self
function Signal:once(handler, caller, ...)
    local callback
    local index = xx.Callback.getIndex(self._callbacks, handler, caller)
    if index < 0 then
        callback = xx.Callback(handler, caller, ...)
    else
        callback = self._callbacks[index]
        callback.cache = xx.arrayPush({}, ...)
        xx.arrayRemoveAt(self._callbacks, index)
    end
    callback["callOnce"] = true
    xx.arrayPush(self._callbacks, callback)
    return self
end
---移除回调
---@type fun(handler:Handler|nil,caller:any|nil):Signal
---@param handler Handler|nil 回调函数
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@return Signal self
function Signal:removeListener(handler, caller)
    if not handler and not caller then
        xx.arrayClear(self._callbacks)
    elseif not handler then
        for i = xx.arrayCount(self._callbacks), 1, -1 do
            if self._callbacks[i].caller == caller then
                xx.arrayRemoveAt(self._callbacks, i)
            end
        end
    elseif not caller then
        for i = xx.arrayCount(self._callbacks), 1, -1 do
            if self._callbacks[i].handler == handler then
                xx.arrayRemoveAt(self._callbacks, i)
            end
        end
    else
        local index = xx.Callback.getIndex(self._callbacks, handler, caller)
        if index > 0 then
            xx.arrayRemoveAt(self._callbacks, index)
        end
    end
    return self
end
---判断是否有指定回调函数的回调
---@type fun(handler:Handler|nil,caller:any|nil):boolean
---@param handler Handler|nil 回调函数，null 表示判断是否有监听
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不指定
---@return boolean 如果找到返回 true，否则返回 false
function Signal:hasListener(handler, caller)
    if not handler and not caller then
        return xx.arrayCount(self._callbacks) > 0
    elseif not handler then
        for i = xx.arrayCount(self._callbacks), 1, -1 do
            if self._callbacks[i].caller == caller then
                return true
            end
        end
    elseif not caller then
        for i = xx.arrayCount(self._callbacks), 1, -1 do
            if self._callbacks[i].handler == handler then
                return true
            end
        end
    else
        return xx.Callback.getIndex(self._callbacks, handler, caller) > 0
    end
    return false
end
---等待信号触发
---@type fun():Promise
---@return Promise 异步对象
function Signal:wait()
    local promise = xx.Promise()
    xx.arrayPush(self._promises, promise)
    return promise
end
---取消等待信号
---@type fun()
function Signal:removeWait()
    for i = xx.arrayCount(self._promises), 1, -1 do
        local promise = self._promises[i]
        self._promises[i] = nil
        promise:cancel()
    end
end
---触发信号
---@type fun(...:any):Signal
---@vararg any
---@return Signal self
function Signal:call(...)
    for i = xx.arrayCount(self._promises), 1, -1 do
        local promise = self._promises[i]
        self._promises[i] = nil
        promise:resolve(...)
    end
    local evt = xx.Event(self, nil, xx.arrayPush({}, ...))
    local copy = xx.arraySlice(self._callbacks)
    for _, callback in ipairs(copy) do
        if self:hasListener(callback.handler, callback.caller) then
            if callback["callOnce"] then
                xx.arrayRemove(self._callbacks, callback)
            end
            callback(evt)
            if evt.isStopImmediate then
                break
            end
        end
    end
    return self
end
---事件
---@class Event:ObjectEx by wx771720@outlook.com 2019-09-11 16:55:47
---@field target any 事件派发对象
---@field type string 事件类型
---@field args any[] 携带数据
---@field currentTarget any 当前触发对象
---@field isStopBubble boolean 是否停止冒泡，默认 false
---@field isStopImmediate boolean 是否立即停止后续监听，默认 false
local Event = xx.Class("xx.Event")
---@see Event
xx.Event = Event
---构造函数
function Event:ctor(target, type, args)
    self.target = target
    self.type = type
    self.args = args
    self.isStopBubble = false
    self.isStopImmediate = false
end
---停止事件冒泡
function Event:stopBubble()
    self.isStopBubble = true
end
---立即停止后续执行（会停止事件冒泡）
function Event:stopImmediate()
    self.isStopImmediate = true
    self.isStopBubble = true
end
---事件派发类
---@class EventDispatcher:ObjectEx by wx771720@outlook.com 2019-08-07 15:17:02
---@field _typeCallbacksMap table<string, Callback[]> 事件类型 - 回调列表
---@field _typePromisesMap table<string, Promise[]> 事件类型 - 等待列表
local EventDispatcher = xx.Class("EventDispatcher")
---@see EventDispatcher
xx.EventDispatcher = EventDispatcher
function EventDispatcher:onDynamicChanged(key, newValue, oldValue)
    self(GIdentifiers.e_changed, key, newValue, oldValue)
end
---构造函数
function EventDispatcher:ctor()
    self._typeCallbacksMap = {}
    self._typePromisesMap = {}
end
---添加事件回调
---@type fun(type:string, handler:Handler, caller:any, ...:any[]):EventDispatcher
---@param type string 事件类型
---@param handler Handler 回调函数，return: boolean（是否立即停止执行后续回调）, boolean（是否停止冒泡）
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入
---@return EventDispatcher self
function EventDispatcher:addEventListener(type, handler, caller, ...)
    local callback
    local callbacks
    if self._typeCallbacksMap[type] then
        callbacks = self._typeCallbacksMap[type]
        local index = xx.Callback.getIndex(callbacks, handler, caller)
        if index < 0 then
            callback = xx.Callback(handler, caller, ...)
        else
            callback = callbacks[index]
            callback.cache = xx.arrayPush({}, ...)
            xx.arrayRemoveAt(callbacks, index)
        end
    else
        callbacks = {}
        self._typeCallbacksMap[type] = callbacks
        callback = xx.Callback(handler, caller, ...)
    end
    callback["callOnce"] = false
    xx.arrayPush(callbacks, callback)
    return self
end
---添加事件回调
---@type fun(type:string, handler:Handler, caller:any, ...:any[]):EventDispatcher
---@param type string 事件类型
---@param handler Handler 回调函数，return: boolean（是否立即停止执行后续回调）, boolean（是否停止冒泡）
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入
---@return EventDispatcher self
function EventDispatcher:once(type, handler, caller, ...)
    local callback
    local callbacks
    if self._typeCallbacksMap[type] then
        callbacks = self._typeCallbacksMap[type]
        local index = xx.Callback.getIndex(callbacks, handler, caller)
        if index < 0 then
            callback = xx.Callback(handler, caller, ...)
        else
            callback = callbacks[index]
            callback.cache = xx.arrayPush({}, ...)
            xx.arrayRemoveAt(callbacks, index)
        end
    else
        callbacks = {}
        self._typeCallbacksMap[type] = callbacks
        callback = xx.Callback(handler, caller, ...)
    end
    callback["callOnce"] = true
    xx.arrayPush(callbacks, callback)
    return self
end
---删除事件回调
---@type fun(type:string, handler:Handler, caller:any):EventDispatcher
---@param type string|nil 事件类型，默认 nil 表示移除所有 handler 和 caller 回调
---@param handler Handler|nil 回调函数，默认 nil 表示移除所有包含 handler 回调
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入，默认 nil 表示移除所有包含 caller 的回调
---@return EventDispatcher self
function EventDispatcher:removeEventListener(type, handler, caller)
    if not type and not handler and not caller then
        xx.tableClear(self._typeCallbacksMap)
    elseif not type then
        if not handler then
            for loopType, callbacks in pairs(self._typeCallbacksMap) do
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].caller == caller then
                        xx.arrayRemoveAt(callbacks, i)
                    end
                end
                if 0 == xx.arrayCount(callbacks) then
                    self._typeCallbacksMap[loopType] = nil
                end
            end
        elseif not caller then
            for loopType, callbacks in pairs(self._typeCallbacksMap) do
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].handler == handler then
                        xx.arrayRemoveAt(callbacks, i)
                    end
                end
                if 0 == xx.arrayCount(callbacks) then
                    self._typeCallbacksMap[loopType] = nil
                end
            end
        else
            for loopType, callbacks in pairs(self._typeCallbacksMap) do
                local index = xx.Callback.getIndex(callbacks, handler, caller)
                if index > 0 then
                    if 1 == xx.arrayCount(callbacks) then
                        self._typeCallbacksMap[loopType] = nil
                    else
                        xx.arrayRemoveAt(callbacks, index)
                    end
                end
            end
        end
    elseif self._typeCallbacksMap[type] then
        if not handler and not caller then
            self._typeCallbacksMap[type] = nil
        else
            local callbacks = self._typeCallbacksMap[type]
            if not handler then
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].caller == caller then
                        xx.arrayRemoveAt(callbacks, i)
                    end
                end
                if 0 == xx.arrayCount(callbacks) then
                    self._typeCallbacksMap[type] = nil
                end
            elseif not caller then
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].handler == handler then
                        xx.arrayRemoveAt(callbacks, i)
                    end
                end
                if 0 == xx.arrayCount(callbacks) then
                    self._typeCallbacksMap[type] = nil
                end
            else
                local index = xx.Callback.getIndex(callbacks, handler, caller)
                if index > 0 then
                    if 1 == xx.arrayCount(callbacks) then
                        self._typeCallbacksMap[type] = nil
                    else
                        xx.arrayRemoveAt(callbacks, index)
                    end
                end
            end
        end
    end
    return self
end
---是否有事件回调
---@type fun(type:string|nil,handler:Handler|nil,caller:any|nil):boolean
---@param type string|nil 事件类型，默认 nil 表示移除所有 handler 和 caller 回调
---@param handler Handler|nil 回调函数，默认 nil 表示移除所有包含 handler 回调
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入，默认 nil 表示移除所有包含 caller 的回调
---@return boolean 如果找到事件回调返回 true，否则返回 false
function EventDispatcher:hasEventListener(type, handler, caller)
    if not type and not handler and not caller then
        return xx.tableCount(self._typeCallbacksMap) > 0
    end
    if not type then
        if not handler then
            for _, callbacks in pairs(self._typeCallbacksMap) do
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].caller == caller then
                        return true
                    end
                end
            end
        elseif not caller then
            for _, callbacks in pairs(self._typeCallbacksMap) do
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].handler == handler then
                        return true
                    end
                end
            end
        else
            for _, callbacks in pairs(self._typeCallbacksMap) do
                local index = xx.Callback.getIndex(callbacks, handler, caller)
                if index > 0 then
                    return true
                end
            end
        end
    elseif self._typeCallbacksMap[type] then
        if not handler and not caller then
            return true
        else
            local callbacks = self._typeCallbacksMap[type]
            if not handler then
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].caller == caller then
                        return true
                    end
                end
            elseif not caller then
                for i = xx.arrayCount(callbacks), 1, -1 do
                    if callbacks[i].handler == handler then
                        return true
                    end
                end
            else
                return xx.Callback.getIndex(callbacks, handler, caller) > 0
            end
        end
    end
    return false
end
---等待事件触发
---@type fun(type:string):Promise
---@param type string 事件类型
---@return Promise 异步对象
function EventDispatcher:wait(type)
    local promise = xx.Promise()
    if self._typePromisesMap[type] then
        xx.arrayPush(self._typePromisesMap[type], promise)
    else
        self._typePromisesMap[type] = {promise}
    end
    return promise
end
---取消等待事件
---@type fun(type:string|nil):EventDispatcher
---@param type string|nil 事件类型，null 表示取消所有等待事件
---@return EventDispatcher self
function EventDispatcher:removeWait(type)
    if not type then
        for type, promises in pairs(self._typePromisesMap) do
            self._typePromisesMap[type] = nil
            for _, promise in ipairs(promises) do
                promise:cancel()
            end
        end
    elseif self._typePromisesMap[type] then
        local promises = self._typePromisesMap[type]
        self._typePromisesMap[type] = nil
        for _, promise in ipairs(promises) do
            promise:cancel()
        end
    end
    return self
end
---判断是否有等待指定事件
---@type fun(type:string|nil):boolean
---@param type string|nil 等待事件，nil 表示是否有等待任意事件
---@return boolean 如果有等待指定事件返回 true，否则返回 false
function EventDispatcher:hasWait(type)
    if not type then
        return xx.tableCount(self._typePromisesMap) > 0
    end
    return self._typePromisesMap[type] and true or false
end
---派发事件
---@type fun(type:string, ...:any)
---@param type string 事件类型
---@vararg any
function EventDispatcher:call(type, ...)
    self:callEvent(xx.Event(self, type, xx.arrayPush({}, ...)))
end
---派发事件（需要支持冒泡）
---@param evt Event 事件对象
function EventDispatcher:callEvent(evt)
    if self._typePromisesMap[evt.type] then
        local promises = self._typePromisesMap[evt.type]
        self._typePromisesMap[evt.type] = nil
        for i = xx.arrayCount(promises), 1, -1 do
            promises[i]:resolve(unpack(evt.args))
        end
    end
    if self._typeCallbacksMap[evt.type] then
        evt.currentTarget = self
        local callbacks = xx.arraySlice(self._typeCallbacksMap[evt.type])
        for _, callback in ipairs(callbacks) do
            if self:hasEventListener(evt.type, callback.handler, callback.caller) then
                if callback["callOnce"] then
                    self:removeEventListener(evt.type, callback.handler, callback.caller)
                end
                callback(evt)
                if evt.isStopImmediate then
                    break
                end
            end
        end
    end
end
---通知结果
---@class NoticeResult:ObjectEx by wx771720@outlook.com 2019-09-11 20:04:17
---@field stop boolean 是否停止后续模块的执行
---@field data any 通知直接返回的数据
local NoticeResult = xx.Class("xx.NoticeResult")
---@see NoticeResult
xx.NoticeResult = NoticeResult
---构造函数
function NoticeResult:ctor()
    self.stop = false
    self.data = nil
end
---模块与状态机类
---@class Framework:EventDispatcher by wx771720@outlook.com 2019-08-09 10:08:44
---@field public isRegistered boolean 模块是否已注册
---@field public priority number 模块优先级，数值越大的优先执行
---@field private _context table<string, any> 上下文
---@field public isConstructed boolean 状态机是否已构造
---@field public isFocused boolean 状态机是否已进入
---@field public isActivated boolean 状态机是否已激活
---@field public parent Framework 父级状态机
---@field public curState Framework 当前子状态机
---@field public numStates number 子状态机数量
---@field private _stateUIDs string[] 子状态机 uid 列表
---@field private _uidStateMap table<string, Framework> uid - 子状态机
---@field private _uidAliasMap table<string, string> uid - 别名
---@field private _aliasUIDMap table<string, string> 别名 - uid
local Framework = xx.Class("xx.Framework", xx.EventDispatcher)
---@see Framework
xx.Framework = Framework
---构造函数
function Framework:ctor()
    self.isRegistered = false
    self.priority = 0
    self._context = {}
    self.isConstructed = false
    self.isFocused = false
    self.isActivated = false
    self.parent = nil
    self.curState = nil
    self.numStates = 0
    self._stateUIDs = {}
    self._uidStateMap = {}
    self._uidAliasMap = {}
    self._aliasUIDMap = {}
end
function Framework:ctored()
    self:addEventListener(GIdentifiers.e_changed, self.onPriorityChanged, self)
end
---uid - module
---@type table<string, Framework>
Framework.uidModuleMap = {}
---notice  - uid list（按 priority 降序）
---@type table<string, string[]>
Framework.noticeUIDsMap = {}
---uid - notice list
---@type table<string, string[]>
Framework.uidNoticesMap = {}
---priority 改变监听
---@type fun(name:string)
function Framework:onPriorityChanged(name)
    if self.isRegistered and "priority" == name then
        Framework.sort(self)
    end
end
---注册模块
---@type fun(module:Framework, ...:string)
---@param module Framework 模块
---@vararg string
function Framework.register(module, ...)
    if module.isRegistered then
        Framework.addNotices(module, ...)
    else
        Framework.uidModuleMap[module.uid] = module
        module.isRegistered = true
        Framework.addNotices(module, ...)
        if xx.isFunction(module.onRegister) then
            module:onRegister()
        end
    end
end
---注销模块
---@type fun(module:Framework)
---@param module Framework 模块
function Framework.unregister(module)
    if module.isRegistered then
        Framework.removeNotices(module)
        Framework.uidModuleMap[module.uid] = nil
        module.isRegistered = false
        if xx.isFunction(module.onUnregister) then
            module:onUnregister()
        end
    end
end
---添加监听
---@type fun(...:string)
---@param module Framework 模块
---@vararg string
function Framework.addNotices(module, ...)
    local args = {...}
    local argCount = xx.arrayCount(args)
    if module.isRegistered and argCount > 0 then
        if not Framework.uidNoticesMap[module.uid] then
            Framework.uidNoticesMap[module.uid] = {}
        end
        for i = 1, argCount do
            local notice = args[i]
            if xx.isString(notice) then
                if not module:hasNotice(notice) then
                    xx.arrayPush(Framework.uidNoticesMap[module.uid], notice)
                    if Framework.noticeUIDsMap[notice] then
                        xx.arrayPush(Framework.noticeUIDsMap[notice], module.uid)
                    else
                        Framework.noticeUIDsMap[notice] = {module.uid}
                    end
                end
            end
        end
        Framework.sort(module)
    end
end
---移除监听
---@type fun(...:string)
---@param module Framework 模块
---@vararg string
function Framework.removeNotices(module, ...)
    if module.isRegistered and Framework.uidNoticesMap[module.uid] then
        local args = {...}
        local count = xx.arrayCount(args)
        local notices = Framework.uidNoticesMap[module.uid]
        if 0 == count then
            for _, notice in ipairs(notices) do
                local uids = Framework.noticeUIDsMap[notice]
                if 1 == xx.arrayCount(uids) then
                    Framework.noticeUIDsMap[notice] = nil
                else
                    xx.arrayRemove(uids, module.uid)
                end
            end
            Framework.uidNoticesMap[module.uid] = nil
        else
            for i = 1, count do
                local notice = args[i]
                if xx.isString(notice) then
                    if module:hasNotice(notice) then
                        local uids = Framework.noticeUIDsMap[notice]
                        if 1 == xx.arrayCount(uids) then
                            Framework.noticeUIDsMap[notice] = nil
                        else
                            xx.arrayRemove(uids, module.uid)
                        end
                        xx.arrayRemove(notices, notice)
                    end
                end
            end
            if 0 == xx.arrayCount(notices) then
                Framework.uidNoticesMap[module.uid] = nil
            end
        end
    end
end
---派发通知
---@type fun(notice:string, ...:any):any
---@param notice strig 通知
---@vararg any
---@return any 直接返回的数据
function Framework.notify(notice, ...)
    local result = xx.NoticeResult()
    if Framework.noticeUIDsMap[notice] then
        local uids = xx.arraySlice(Framework.noticeUIDsMap[notice])
        for _, uid in ipairs(uids) do
            if Framework.uidModuleMap[uid] then
                local module = Framework.uidModuleMap[uid]
                if module:hasNotice(notice) and xx.isFunction(module.onNotice) then
                    module:onNotice(notice, result, ...)
                    if result.stop then
                        break
                    end
                end
            end
        end
    end
    return result.data
end
---@see Framework#notify
xx.notify = Framework.notify
---派发异步通知
---@type fun(notice:string,...:any):Promise,any
---@param notice string 通知
---@vararg any
---@return Promise,any 异步对象，返回数据
function Framework.notifyAsync(notice, ...)
    local promise = xx.Promise()
    if Framework.noticeUIDsMap[notice] then
        local index = 1
        local result = xx.NoticeResult()
        local uids = xx.arraySlice(Framework.noticeUIDsMap[notice])
        local executor
        executor = function(...)
            if index > xx.arrayCount(uids) or result.stop then
                promise:resolve(...)
                return
            end
            local module = Framework.uidModuleMap[uids]
            if module and module:hasNotice(notice) and xx.isFunction(module.onNotice) then
                local callback =
                    xx.Callback(
                    function(...)
                        index = index + 1
                        executor(...)
                    end
                )
                module:onNotice(notice, result, unpack(xx.arrayPush({...}, callback)))
                return
            end
            index = index + 1
            executor(...)
        end
        executor(...)
    else
        promise:resolve()
    end
    return promise
end
---@see Framework#notify
xx.notifyAsync = Framework.notifyAsync
---排序模块
function Framework.sort(module)
    local notices = Framework.uidNoticesMap[module.uid]
    for _, notice in ipairs(notices) do
        local uids = Framework.noticeUIDsMap[notice]
        table.sort(
            uids,
            function(uid1, uid2)
                return Framework.uidModuleMap[uid2].priority < Framework.uidModuleMap[uid1].priority
            end
        )
    end
end
---判断是否监听了指定通知
---@type fun(notice:string|nil):boolean
---@param notice string|nil 通知，null 表示判断模块是否监听了任意通知
---@return boolean 如果有监听指定通知则返回 true，否则返回 false
function Framework:hasNotice(notice)
    if not notice then
        return nil ~= Framework.uidNoticesMap[self.uid]
    end
    return Framework.uidNoticesMap[self.uid] and xx.arrayContains(Framework.uidNoticesMap[self.uid], notice)
end
---结束模块当前任务
---@type fun(args:any[],...:any)
---@param args any[] 启动当前任务时传入的参数列表（需要封装成表）
---@vararg any
function Framework:finishModule(args, ...)
    ---@type Callback
    local callback = xx.getCallback(unpack(args))
    if callback then
        callback(...)
    end
    ---@type Signal
    local signal = xx.getSignal(unpack(args))
    if signal then
        signal(...)
    end
    ---@type Promise
    local promise = xx.getPromise(unpack(args))
    if promise then
        promise:resolve(...)
    end
end
---派发事件（需要支持冒泡）
---@param evt Event 事件对象
function Framework:callEvent(evt)
    xx.EventDispatcher.callEvent(self, evt)
    if not evt.isStopBubble and self.parent then
        self.parent:callEvent(evt)
    end
end
---获取上下文中的数据
---@type fun(key:string):any
---@param key string 数据键
---@return any 返回缓存的数据
function Framework:getContext(key)
    if self.parent then
        return self.parent:getContext(key)
    end
    if not self._context then
        return
    end
    return self._context[key]
end
---缓存数据到上下文中
---@type fun(key:string, value:any)
---@param key string 数据键
---@param value any 需要缓存的数据
function Framework:setContext(key, value)
    if self.parent then
        self.parent:setContext(key, value)
    else
        if not self._context then
            self._context = {}
        end
        self._context[key] = value
    end
end
---清除上下文中指定数据键的数据
---@type fun(key:string)
---@param key string 数据键
function Framework:clearContext(key)
    if self.parent then
        self.parent:clearContext(key)
    elseif self._context then
        if key then
            self._context[key] = nil
        else
            xx.tableClear(self._context)
        end
    end
end
---添加子状态机
---@type fun(state:Framework, alias:string|nil, to:boolean|nil)
---@param state Framework 子状态机
---@param alias string|nil 别名
---@param to boolean|nil 是否跳转到该子状态机
function Framework:addState(state, alias, to)
    local parent = self
    repeat
        if parent == state then
            return
        end
        parent = parent.parent
    until not parent
    if self == state.parent then
        if self._uidAliasMap[state.uid] and self._uidAliasMap[state.uid] ~= alias then
            self._aliasUIDMap[self._uidAliasMap[state.uid]] = nil
            self._uidAliasMap[state.uid] = nil
        end
        if alias then
            self._uidAliasMap[state.uid] = alias
            self._aliasUIDMap[alias] = state.uid
        end
        if self._stateUIDs[xx.arrayCount(self._stateUIDs)] ~= state.uid then
            xx.arrayRemove(self._stateUIDs, state.uid)
            xx.arrayPush(self._stateUIDs, state.uid)
        end
    else
        state:removeFromParent()
        xx.arrayPush(self._stateUIDs, state.uid)
        self._uidStateMap[state.uid] = state
        if alias then
            self._uidAliasMap[state.uid] = alias
            self._aliasUIDMap[alias] = state.uid
        end
        state.parent = self
        state:addEventListener(GIdentifiers.e_complete, self._onChildCompleteHandler, self)
        self.numStates = self.numStates + 1
    end
    if to then
        self:toState(state.uid)
    end
end
---移除子状态机
---@type fun(uidOrAlias:string|Framework)
---@param uidOrAlias string|Framework 子状态机对象，或者 uid、别名
function Framework:removeState(uidOrAlias)
    local state = nil
    if xx.isString(uidOrAlias) then
        if self._uidStateMap[uidOrAlias] then
            state = self._uidStateMap[uidOrAlias]
        elseif self._aliasUIDMap[uidOrAlias] then
            state = self._uidStateMap[self._aliasUIDMap[uidOrAlias]]
        end
    elseif xx.instanceOf(uidOrAlias, Framework) and self == uidOrAlias.parent then
        state = uidOrAlias
    end
    if state then
        state:removeEventListener(GIdentifiers.e_complete, self._onChildCompleteHandler, self)
        state.parent = nil
        xx.arrayRemove(self._stateUIDs, state.uid)
        self._uidStateMap[state.uid] = nil
        if self._uidAliasMap[state.uid] then
            self._aliasUIDMap[self._uidAliasMap[state.uid]] = nil
            self._uidAliasMap[state.uid] = nil
        end
        if self.curState == state then
            self.curState = nil
            state:defocus()
        end
        self.numStates = self.numStates - 1
    end
end
---从父状态机中移除
---@type fun()
function Framework:removeFromParent()
    if self.parent then
        self.parent:removeState(self)
    end
end
---跳转子状态
---@type fun(uidOrAlias:string|Framework)
---@param uidOrAlias string|Framework 子状态机对象，或者 uid、别名
function Framework:toState(uidOrAlias)
    local state = nil
    if xx.isString(uidOrAlias) then
        if self._uidStateMap[uidOrAlias] then
            state = self._uidStateMap[uidOrAlias]
        elseif self._aliasUIDMap[uidOrAlias] then
            state = self._uidStateMap[self._aliasUIDMap[uidOrAlias]]
        end
    elseif xx.instanceOf(uidOrAlias, Framework) and self == uidOrAlias.parent then
        state = uidOrAlias
    end
    local oldState = self.curState
    if oldState == state then
        return
    end
    self.curState = state
    if oldState then
        oldState:defocus()
    end
    if self.curState then
        if self.isActivated then
            self.curState:activate()
        elseif self.isFocused then
            self.curState:focus()
        elseif self.isConstructed then
            self.curState:construct()
        end
    end
end
---获取子状态机对应的别名
---@type fun(uid:string|Framework):string
---@param uid string|Framework 子状态机对象或者 uid
---@return string|nil 如果找到则返回别名，否则返回 nil
function Framework:getAlias(uid)
    if xx.isString(uid) then
        return self._uidAliasMap[uid]
    end
    if xx.instanceOf(uid, Framework) then
        return self._uidAliasMap[uid.uid]
    end
end
---获取子状态机对象
---@type fun(uidOrAlias:string):Framework
---@param uidOrAlias string uid 或者别名
---@return Framework|nil 如果找到则返回子状态机对象，否则返回 nil
function Framework:getState(uidOrAlias)
    if self._uidStateMap[uidOrAlias] then
        return self._uidStateMap[uidOrAlias]
    elseif self._aliasUIDMap[uidOrAlias] then
        return self._uidStateMap[self._aliasUIDMap[uidOrAlias]]
    end
end
---构造
---@type fun()
function Framework:construct()
    if not self.isConstructed then
        self.isConstructed = true
        if xx.isFunction(self.onConstruct) then
            self:onConstruct()
        end
        if self.isConstructed and self.curState then
            self.curState:construct()
        end
    end
end
---进入
---@type fun()
function Framework:focus()
    self:construct()
    if self.isConstructed and not self.isFocused then
        self.isFocused = true
        if xx.isFunction(self.onFocus) then
            self:onFocus()
        end
        if self.isFocused and self.curState then
            self.curState:focus()
        end
    end
end
---激活
---@type fun()
function Framework:activate()
    self:focus()
    if self.isFocused and not self.isActivated then
        self.isActivated = true
        if xx.isFunction(self.onActivate) then
            self:onActivate()
        end
        if self.isActivated and self.curState then
            self.curState:activate()
        end
    end
end
---失效
---@type fun()
function Framework:deactivate()
    if self.isActivated then
        if self.curState then
            self.curState:deactivate()
        end
        self.isActivated = false
        if xx.isFunction(self.onDeactivate) then
            self:onDeactivate()
        end
    end
end
---离开
---@type fun()
function Framework:defocus()
    self:deactivate()
    if self.isFocused then
        if self.curState then
            self.curState:defocus()
        end
        self.isFocused = false
        if xx.isFunction(self.onDefocus) then
            self:onDefocus()
        end
    end
end
---析构
---@type fun()
function Framework:destruct()
    self:defocus()
    if self.isConstructed then
        if self.curState then
            self.curState:destruct()
        end
        self.isConstructed = false
        for _, state in pairs(self._uidStateMap) do
            state:removeEventListener(GIdentifiers.e_complete, self._onChildCompleteHandler, self)
            state:destruct()
        end
        self.curState = nil
        self.numStates = 0
        xx.tableClear(self._context)
        xx.tableClear(self._stateUIDs)
        xx.tableClear(self._uidStateMap)
        xx.tableClear(self._uidAliasMap)
        xx.tableClear(self._aliasUIDMap)
        if xx.isFunction(self.onDestruct) then
            self:onDestruct()
        end
    end
end
---结束当前状态机
---@type fun(...:any)
---@vararg any
function Framework:finishState(...)
    self(GIdentifiers.e_complete, ...)
end
---子状态机结束回调
---@type fun(evt:Event)
---@param evt Event 事件对象
function Framework:_onChildCompleteHandler(evt)
    evt:stopImmediate()
    if self.curState ~= evt.currentTarget then
        return
    end
    self:toState()
    self:onChildComplete(evt.currentTarget, unpack(evt.args))
end
---子状态机结束实现
---@type fun(state:Framework,...:any)
---@param state Framework 子状态机对象
---@vararg any
function Framework:onChildComplete(state, ...)
    local index = xx.arrayIndexOf(self._stateUIDs, state.uid) + 1
    if index > xx.arrayCount(self._stateUIDs) then
        self:finishState(...)
    else
        self:toState(self._stateUIDs[index])
    end
end
---模块类
---@class Module:Framework by wx771720@outlook.com 2019-09-03 08:55:51
---@field _noticeHandlerMap table<string, Handler>
local Module = xx.Class("xx.Module", xx.Framework)
---@see Module
xx.Module = Module
---构造函数
function Module:ctor()
    self._noticeHandlerMap = {}
end
---构造完成函数
function Module:ctored()
    local notices = xx.tableKeys(self._noticeHandlerMap)
    if xx.arrayCount(notices) > 0 then
        self:register(unpack(notices))
    end
end
---@type fun(notice:string,result:NoticeResult,...:any): any, boolean
---@param notice strting 通知
---@param result NoticeResult 直接返回结果
---@vararg any
---@return any, boolean 返回数据，是否停止该通知的后续监听
function Module:onNotice(notice, result, ...)
    if self._noticeHandlerMap[notice] then
        return self._noticeHandlerMap[notice](self, result, ...)
    end
end
---状态机类
---@class State:Framework by wx771720@outlook.com 2019-09-03 09:57:09
local State = xx.Class("xx.State", xx.Framework)
---@see State
xx.State = State
---构造函数
function State:ctor()
end
---节点
---@class Node:EventDispatcher by wx771720@outlook.com 2019-09-29 16:42:21
---@field _children Node[] 子节点列表
---@field root Node 根节点
---@field parent Node 父节点
---@field numChildren number 子节点数量
local Node = xx.Class("xx.Node", xx.EventDispatcher)
---@see Node
xx.Node = Node
---构造函数
function Node:ctor()
    self._children = {}
    self.root = self
    self.numChildren = 0
end
---派发事件（需要支持冒泡）
---@param evt Event 事件对象
function Node:callEvent(evt)
    xx.EventDispatcher.callEvent(self, evt)
    if not evt.isStopBubble and self.parent then
        self.parent:callEvent(evt)
    end
end
---添加子节点
---@type fun(child:Node):Node|nil
---@param child Node 子节点
---@return Node|nil 返回添加成功的子节点
function Node:addChild(child)
    return self:addChildAt(child, self.numChildren + 1)
end
---添加子节点到指定索引
---@type fun(child:Node,index:number):Node|nil
---@param child Node 子节点
---@param index number 索引
---@return Node|nil 返回添加成功的子节点
function Node:addChildAt(child, index)
    if child then
        local parent = self
        repeat
            if parent == child then
                return
            end
            parent = parent.parent
        until not parent
        if self == child.parent then
            index = index <= 0 and 1 or (index > self.numChildren and self.numChildren or index)
            if self._children[index] ~= child then
                xx.arrayRemove(self._children, child)
                xx.arrayInsert(self._children, child, index)
            end
        else --新增子节点
            child(GIdentifiers.e_add, child)
            child:removeFromParent()
            self.numChildren = self.numChildren + 1
            index = index <= 0 and 1 or (index > self.numChildren and self.numChildren or index)
            xx.arrayInsert(self._children, child, index)
            child.parent = self
            child:_setRoot(self.root)
            child(GIdentifiers.e_added, child)
        end
        return child
    end
end
---移除子节点
---@type fun(child:Node):Node|nil
---@param child Node 子节点
---@return Node|nil 返回删除成功的子节点
function Node:removeChild(child)
    return child and self:removeChildAt(xx.arrayIndexOf(self._children, child))
end
---移除指定索引的子节点
---@type fun(index:number):Node|nil
---@param index number 索引
---@return Node|nil 返回删除成功的子节点
function Node:removeChildAt(index)
    if index >= 1 and index <= self.numChildren then
        local child = self._children[index]
        child(GIdentifiers.e_remove, child)
        self.numChildren = self.numChildren - 1
        xx.arrayRemoveAt(self._children, index)
        child:_setRoot(child)
        child.parent = nil
        child(GIdentifiers.e_removed, child)
        return child
    end
end
---移除多个子节点
---@type fun(beginIndex:number,endIndex:number)
---@param beginIndex number 起始索引（支持负索引），默认 1
---@param endIndex number 结束索引（支持负索引，移除的子节点包含该索引），默认 -1 表示最后一个子节点
function Node:removeChildren(beginIndex, endIndex)
    beginIndex = beginIndex and (beginIndex < 0 and self.numChildren + beginIndex + 1 or beginIndex) or 1
    endIndex = endIndex and (endIndex < 0 and self.numChildren + endIndex + 1 or endIndex) or self.numChildren
    for i = endIndex > self.numChildren and self.numChildren or endIndex, beginIndex < 1 and 1 or beginIndex, -1 do
        self:removeChildAt(i)
    end
end
---修改子节点索引
---@type fun(child:Node,index:number):Node|nil
---@param child Node 子节点
---@param index number 索引
---@return Node|nil 返回修改成功的子节点
function Node:setChildIndex(child, index)
    if index >= 1 and index <= self.numChildren and child and self == child.parent and self._children[index] ~= child then
        xx.arrayRemove(self._children, child)
        xx.arrayInsert(self._children, child, index)
        return child
    end
end
---获取子节点索引
---@type fun(child:Node):number
---@param child Node 子节点
---@return number 如果找到子节点则返回对应索引，否则返回 -1
function Node:getChildIndex(child)
    return child and self == child.parent and xx.arrayIndexOf(self._children, child) or -1
end
---获取指定索引的子节点
---@type fun(index:number):Node|nil
---@param index number 索引
---@return Node|nil 返回指定索引的子节点，如果索引超出范围则返回 nil
function Node:getChildAt(index)
    if index and index >= 1 and index <= self.numChildren then
        return self._children[index]
    end
end
---从父节点移除
---@type fun()
function Node:removeFromParent()
    if self.parent then
        self.parent:removeChild(self)
    end
end
---设置根节点
---@type fun(root:Node)
---@param root Node 根节点
function Node:_setRoot(root)
    if self.root ~= root then
        local oldRoot = self.root
        self.root = root
        self(GIdentifiers.e_root_changed, oldRoot)
        for _, child in ipairs(self._children) do
            child:_setRoot(root)
        end
    end
end
---@class CSEvent
---@field Target any
---@field Type string
---@field Args any[]
---@field CurrentTarget any
---@field IsStopBubble boolean
---@field IsStopImmediate boolean
---
---@field public StopBubble fun(self:CSEvent)
---@field public StopImmediate fun(self:CSEvent)
local CSEvent = xx.CSEvent
---@class Util
---@field Version string
---@field Timestamp number
---@field TimeRunning number
---
---@field public NewUID fun():string
---@field public NewUUID fun():string
---@field public Bezier fun(percent:number,...:number[]):number
---@field public StrInitialUpperCase fun(text:string):string
---@field public StrInitialLowerCase fun(text:string):string
---@field public GetUrlRaw fun(url:string):string
---@field public GetUrlParam fun(url:string,key:string):string
---@field public GetUrlExtension fun(url:string):string
---@field public GetUrlName fun(url:string):string
---@field public GetUrlPath fun(url:string):string
---@field public ToUrlParamStr fun(...:string[]):string
---
---@field public Notify fun(notice:string,...:any[]):any
---@field public Debug fun(message:string,...:any[])
---@field public Warn fun(message:string,...:any[])
---@field public Error fun(message:string,...:any[])
---@field public Later fun(handler:Handler,...:any[]):string
---@field public Delay fun(time:number,handler:Handler,...:any[]):string
---@field public Loop fun(interval:number,count:number,onOnce:Handler,onComplete:Handler,...:any[]):string
---@field public TimerPause fun(id:string)
---@field public TimerResume fun(id:string)
---@field public TimerStop fun(id:string)
---@field public TimerStop fun(id:string,trigger:boolean)
---@field public TimerRate fun(id:string)
---@field public TimerRate fun(id:string,rate:number)
---
---@field public Load fun(url:string,onComplete:Handler,onRetry:Handler,type:string,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadBinary fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadString fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadTexture fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadSprite fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadAudio fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadAssetBundle fun(url:string,onComplete:Handler,onRetry:Handler,tryCount:number,tryDelay:number,timeout:number):string
---@field public LoadStop fun(id:string)
---
---@field public NewOrRefresh fun(x:number,y:number,z:number):Vector3
---@field public NewOrRefresh fun(x:number,y:number,z:number,vector:Vector3):Vector3
---@field public NewOrRefresh fun(x:number,y:number):Vector2
---@field public NewOrRefresh fun(x:number,y:number,vector:Vector2):Vector2
---@field public NewOrRefresh fun(r:number,g:number,b:number,a:number):Color
---@field public NewOrRefresh fun(r:number,g:number,b:number,a:number,color:Color):Color
---
---@field UnityDataPath string
---@field UnityStreamingPath string
---@field UnityTemporaryPath string
---@field UnityPersistentPath string
---@field public GetRootGO fun():GameObject
---@field public GetRootCVS fun():GameObject
---@field public GetLayerGO fun(layer:number):GameObject
---@field public GetLayerCVS fun(layer:number):GameObject
local Util = xx.Util
---@class Color
---@field public New fun(r:number,g:number,b:number,a:number):Color
---@field public Lerp fun(a:Color,b:Color,t:number):Color
---@field public LerpUnclamped fun(a:Color,b:Color,t:number):Color
---@field public GrayScale fun(a:Color):number
---@field public Set fun(self:Color,r:number,g:number,b:number,a:number)
---@field public Get fun(self:Color):number,number,number,number
---@field public Equals fun(self:Color,other:Color):boolean
---@field red Color
---@field green Color
---@field blue Color
---@field white Color
---@field black Color
---@field yellow Color
---@field cyan Color
---@field magenta Color
---@field gray Color
---@field clear Color
---@field r number
---@field g number
---@field b number
---@field a number
Color = Color or {}
---@class Vector2
---@field public New fun(x:number,y:number):Vector2
---@field public Normalize fun(v:Vector2):Vector2
---@field public Dot fun(lhs:Vector2,rhs:Vector2):number
---@field public Angle fun(from:Vector2,to:Vector2):number
---@field public Magnitude fun(v:Vector2):number
---@field public Reflect fun(dir:Vector2,normal:Vector2):Vector2
---@field public Distance fun(a:Vector2,b:Vector2):number
---@field public Lerp fun(a:Vector2,b:Vector2,t:number):Vector2
---@field public LerpUnclamped fun(a:Vector2,b:Vector2,t:number):Vector2
---@field public MoveTowards fun(current:Vector2,target)
---@field public ClampMagnitude fun(v:Vector2,maxLength:number):Vector2
---@field public SmoothDamp fun(current:Vector2,target:Vector2,velocity:Vector2,smoothTime:number,maxSpeed:number,deltaTime:number):Vector2,Vector2
---@field public Max fun(a:Vector2,b:Vector2):Vector2
---@field public Min fun(a:Vector2,b:Vector2):Vector2
---@field public Scale fun(a:Vector2,b:Vector2):Vector2
---
---@field public Set fun(self:Vector2,x:number,y:number)
---@field public Get fun(self:Vector2):number,number
---@field public SqrMagnitude fun(self:Vector2):number
---@field public Clone fun(self:Vector2):Vector2
---@field public SetNormalize fun(self:Vector2):Vector2
---@field public Div fun(self:Vector2,d:Vector2):Vector2
---@field public Mul fun(self:Vector2,d:Vector2):Vector2
---@field public Add fun(self:Vector2,d:Vector2):Vector2
---@field public Sub fun(self:Vector2,d:Vector2):Vector2
---@field up Vector2
---@field right Vector2
---@field zero Vector2
---@field one Vector2
---@field x number
---@field y number
Vector2 = Vector2 or {}
---@class Vector3
---@field public New fun(x:number,y:number,z:number):Vector3
---@field public Distance fun(va:Vector3,vb:Vector3):number
---@field public Dot fun(lhs:Vector3,rhs:Vector3):number
---@field public Angle fun(from:Vector3,to:Vector3):number
---@field public Lerp fun(from:Vector3,to:Vector3,t:number):Vector3
---@field public Magnitude fun():number
---@field public Max fun(lhs:Vector3,rhs:Vector3):Vector3
---@field public Min fun(lhs:Vector3,rhs:Vector3):Vector3
---@field public Normalize fun(v:Vector3):Vector3
---@field public OrthoNormalize fun(va:Vector3,vb:Vector3,vc:Vector3):Vector3,Vector3,Vector3
---@field public MoveTowards fun(current:Vector3,target:Vector3,maxDistanceDelta:number):Vector3
---@field public RotateTowards fun(current:Vector3,target:Vector3,maxRadiansDelta:number,maxMagnitudeDelta:number):Vector3
---@field public SmoothDamp fun(current:Vector3,target:Vector3,currentVelocity:Vector3,smoothTime:number):Vector4,Vector3
---@field public Scale fun(a:Vector3,b:Vector3):Vector3
---@field public Cross fun(lhs:Vector3,rhs:Vector3):Vector3
---@field public Reflect fun(inDirection:Vector3,inNormal:Vector3):Vector3
---@field public Project fun(vector:Vector3,onNormal:Vector3):Vector3
---@field public ProjectOnPlane fun(vector:Vector3,planeNormal:Vector3):Vector3
---@field public Slerp fun(from:Vector3,to:Vector3,t:number):Vector3
---@field public AngleAroundAxis fun(from:Vector3,to:Vector3,axis:Vector3):number
---
---@field public Set fun(self:Vector3,x:number,y:number,z:number)
---@field public Get fun(self:Vector3):number,number,number
---@field public SqrMagnitude fun(self:Vector3):number
---@field public Clone fun(self:Vector3):Vector3
---@field public SetNormalize fun(self:Vector3):Vector3
---@field public ClampMagnitude fun(self:Vector3,maxLength:number):Vector3
---@field public Equals fun(self:Vector3,other:Vector3):boolean
---@field public Mul fun(self:Vector3,q:Vector3):Vector3
---@field public Div fun(self:Vector3,d:Vector3):Vector3
---@field public Add fun(self:Vector3,vb:Vector3):Vector3
---@field public Sub fun(self:Vector3,vb:Vector3):Vector3
---@field public MulQuat fun(self:Vector3,vb:Vector4):Vector3
---@field up Vector3
---@field down Vector3
---@field right Vector3
---@field left Vector3
---@field forward Vector3
---@field back Vector3
---@field zero Vector3
---@field one Vector3
---@field x number
---@field y number
---@field z number
Vector3 = Vector3 or {}
---@class Vector4
---@field public New fun(x:number,y:number,z:number,w:number):Vector4
---@field public Lerp fun(from:Vector4,to:Vector4,t:number):Vector4
---@field public MoveTowards fun(current:Vector4,target:Vector4,maxDistanceDelta:number):Vector4
---@field public Scale fun(a:Vector4,b:Vector4):Vector4
---@field public Dot fun(a:Vector4,b:Vector4):number
---@field public Project fun(a:Vector4,b:Vector4):Vector4
---@field public Distance fun(a:Vector4,b:Vector4):number
---@field public Magnitude fun(a:Vector4):number
---@field public SqrMagnitude fun(a:Vector4):number
---@field public Max fun(lhs:Vector4,rhs:Vector4):Vector4
---@field public Min fun(lhs:Vector4,rhs:Vector4):Vector4
---
---@field public Set fun(self:Vector4,x:number,y:number,z:number,w:number)
---@field public Get fun(self:Vector4):number,number,number,number
---@field public SetScale fun(self:Vector4,scale:Vector4)
---@field public Normalize fun(self:Vector4):Vector4
---@field public SetNormalize fun(self:Vector4):Vector4
---@field public Div fun(d:Vector4):Vector4
---@field public Mul fun(d:Vector4):Vector4
---@field public Add fun(b:Vector4):Vector4
---@field public Sub fun(b:Vector4):Vector4
---@field x number
---@field y number
---@field z number
---@field w number
Vector4 = Vector4 or {}
---@class UnityEngine.MonoBehaviour
local UnityEngineMonoBehaviour
---@class UnityEngine.Events
local UnityEngineEvents
---@class UnityEngine.Application
local UnityEngineApplication
---@class UnityEngine.Ray
local UnityEngineRay
---@class UnityEngine.Networking
local UnityEngineNetworking
---@class UnityEngine.Resources
local UnityEngineResources
---@class UnityEngine.Touch
local UnityEngineTouch
---@class UnityEngine.Physics
local UnityEnginePhysics
---@class UnityEngine.Plane
local UnityEnginePlane
---@class UnityEngine.Shader
local UnityEngineShader
---@class UnityEngine.AssetBundle
local UnityEngineAssetBundle
---@class UnityEngine.Time
local UnityEngineTime
---@class UnityEngine.Input
local UnityEngineInput
---@class UnityEngine.Bounds
local UnityEngineBounds
---@class UnityEngine.Material
local UnityEngineMaterial
---@class UnityEngine.Animator
local UnityEngineAnimator
---@class UnityEngine.ParticleSystem
local UnityEngineParticleSystem
---@class UnityEngine.Texture
local UnityEngineTexture
---@class UnityEngine.Screen
local UnityEngineScreen
---@class UnityEngine.Sprite
local UnityEngineSprite
---@class UnityEngine.Texture2D
local UnityEngineTexture2D
---@class UnityEngine.Renderer
local UnityEngineRenderer
---@class UnityEngine.Collider
local UnityEngineCollider
---@class UnityEngine.Camera
local UnityEngineCamera
---@class UnityEngine.Font
local UnityEngineFont
---@class UnityEngine
---@field Object UnityEngine.Object
---@field GameObject GameObject
---@field Component UnityEngine.Component
---@field Transform Transform
---@field RectTransform UnityEngine.RectTransform
---
---@field MonoBehaviour UnityEngine.MonoBehaviour
---@field Events UnityEngine.Events
---@field Application UnityEngine.Application
---@field Ray UnityEngine.Ray
---@field Networking UnityEngine.Networking
---@field Resources UnityEngine.Resources
---@field Touch UnityEngine.Touch
---@field Physics UnityEngine.Physics
---@field Plane UnityEngine.Plane
---@field Shader UnityEngine.Shader
---@field AssetBundle UnityEngine.AssetBundle
---@field Time UnityEngine.Time
---@field Input UnityEngine.Input
---@field Bounds UnityEngine.Bounds
---@field Material UnityEngine.Material
---@field Animator UnityEngine.Animator
---@field ParticleSystem UnityEngine.ParticleSystem
---@field Texture UnityEngine.Texture
---@field Screen UnityEngine.Screen
---@field Sprite UnityEngine.Sprite
---@field Texture2D UnityEngine.Texture2D
---@field Renderer UnityEngine.Renderer
---@field Collider UnityEngine.Collider
---@field Camera UnityEngine.Camera
UnityEngine = UnityEngine or {}
---@class UnityEngine.Object
---@field name string
---
---@field public Destroy fun(obj:UnityEngine.Object)
---@field public Instantiate fun(original:UnityEngine.Object):UnityEngine.Object
---@field public Instantiate fun(original:UnityEngine.Object,parent:Transform):UnityEngine.Object
local UnityEngineObject
---@class GameObject:UnityEngine.Object
---@field transform Transform
---
---@field Find fun(name:string):GameObject
---@field FindGameObjectsWithTag fun(tag:string):GameObject[]
---
---@field AddComponent fun(self:GameObject,type:any):UnityEngine.Component
---@field GetComponent fun(self:GameObject,type:string|any):UnityEngine.Component
---
---@field public GetVisible fun(self:GameObject):boolean
---@field public SetVisible fun(self:GameObject,visible:boolean)
---@field public GetAlpha fun(self:GameObject):number
---@field public SetAlpha fun(self:GameObject,alpha:number)
---@field public GetColor fun(self:GameObject):Color
---@field public SetColor fun(self:GameObject,color:Color)
---@field public SetColor fun(self:GameObject,rInOnce:number,gInOnce:number,bInOnce:number,aInOnce:number)
---
---@field public GetX fun(self:GameObject):number
---@field public SetX fun(self:GameObject,x:number)
---@field public GetY fun(self:GameObject):number
---@field public SetY fun(self:GameObject,y:number)
---@field public GetZ fun(self:GameObject):number
---@field public SetZ fun(self:GameObject,z:number)
---@field public SetPosition fun(self:GameObject,x:number,y:number)
---@field public SetPosition fun(self:GameObject,x:number,y:number,z:number)
---@field public GetScaleX fun(self:GameObject):number
---@field public SetScaleX fun(self:GameObject,scaleX:number)
---@field public GetScaleY fun(self:GameObject):number
---@field public SetScaleY fun(self:GameObject,scaleY:number)
---@field public GetScaleZ fun(self:GameObject):number
---@field public SetScaleZ fun(self:GameObject,scaleZ:number)
---@field public SetScale fun(self:GameObject,scaleX:number,scaleY:number)
---@field public SetScale fun(self:GameObject,scaleX:number,scaleY:number,scaleZ:number)
---@field public GetRotationX fun(self:GameObject):number
---@field public SetRotationX fun(self:GameObject,rotationX:number)
---@field public GetRotationY fun(self:GameObject):number
---@field public SetRotationY fun(self:GameObject,rotationY:number)
---@field public GetRotationZ fun(self:GameObject):number
---@field public SetRotationZ fun(self:GameObject,rotationZ:number)
---@field public SetRotation fun(self:GameObject,rotationZ:number)
---@field public SetRotation fun(self:GameObject,rotationZ:number,rotationY:number)
---@field public SetRotation fun(self:GameObject,rotationZ:number,rotationY:number,rotationX:number)
---
---@field public WorldToLocal fun(self:GameObject,worldX:number,worldY:number,worldZ:number):Vector3
---@field public WorldToLocal fun(self:GameObject,worldPoint:Vector3):Vector3
---@field public LocalToWorld fun(self:GameObject,localX:number,localY:number,localZ:number):Vector3
---@field public LocalToWorld fun(self:GameObject,localPoint:Vector3):Vector3
---
---@field public GetPivotX fun(self:GameObject):number
---@field public SetPivotX fun(self:GameObject,pivotX:number)
---@field public GetPivotY fun(self:GameObject):number
---@field public SetPivotY fun(self:GameObject,pivotY:number)
---@field public SetPivot fun(self:GameObject,pivotX:number,pivotY:number)
---@field public GetWidth fun(self:GameObject):number
---@field public SetWidth fun(self:GameObject,width:number)
---@field public GetHeight fun(self:GameObject):number
---@field public SetHeight fun(self:GameObject,height:number)
---@field public SetSize fun(self:GameObject,width:number,height:number)
---
---@field public AnchorTop fun(self:GameObject)
---@field public AnchorMiddle fun(self:GameObject)
---@field public AnchorBottom fun(self:GameObject)
---@field public AnchorLeft fun(self:GameObject)
---@field public AnchorCenter fun(self:GameObject)
---@field public AnchorRight fun(self:GameObject)
---@field public AnchorTopLeft fun(self:GameObject)
---@field public AnchorTopCenter fun(self:GameObject)
---@field public AnchorTopRight fun(self:GameObject)
---@field public AnchorMiddleLeft fun(self:GameObject)
---@field public AnchorMiddleCenter fun(self:GameObject)
---@field public AnchorMiddleRight fun(self:GameObject)
---@field public AnchorBottomLeft fun(self:GameObject)
---@field public AnchorBottomCenter fun(self:GameObject)
---@field public AnchorBottomRight fun(self:GameObject)
---@field public StretchHorizontal fun(self:GameObject)
---@field public StretchVertical fun(self:GameObject)
---@field public StretchBoth fun(self:GameObject)
---
---@field public AnchorSet fun(self:GameObject,minX:number|nil,minY:number|nil,maxX:number|nil,maxY:number|nil,pivotX:number|nil,pivotY:number|nil,x:number|nil,y:number|nil)
---@field public AnchorTop fun(self:GameObject,y:number)
---@field public AnchorMiddle fun(self:GameObject,y:number)
---@field public AnchorBottom fun(self:GameObject,y:number)
---@field public AnchorLeft fun(self:GameObject,x:number)
---@field public AnchorCenter fun(self:GameObject,x:number)
---@field public AnchorRight fun(self:GameObject,x:number)
---@field public AnchorTopLeft fun(self:GameObject,x:number,y:number)
---@field public AnchorTopCenter fun(self:GameObject,x:number,y:number)
---@field public AnchorTopRight fun(self:GameObject,x:number,y:number)
---@field public AnchorMiddleLeft fun(self:GameObject,x:number,y:number)
---@field public AnchorMiddleCenter fun(self:GameObject,x:number,y:number)
---@field public AnchorMiddleRight fun(self:GameObject,x:number,y:number)
---@field public AnchorBottomLeft fun(self:GameObject,x:number,y:number)
---@field public AnchorBottomCenter fun(self:GameObject,x:number,y:number)
---@field public AnchorBottomRight fun(self:GameObject,x:number,y:number)
---@field public StretchHorizontal fun(self:GameObject,left:number,right:number)
---@field public StretchVertical fun(self:GameObject,top:number,bottom:number)
---@field public StretchBoth fun(self:GameObject,left:number,right:number,top:number,bottom:number)
---
---@field public ScreenToLocal fun(self:GameObject,screenX:number,screenY:number):Vector2
---@field public ScreenToLocal fun(self:GameObject,screenPoint:Vector2):Vector2
---@field public LocalToScreen fun(self:GameObject,localX:number,localY:number):Vector2
---@field public LocalToScreen fun(self:GameObject,localPoint:Vector2):Vector2
---
---@field public SetBool fun(self:GameObject,name:string,value:boolean)
---@field public SetInteger fun(self:GameObject,name:string,value:number)
---@field public SetFloat fun(self:GameObject,name:string,value:number)
---@field public SetTrigger fun(self:GameObject,name:string)
---@field public PlayAnimator fun(self:GameObject,name:string)
---@field public StopAnimator fun(self:GameObject)
---@field public UpdateAnimator fun(self:GameObject,deltaTimeMS:number)
---
---@field public PlayParticleSystem fun(self:GameObject)
---@field public PlayParticleSystem fun(self:GameObject,withChildren:boolean)
---@field public PauseParticleSystem fun(self:GameObject)
---@field public PauseParticleSystem fun(self:GameObject,withChildren:boolean)
---@field public StopParticleSystem fun(self:GameObject)
---@field public StopParticleSystem fun(self:GameObject,withChildren:boolean)
---
---@field public GetTouchable fun(self:GameObject):boolean
---@field public SetTouchable fun(self:GameObject,touchable:boolean)
---@field public GetMaterial fun(self:GameObject):UnityEngine.Material
---@field public SetMaterial fun(self:GameObject,material:UnityEngine.Material)
---
---@field public ToImage fun(self:GameObject)
---@field public IsImage fun(self:GameObject):boolean
---@field public GetSprite fun(self:GameObject):UnityEngine.Sprite
---@field public SetSprite fun(self:GameObject,sprite:UnityEngine.Sprite)
---@field public SetNativeSize fun(self:GameObject)
---@field public SetTypeSimple fun(self:GameObject)
---@field public SetTypeSliced fun(self:GameObject)
---@field public SetTypeTiled fun(self:GameObject)
---@field public SetTypeFilled fun(self:GameObject)
---@field public SetFillHorizontal fun(self:GameObject)
---@field public SetFillVertical fun(self:GameObject)
---@field public SetFillRadia90 fun(self:GameObject)
---@field public SetFillRadia180 fun(self:GameObject)
---@field public SetFillRadia360 fun(self:GameObject)
---@field public SetOriginHorizontalLeft fun(self:GameObject)
---@field public SetOriginHorizontalRight fun(self:GameObject)
---@field public SetOriginVerticalBottom fun(self:GameObject)
---@field public SetOriginVerticalTop fun(self:GameObject)
---@field public SetOriginRadia90BottomLeft fun(self:GameObject)
---@field public SetOriginRadia90TopLeft fun(self:GameObject)
---@field public SetOriginRadia90TopRight fun(self:GameObject)
---@field public SetOriginRadia90BottomRight fun(self:GameObject)
---@field public SetOriginRadia180Bottom fun(self:GameObject)
---@field public SetOriginRadia180Left fun(self:GameObject)
---@field public SetOriginRadia180Top fun(self:GameObject)
---@field public SetOriginRadia180Right fun(self:GameObject)
---@field public SetOriginRadia360Bottom fun(self:GameObject)
---@field public SetOriginRadia360Right fun(self:GameObject)
---@field public SetOriginRadia360Top fun(self:GameObject)
---@field public SetOriginRadia360Left fun(self:GameObject)
---@field public GetFillAmount fun(self:GameObject):number
---@field public SetFillAmount fun(self:GameObject,amount:number)
---@field public GetFillClockwise fun(self:GameObject):boolean
---@field public SetFillClockwise fun(self:GameObject,clockwise:boolean)
---@field public GetFillCenter fun(self:GameObject):boolean
---@field public SetFillCenter fun(self:GameObject,fillCenter:boolean)
---@field public GetPreserveAspect fun(self:GameObject):boolean
---@field public SetPreserveAspect fun(self:GameObject,preserveAspect:boolean)
---
---@field public ToText fun(self:GameObject)
---@field public IsText fun(self:GameObject):boolean
---@field public GetText fun(self:GameObject):string
---@field public SetText fun(self:GameObject,text:string)
---@field public GetFontColor fun(self:GameObject):Color
---@field public SetFontColor fun(self:GameObject,color:Color)
---@field public GetFontSize fun(self:GameObject):number
---@field public SetFontSize fun(self:GameObject,fontSize:number)
---@field public GetFont fun(self:GameObject):UnityEngine.Font
---@field public SetFont fun(self:GameObject,font:UnityEngine.Font)
---@field public SetStyleNormal fun(self:GameObject)
---@field public SetStyleBold fun(self:GameObject)
---@field public SetStyleItalic fun(self:GameObject)
---@field public SetStyleBoldAndItalic fun(self:GameObject)
---@field public GetAlignByGeometry fun(self:GameObject):boolean
---@field public SetAlignByGeometry fun(self:GameObject,alignByGeometry:boolean)
---@field public SetHorizontalWrap fun(self:GameObject)
---@field public SetHorizontalOverflow fun(self:GameObject)
---@field public SetVerticalTruncate fun(self:GameObject)
---@field public SetVerticalOverflow fun(self:GameObject)
---@field public GetResizeTextForBestFit fun(self:GameObject):boolean
---@field public SetResizeTextForBestFit fun(self:GameObject,resizeTextForBestFit:boolean)
---@field public GetResizeTextMinSize fun(self:GameObject):number
---@field public SetResizeTextMinSize fun(self:GameObject,resizeTextMinSize:number)
---@field public GetResizeTextMaxSize fun(self:GameObject):number
---@field public SetResizeTextMaxSize fun(self:GameObject,resizeTextMaxSize:number)
---@field public SetResizeText fun(self:GameObject)
---@field public SetResizeText fun(self:GameObject,resizeTextForBestFit:boolean,resizeTextMinSize:number,resizeTextMaxSize:number)
---@field public GetLineSpacing fun(self:GameObject):number
---@field public SetLineSpacing fun(self:GameObject,lineSpacing:number)
---@field public SetAlignUpperLeft fun(self:GameObject)
---@field public SetAlignUpperCenter fun(self:GameObject)
---@field public SetAlignUpperRight fun(self:GameObject)
---@field public SetAlignMiddleLeft fun(self:GameObject)
---@field public SetAlignMiddleCenter fun(self:GameObject)
---@field public SetAlignMiddleRight fun(self:GameObject)
---@field public SetAlignLowerLeft fun(self:GameObject)
---@field public SetAlignLowerCenter fun(self:GameObject)
---@field public SetAlignLowerRight fun(self:GameObject)
---@field public SetAutoSizeHorizontal fun(self:GameObject,autoSize:boolean)
---@field public SetAutoSizeVertical fun(self:GameObject,autoSize:boolean)
---@field public SetAutoSize fun(self:GameObject)
---@field public SetAutoSize fun(self:GameObject,horizontal:boolean,vertical:boolean)
---
---@field public AddEventListener fun(self:GameObject,type:string,handler:Handler,...:any[])
---@field public Once fun(self:GameObject,type:string,handler:Handler,...:any[])
---@field public RemoveEventListener fun(self:GameObject,type:string|nil,handler:Handler|nil)
---@field public HasEventListener fun(self:GameObject,type:string|nil,handler:Handler|nil)
---@field public Dispatch fun(self:GameObject,type:string,...:any[])
---
---@field public GetFromHolder fun(self:GameObject,name:string):any
GameObject = UnityEngine.GameObject
---@class UnityEngine.Component:UnityEngine.Object
---@field gameObject GameObject
---
---@field public GetComponent fun(self:UnityEngine.Component,type:string):UnityEngine.Component
local UnityEngineComponent
---@class Transform:UnityEngine.Component
---@field childCount number
---
---@field public Find fun(self:Transform,name:string):Transform
---@field public FindChild fun(self:Transform,name:string):Transform
---@field public GetChild fun(self:Transform,index:number):Transform
---@field public SetParent fun(self:Transform,parent:Transform)
---@field public SetParent fun(self:Transform,parent:Transform,worldPositionStays:boolean)
---@field public SetSiblingIndex fun(self:Transform,index:number)
---@field public LookAt fun(self:Transform,target:Transform)
---@field public LookAt fun(self:Transform,worldPosition:Vector3)
---@field public LookAt fun(self:Transform,worldPosition:Vector3,worldUp:Vector3)
---@field public TransformPoint fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public TransformPoint fun(self:Transform,position:Vector3):Vector3
---@field public TransformDirection fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public TransformDirection fun(self:Transform,direction:Vector3):Vector3
---@field public TransformVector fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public TransformVector fun(self:Transform,position:Vector3):Vector3
---@field public InverseTransformPoint fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public InverseTransformPoint fun(self:Transform,position:Vector3):Vector3
---@field public InverseTransformDirection fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public InverseTransformDirection fun(self:Transform,direction:Vector3):Vector3
---@field public InverseTransformVector fun(self:Transform,x:number,y:number,z:number):Vector3
---@field public InverseTransformVector fun(self:Transform,position:Vector3):Vector3
Transform = UnityEngine.Transform
---unity 显示对象代理
---@class Sprite:Node by wx771720@outlook.com 2019-09-29 18:31:27
---@field _csTypeHandlerMap table<string,Handler> Unity 组件事件类型 - 回调函数
---
---@field _propertyHandler table 属性改变回调
---@field gameObject GameObject Unity 游戏对象
---@field pivotX number x 轴心比例
---@field pivotY number y 轴心比例
---@field x number x 坐标
---@field y number y 坐标
---@field z number z 坐标
---@field width number 宽度
---@field height number 高度
---@field scaleX number x 轴缩放
---@field scaleY number y 轴缩放
---@field scaleZ number z 轴缩放
---@field rotationX number x 轴旋转度数
---@field rotationY number y 轴旋转度数
---@field rotationZ number z 轴旋转度数
---@field alpha number 透明度
---@field visible boolean 是否可见
---@field tint Color 着色
---@field touchable boolean 是否可交互
---
---@field source UnityEngine.Sprite 图片纹理
---@field fillAmount number 填充值，范围[0-1]
---@field fillClockwise boolean 是否顺时针
---@field fillCenter boolean 九宫格是否填充中间
---@field preserveAspect boolean 是否保持宽高比
---
---@field text string 文本
---@field fontColor Color 文本颜色
---@field fontSize number 字号
---@field font UnityEngine.Font 字体
---@field alignByGeometry number 是否对齐几何线
---@field resizeTextForBestFit boolean 是否缩放到合适的字号
---@field resizeTextMinSize number 最小的缩放字号
---@field resizeTextMaxSize number 最大的缩放字号
---@field lineSpacing number 行高倍数
local Sprite = xx.Class("xx.Sprite", xx.Node)
---@see Sprite
xx.Sprite = Sprite
Sprite.property_pivot_x = "pivotX"
Sprite.property_pivot_y = "pivotY"
Sprite.property_x = "x"
Sprite.property_y = "y"
Sprite.property_z = "z"
Sprite.property_width = "width"
Sprite.property_height = "height"
Sprite.property_scale_x = "scaleX"
Sprite.property_scale_y = "scaleY"
Sprite.property_scale_z = "scaleZ"
Sprite.property_rotation_x = "rotationX"
Sprite.property_rotation_y = "rotationY"
Sprite.property_rotation_z = "rotationZ"
Sprite.property_alpha = "alpha"
Sprite.property_visible = "visible"
Sprite.property_tint = "tint"
Sprite.property_touchable = "touchable"
Sprite.property_source = "source"
Sprite.property_fill_amount = "fillAmount"
Sprite.property_fill_clockwise = "fillClockwise"
Sprite.property_fill_center = "fillCenter"
Sprite.property_preserve_aspect = "preserveAspect"
Sprite.property_text = "text"
Sprite.property_font_color = "fontColor"
Sprite.property_font_size = "fontSize"
Sprite.property_font = "font"
Sprite.property_align_by_geometry = "alignByGeometry"
Sprite.property_resize_text_for_best_fit = "resizeTextForBestFit"
Sprite.property_resize_text_min_size = "resizeTextMinSize"
Sprite.property_resize_text_max_size = "resizeTextMaxSize"
Sprite.property_line_spacing = "lineSpacing"
function Sprite:onDynamicChanged(key, newValue, oldValue)
    if self._propertyHandler[key] then
        self._propertyHandler[key](self.gameObject, newValue)
    end
    xx.Node.onDynamicChanged(self, key, newValue, oldValue)
end
---构造函数
---@param gameObject GameObject|nil
function Sprite:ctor(gameObject)
    self.gameObject = gameObject or UnityEngine.GameObject(self.uid, typeof("UnityEngine.RectTransform"))
    self._csTypeHandlerMap = {}
    self._propertyHandler = {}
    self._propertyHandler[Sprite.property_pivot_x] = self.gameObject.SetPivotX
    self._propertyHandler[Sprite.property_pivot_y] = self.gameObject.SetPivotY
    self._propertyHandler[Sprite.property_x] = self.gameObject.SetX
    self._propertyHandler[Sprite.property_y] = self.gameObject.SetY
    self._propertyHandler[Sprite.property_z] = self.gameObject.SetZ
    self._propertyHandler[Sprite.property_width] = self.gameObject.SetWidth
    self._propertyHandler[Sprite.property_height] = self.gameObject.SetHeight
    self._propertyHandler[Sprite.property_scale_x] = self.gameObject.SetScaleX
    self._propertyHandler[Sprite.property_scale_y] = self.gameObject.SetScaleY
    self._propertyHandler[Sprite.property_scale_z] = self.gameObject.SetScaleZ
    self._propertyHandler[Sprite.property_rotation_x] = self.gameObject.SetRotationX
    self._propertyHandler[Sprite.property_rotation_y] = self.gameObject.SetRotationY
    self._propertyHandler[Sprite.property_rotation_z] = self.gameObject.SetRotationZ
    self._propertyHandler[Sprite.property_alpha] = self.gameObject.SetAlpha
    self._propertyHandler[Sprite.property_visible] = self.gameObject.SetVisible
    self._propertyHandler[Sprite.property_tint] = self.gameObject.SetColor
    self._propertyHandler[Sprite.property_touchable] = self.gameObject.SetTouchable
    self._propertyHandler[Sprite.property_source] = self.gameObject.SetSprite
    self._propertyHandler[Sprite.property_fill_amount] = self.gameObject.SetFillAmount
    self._propertyHandler[Sprite.property_fill_clockwise] = self.gameObject.SetFillClockwise
    self._propertyHandler[Sprite.property_fill_center] = self.gameObject.SetFillCenter
    self._propertyHandler[Sprite.property_preserve_aspect] = self.gameObject.SetPreserveAspect
    self._propertyHandler[Sprite.property_text] = self.gameObject.SetText
    self._propertyHandler[Sprite.property_font_color] = self.gameObject.SetFontColor
    self._propertyHandler[Sprite.property_font_size] = self.gameObject.SetFontSize
    self._propertyHandler[Sprite.property_font] = self.gameObject.SetFont
    self._propertyHandler[Sprite.property_align_by_geometry] = self.gameObject.SetAlignByGeometry
    self._propertyHandler[Sprite.property_resize_text_for_best_fit] = self.gameObject.SetResizeTextForBestFit
    self._propertyHandler[Sprite.property_resize_text_min_size] = self.gameObject.SetResizeTextMinSize
    self._propertyHandler[Sprite.property_resize_text_max_size] = self.gameObject.SetResizeTextMaxSize
    self._propertyHandler[Sprite.property_line_spacing] = self.gameObject.SetLineSpacing
    xx.Class.setter(self, Sprite.property_pivot_x, self.gameObject:GetPivotX())
    xx.Class.setter(self, Sprite.property_pivot_y, self.gameObject:GetPivotY())
    xx.Class.setter(self, Sprite.property_x, self.gameObject:GetX())
    xx.Class.setter(self, Sprite.property_y, self.gameObject:GetY())
    xx.Class.setter(self, Sprite.property_z, self.gameObject:GetZ())
    xx.Class.setter(self, Sprite.property_width, self.gameObject:GetWidth())
    xx.Class.setter(self, Sprite.property_height, self.gameObject:GetHeight())
    xx.Class.setter(self, Sprite.property_scale_x, self.gameObject:GetScaleX())
    xx.Class.setter(self, Sprite.property_scale_y, self.gameObject:GetScaleY())
    xx.Class.setter(self, Sprite.property_scale_z, self.gameObject:GetScaleZ())
    xx.Class.setter(self, Sprite.property_rotation_x, self.gameObject:GetRotationX())
    xx.Class.setter(self, Sprite.property_rotation_y, self.gameObject:GetRotationY())
    xx.Class.setter(self, Sprite.property_rotation_z, self.gameObject:GetRotationZ())
    xx.Class.setter(self, Sprite.property_alpha, self.gameObject:GetAlpha())
    xx.Class.setter(self, Sprite.property_visible, self.gameObject:GetVisible())
    xx.Class.setter(self, Sprite.property_tint, self.gameObject:GetColor())
    if self:isImage() then
        xx.Class.setter(self, Sprite.property_touchable, self.gameObject:GetTouchable())
        xx.Class.setter(self, Sprite.property_source, self.gameObject:GetSprite())
        xx.Class.setter(self, Sprite.property_fill_amount, self.gameObject:GetFillAmount())
        xx.Class.setter(self, Sprite.property_fill_clockwise, self.gameObject:GetFillClockwise())
        xx.Class.setter(self, Sprite.property_fill_center, self.gameObject:GetFillCenter())
        xx.Class.setter(self, Sprite.property_preserve_aspect, self.gameObject:GetPreserveAspect())
    end
    if self:isText() then
        xx.Class.setter(self, Sprite.property_touchable, self.gameObject:GetTouchable())
        xx.Class.setter(self, Sprite.property_text, self.gameObject:GetText())
        xx.Class.setter(self, Sprite.property_font_color, self.gameObject:GetFontColor())
        xx.Class.setter(self, Sprite.property_font_size, self.gameObject:GetFontSize())
        xx.Class.setter(self, Sprite.property_font, self.gameObject:GetFont())
        xx.Class.setter(self, Sprite.property_align_by_geometry, self.gameObject:GetAlignByGeometry())
        xx.Class.setter(self, Sprite.property_resize_text_for_best_fit, self.gameObject:GetResizeTextForBestFit())
        xx.Class.setter(self, Sprite.property_resize_text_min_size, self.gameObject:GetResizeTextMinSize())
        xx.Class.setter(self, Sprite.property_resize_text_max_size, self.gameObject:GetResizeTextMaxSize())
        xx.Class.setter(self, Sprite.property_line_spacing, self.gameObject:GetLineSpacing())
    end
end
---添加事件回调
---@type fun(type:string, handler:Handler, caller:any, ...:any[]):EventDispatcher
---@param type string 事件类型
---@param handler Handler 回调函数，return: boolean（是否立即停止执行后续回调）, boolean（是否停止冒泡）
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入
---@return EventDispatcher self
function Sprite:addEventListener(type, handler, caller, ...)
    xx.EventDispatcher.addEventListener(self, type, handler, caller, ...)
    self:checkCSEvents()
    return self
end
---添加事件回调
---@type fun(type:string, handler:Handler, caller:any, ...:any[]):EventDispatcher
---@param type string 事件类型
---@param handler Handler 回调函数，return: boolean（是否立即停止执行后续回调）, boolean（是否停止冒泡）
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入
---@return EventDispatcher self
function Sprite:once(type, handler, caller, ...)
    xx.EventDispatcher.once(self, type, handler, caller, ...)
    self:checkCSEvents()
    return self
end
---删除事件回调
---@type fun(type:string, handler:Handler, caller:any):EventDispatcher
---@param type string|nil 事件类型，默认 nil 表示移除所有 handler 和 caller 回调
---@param handler Handler|nil 回调函数，默认 nil 表示移除所有包含 handler 回调
---@param caller any|nil 回调方法所属的对象，匿名函数或者静态函数可不传入，默认 nil 表示移除所有包含 caller 的回调
---@return EventDispatcher self
function Sprite:removeEventListener(type, handler, caller)
    xx.EventDispatcher.removeEventListener(self, type, handler, caller)
    self:checkCSEvents()
    return self
end
---等待事件触发
---@type fun(type:string):Promise
---@param type string 事件类型
---@return Promise 异步对象
function Sprite:wait(type)
    local promise = xx.EventDispatcher.wait(self, type)
    self:checkCSEvents()
    return promise
end
---取消等待事件
---@type fun(type:string|nil):EventDispatcher
---@param type string|nil 事件类型，null 表示取消所有等待事件
---@return EventDispatcher self
function Sprite:removeWait(type)
    xx.EventDispatcher.removeWait(self, type)
    self:checkCSEvents()
    return self
end
function Sprite:checkCSEvents()
    for type, csHandler in pairs(self._csTypeHandlerMap) do
        if not self:hasEventListener(type) and not self:hasWait(type) then
            self.gameObject:RemoveEventListener(type, csHandler)
            self._csTypeHandlerMap[type] = nil
        end
    end
    for type, _ in pairs(self._typeCallbacksMap) do
        if not self._csTypeHandlerMap[type] then
            self._csTypeHandlerMap[type] = xx.Handler(self._onCSHandler, self)
            self.gameObject:AddEventListener(type, self._csTypeHandlerMap[type])
        end
    end
    for type, _ in pairs(self._typePromisesMap) do
        if not self._csTypeHandlerMap[type] then
            self._csTypeHandlerMap[type] = xx.Handler(self._onCSHandler, self)
            self.gameObject:AddEventListener(type, self._csTypeHandlerMap[type])
        end
    end
end
---派发事件
---@type fun(csEvent:CSEvent)
---@param csEvent CSEvent 事件类型
function Sprite:_onCSHandler(csEvent)
    local type = csEvent.Type
    if csEvent.Args and csEvent.Args.Length > 0 then
        local args = {}
        for i = 0, csEvent.Args.Length - 1 do
            xx.arrayPush(args, csEvent.Args[i])
        end
        self(type, unpack(args))
    else
        self(type)
    end
    self:checkCSEvents()
end
---添加子节点到指定索引
---@type fun(child:Sprite,index:number):Sprite|nil
---@param child Sprite 子节点
---@param index number 索引
---@return Sprite|nil 返回添加成功的子节点
function Sprite:addChildAt(child, index)
    child = xx.Node.addChildAt(self, child, index)
    if xx.instanceOf(child, Sprite) then
        child.gameObject.transform:SetParent(self.gameObject.transform, false)
        self:_refreshIndex()
    end
    return child
end
---移除指定索引的子节点
---@type fun(index:number):Sprite|nil
---@param index number 索引
---@return Sprite|nil 返回删除成功的子节点
function Sprite:removeChildAt(index)
    ---@type Sprite
    local child = xx.Node.removeChildAt(self, index)
    if xx.instanceOf(child, Sprite) then
        child.gameObject.transform:SetParent(nil, false)
        return child
    end
end
---修改子节点索引
---@type fun(child:Sprite,index:number):Sprite|nil
---@param child Sprite 子节点
---@param index number 索引
---@return Sprite|nil 返回修改成功的子节点
function Sprite:setChildIndex(child, index)
    child = xx.Node.setChildIndex(self, child, index)
    if xx.instanceOf(child, Sprite) then
        self:_refreshIndex()
        return child
    end
end
---刷新 unity 子对象层级
---@type fun()
function Sprite:_refreshIndex()
    ---@type Sprite
    local child
    local siblingIndex = 0
    for i = 1, self.numChildren do
        child = self._children[i]
        child.gameObject.transform:SetSiblingIndex(i - 1)
    end
end
function Sprite:getFromHolder(name)
    return self.gameObject:GetFromHolder(name)
end
function Sprite:anchorSet(minX, minY, maxX, maxY, pivotX, pivotY, x, y)
    self.gameObject:AnchorSet(minX, minY, maxX, maxY, pivotX, pivotY, x, y)
end
function Sprite:anchorTop(y)
    self.gameObject:AnchorTop(y or 0)
end
function Sprite:anchorMiddle(y)
    self.gameObject:AnchorMiddle(y or 0)
end
function Sprite:anchorBottom(y)
    self.gameObject:AnchorBottom(y or 0)
end
function Sprite:anchorLeft(x)
    self.gameObject:AnchorLeft(x or 0)
end
function Sprite:anchorCenter(x)
    self.gameObject:AnchorCenter(x or 0)
end
function Sprite:anchorRight(x)
    self.gameObject:AnchorRight(x or 0)
end
function Sprite:anchorTopLeft(x, y)
    self.gameObject:AnchorTopLeft(x or 0, y or 0)
end
function Sprite:anchorTopCenter(x, y)
    self.gameObject:AnchorTopCenter(x or 0, y or 0)
end
function Sprite:anchorTopRight(x, y)
    self.gameObject:AnchorTopRight(x or 0, y or 0)
end
function Sprite:anchorMiddleLeft(x, y)
    self.gameObject:AnchorMiddleLeft(x or 0, y or 0)
end
function Sprite:anchorMiddleCenter(x, y)
    self.gameObject:AnchorMiddleCenter(x or 0, y or 0)
end
function Sprite:anchorMiddleRight(x, y)
    self.gameObject:AnchorMiddleRight(x or 0, y or 0)
end
function Sprite:anchorBottomLeft(x, y)
    self.gameObject:AnchorBottomLeft(x or 0, y or 0)
end
function Sprite:anchorBottomCenter(x, y)
    self.gameObject:AnchorBottomCenter(x or 0, y or 0)
end
function Sprite:anchorBottomRight(x, y)
    self.gameObject:AnchorBottomRight(x or 0, y or 0)
end
function Sprite:stretchHorizontal(left, right)
    self.gameObject:StretchHorizontal(left or 0, right or 0)
end
function Sprite:stretchVertical(top, bottom)
    self.gameObject:StretchVertical(top or 0, bottom or 0)
end
function Sprite:stretchBoth(left, right, top, bottom)
    self.gameObject:StretchBoth(left or 0, right or 0, top or 0, bottom or 0)
end
function Sprite:worldToLocal(worldX, worldY, worldZ)
    return self.gameObject:WorldToLocal(worldX, worldY, worldZ)
end
function Sprite:localToWorld(localX, localY, localZ)
    return self.gameObject:LocalToWorld(localX, localY, localZ)
end
function Sprite:screenToLocal(screenX, screenY)
    return self.gameObject:ScreenToLocal(screenX, screenY)
end
function Sprite:localToScreen(screenX, screenY)
    return self.gameObject:LocalToScreen(screenX, screenY)
end
function Sprite:toImage()
    self.gameObject:ToImage()
    xx.Class.setter(self, Sprite.property_touchable, self.gameObject:GetTouchable())
    xx.Class.setter(self, Sprite.property_source, self.gameObject:GetSprite())
    xx.Class.setter(self, Sprite.property_fill_amount, self.gameObject:GetFillAmount())
    xx.Class.setter(self, Sprite.property_fill_clockwise, self.gameObject:GetFillClockwise())
    xx.Class.setter(self, Sprite.property_fill_center, self.gameObject:GetFillCenter())
    xx.Class.setter(self, Sprite.property_preserve_aspect, self.gameObject:GetPreserveAspect())
end
function Sprite:isImage()
    return self.gameObject:IsImage()
end
function Sprite:setNativeSize()
    self.gameObject:SetNativeSize()
end
function Sprite:setTypeSimple()
    self.gameObject:SetTypeSimple()
end
function Sprite:setTypeSliced()
    self.gameObject:SetTypeSliced()
end
function Sprite:setTypeTiled()
    self.gameObject:SetTypeTiled()
end
function Sprite:setTypeFilled()
    self.gameObject:SetTypeFilled()
end
function Sprite:setFillHorizontal()
    self.gameObject:SetFillHorizontal()
end
function Sprite:setFillVertical()
    self.gameObject:SetFillVertical()
end
function Sprite:setFillRadia90()
    self.gameObject:SetFillRadia90()
end
function Sprite:setFillRadia180()
    self.gameObject:SetFillRadia180()
end
function Sprite:setFillRadia360()
    self.gameObject:SetFillRadia360()
end
function Sprite:setOriginHorizontalLeft()
    self.gameObject:SetOriginHorizontalLeft()
end
function Sprite:setOriginHorizontalRight()
    self.gameObject:SetOriginHorizontalRight()
end
function Sprite:setOriginVerticalBottom()
    self.gameObject:SetOriginVerticalBottom()
end
function Sprite:setOriginVerticalTop()
    self.gameObject:SetOriginVerticalTop()
end
function Sprite:setOriginRadia90BottomLeft()
    self.gameObject:SetOriginRadia90BottomLeft()
end
function Sprite:setOriginRadia90TopLeft()
    self.gameObject:SetOriginRadia90TopLeft()
end
function Sprite:setOriginRadia90TopRight()
    self.gameObject:SetOriginRadia90TopRight()
end
function Sprite:setOriginRadia90BottomRight()
    self.gameObject:SetOriginRadia90BottomRight()
end
function Sprite:setOriginRadia180Bottom()
    self.gameObject:SetOriginRadia180Bottom()
end
function Sprite:setOriginRadia180Left()
    self.gameObject:SetOriginRadia180Left()
end
function Sprite:setOriginRadia180Top()
    self.gameObject:SetOriginRadia180Top()
end
function Sprite:setOriginRadia180Right()
    self.gameObject:SetOriginRadia180Right()
end
function Sprite:setOriginRadia360Bottom()
    self.gameObject:SetOriginRadia360Bottom()
end
function Sprite:setOriginRadia360Right()
    self.gameObject:SetOriginRadia360Right()
end
function Sprite:setOriginRadia360Top()
    self.gameObject:SetOriginRadia360Top()
end
function Sprite:setOriginRadia360Left()
    self.gameObject:SetOriginRadia360Left()
end
function Sprite:toText()
    self.gameObject:ToText()
    xx.Class.setter(self, Sprite.property_touchable, self.gameObject:GetTouchable())
    xx.Class.setter(self, Sprite.property_text, self.gameObject:GetText())
    xx.Class.setter(self, Sprite.property_font_color, self.gameObject:GetFontColor())
    xx.Class.setter(self, Sprite.property_font_size, self.gameObject:GetFontSize())
    xx.Class.setter(self, Sprite.property_font, self.gameObject:GetFont())
    xx.Class.setter(self, Sprite.property_align_by_geometry, self.gameObject:GetAlignByGeometry())
    xx.Class.setter(self, Sprite.property_resize_text_for_best_fit, self.gameObject:GetResizeTextForBestFit())
    xx.Class.setter(self, Sprite.property_resize_text_min_size, self.gameObject:GetResizeTextMinSize())
    xx.Class.setter(self, Sprite.property_resize_text_max_size, self.gameObject:GetResizeTextMaxSize())
    xx.Class.setter(self, Sprite.property_line_spacing, self.gameObject:GetLineSpacing())
end
function Sprite:isText()
    return self.gameObject:IsText()
end
function Sprite:setStyleNormal()
    self.gameObject:SetStyleNormal()
end
function Sprite:setStyleBold()
    self.gameObject:SetStyleBold()
end
function Sprite:setStyleItalic()
    self.gameObject:SetStyleItalic()
end
function Sprite:setStyleBoldAndItalic()
    self.gameObject:SetStyleBoldAndItalic()
end
function Sprite:setHorizontalWrap()
    self.gameObject:SetHorizontalWrap()
end
function Sprite:setHorizontalOverflow()
    self.gameObject:SetHorizontalOverflow()
end
function Sprite:setVerticalTruncate()
    self.gameObject:SetVerticalTruncate()
end
function Sprite:setVerticalOverflow()
    self.gameObject:SetVerticalOverflow()
end
function Sprite:setResizeText(resizeTextForBestFit, resizeTextMinSize, resizeTextMaxSize)
    self.gameObject:SetResizeText(resizeTextForBestFit, resizeTextMinSize, resizeTextMaxSize)
end
function Sprite:setAlignUpperLeft()
    self.gameObject:SetAlignUpperLeft()
end
function Sprite:setAlignUpperCenter()
    self.gameObject:SetAlignUpperCenter()
end
function Sprite:setAlignUpperRight()
    self.gameObject:SetAlignUpperRight()
end
function Sprite:setAlignMiddleLeft()
    self.gameObject:SetAlignMiddleLeft()
end
function Sprite:setAlignMiddleCenter()
    self.gameObject:SetAlignMiddleCenter()
end
function Sprite:setAlignMiddleRight()
    self.gameObject:SetAlignMiddleRight()
end
function Sprite:setAlignLowerLeft()
    self.gameObject:SetAlignLowerLeft()
end
function Sprite:setAlignLowerCenter()
    self.gameObject:SetAlignLowerCenter()
end
function Sprite:setAlignLowerRight()
    self.gameObject:SetAlignLowerRight()
end
function Sprite:setAutoSizeHorizontal(autoSize)
    self.gameObject:SetAutoSizeHorizontal(autoSize)
end
function Sprite:setAutoSizeVertical(autoSize)
    self.gameObject:SetAutoSizeVertical(autoSize)
end
function Sprite:setAutoSize(horizontal, vertical)
    self.gameObject:SetAutoSize(horizontal, vertical)
end
function Sprite:setBool(name, value)
    self.gameObject:SetBool(name, value)
end
function Sprite:setInteger(name, value)
    self.gameObject:SetInteger(name, value)
end
function Sprite:setFloat(name, value)
    self.gameObject:SetFloat(name, value)
end
function Sprite:setTrigger(name)
    self.gameObject:SetTrigger(name)
end
function Sprite:playAnimator(name)
    self.gameObject:PlayAnimator(name)
end
function Sprite:playAnimator(name)
    self.gameObject:PlayAnimator(name)
end
function Sprite:stopAnimator()
    self.gameObject:StopAnimator()
end
function Sprite:updateAnimator(deltaTimeMS)
    self.gameObject:UpdateAnimator(deltaTimeMS)
end
function Sprite:playParticleSystem(withChildren)
    self.gameObject:PlayParticleSystem(true == withChildren)
end
function Sprite:pauseParticleSystem(withChildren)
    self.gameObject:PauseParticleSystem(true == withChildren)
end
function Sprite:stopParticleSystem(withChildren)
    self.gameObject:StopParticleSystem(true == withChildren)
end
---unity 显示对象根代理
---@class Root:Sprite by wx771720@outlook.com 2019-10-12 16:38:20
---@field _rootGO GameObject 实际根节点
---@field _layerMap table<number,Sprite>
---@field _childLayerMap table<Sprite,number>
local Root = xx.Class("xx.Root", xx.Sprite)
---@see Root
xx.Root = Root
---构造函数
---@param cvs GameObject 实际使用根节点下的画布节点
---@param go GameObject 实际根节点
function Root:ctor(cvs, go)
    self._rootGO = go
    self._layerMap = {}
    self._childLayerMap = {}
end
function Root:getFromHolder(name)
    return self._rootGO:GetFromHolder(name)
end
---添加代理到指定层
---@param child Sprite
---@param layer number
function Root:layerAdd(child, layer)
    if not self._layerMap[layer] then
        self._layerMap[layer] = xx.Sprite(xx.Util.GetLayerCVS(layer))
    end
    if self._childLayerMap[child] and self._childLayerMap[child] ~= layer then
        self:layerRemove(child)
    end
    self._childLayerMap[child] = layer
    self._layerMap[layer]:addChild(child)
end
---移除代理
---@param child Sprite
function Root:layerRemove(child)
    if not self._childLayerMap[child] then
        return
    end
    self._layerMap[self._childLayerMap[child]]:removeChild(child)
    self._childLayerMap[child] = nil
end
---将代理在所在层置顶
---@param child Sprite
function Root:layerTop(child)
    if not self._childLayerMap[child] then
        return
    end
    self._layerMap[self._childLayerMap[child]]:addChild(child)
end
---将代理在所在层置底
---@param child Sprite
function Root:layerBottom(child)
    if not self._childLayerMap[child] then
        return
    end
    self._layerMap[self._childLayerMap[child]]:addChildAt(child, 0)
end
---定时器
---@class Timer:ObjectEx by wx771720@outlook.com 2019-09-03 18:25:12
---@field duration number 间隔时长（单位：毫秒）
---@field count number 执行次数
---@field rate number 速率
---@field onOnce Callback 执行回调
---@field onComplete Callback 完成回调
---@field counted number 已执行次数
---@field time number 已运行时长（单位：毫秒）
---@field isPaused boolean 是否已暂停
---@field isStopped boolean 是否已停止
---@field trigger boolean 是否在主动停止时触发完成回调
local Timer = xx.Class("xx.Timer")
---构造函数
function Timer:ctor(duration, count, rate, onOnce, onComplete)
    self.duration = duration
    self.count = count
    self.rate = rate
    self.onOnce = onOnce
    self.onComplete = onComplete
    self.counted = 0
    self.time = 0
    self.isPaused = false
    self.isStopped = false
    self.trigger = false
end
---判断定时器是否已完成
---@type fun():boolean
---@return boolean 如果已完成则返回 true，否则返回 false
function Timer:isComplete()
    return self.count > 0 and self.counted >= self.count
end
---定时器模块
---@class MTimer:Module by wx771720@outlook.com 2019-09-03 08:50:01
---@field _isPaused boolean 是否已暂停定时器模块
---@field _timerList Timer[] 定时器列表
---@field _uidTimerMap table<string, Timer> id - 定时器
local MTimer = xx.Class("xx.MTimer", xx.Module)
---@see Timer
xx.MTimer = MTimer
---构造函数
function MTimer:ctor()
    self._isPaused = false
    self._timerList = {}
    self._uidTimerMap = {}
    self._noticeHandlerMap[GIdentifiers.nb_timer] = self.onAppTimer
    self._noticeHandlerMap[GIdentifiers.nb_pause] = self.onAppPause
    self._noticeHandlerMap[GIdentifiers.nb_resume] = self.onAppResume
    self._noticeHandlerMap[GIdentifiers.ni_timer_new] = self.onNew
    self._noticeHandlerMap[GIdentifiers.ni_timer_pause] = self.onPause
    self._noticeHandlerMap[GIdentifiers.ni_timer_resume] = self.onResume
    self._noticeHandlerMap[GIdentifiers.ni_timer_stop] = self.onStop
    self._noticeHandlerMap[GIdentifiers.ni_timer_rate] = self.onRate
end
---@param result NoticeResult 直接返回结果
---@param interval number 帧间隔（单位：毫秒）
function MTimer:onAppTimer(result, interval)
    if self._isPaused then
        return
    end
    if interval < 1000 then
        for i = xx.arrayCount(self._timerList), 1, -1 do
            local timer = self._timerList[i]
            if timer.isStopped then
                self._uidTimerMap[timer.uid] = nil
                xx.arrayRemoveAt(self._timerList, i)
                if timer.trigger and timer.onComplete then -- 触发回调
                    timer.onComplete()
                end
            elseif not timer.isPaused then -- 正常
                local time = interval * timer.rate
                timer.time = timer.time + time
                local count = timer.duration > 0 and math.floor(timer.time / timer.duration) - timer.counted or 1
                while count > 0 and not timer:isComplete() and not timer.isPaused and not timer.isStopped do
                    timer.counted = timer.counted + 1
                    if timer.onOnce then -- 触发回调
                        timer.onOnce(time, timer.counted)
                    end
                    time = 0
                    count = count - 1
                end
                if timer:isComplete() and not timer.isPaused and not timer.isStopped then
                    self._uidTimerMap[timer.uid] = nil
                    xx.arrayRemoveAt(self._timerList, i)
                    if timer.onComplete then -- 触发回调
                        timer.onComplete()
                    end
                end
            end
        end
    end
    xx.Promise.asyncLoop()
end
---@param result NoticeResult 直接返回结果
function MTimer:onAppPause(result)
    self._isPaused = true
end
---@param result NoticeResult 直接返回结果
function MTimer:onAppResume(result)
    self._isPaused = false
end
---@param result NoticeResult 直接返回结果
---@param durationOrTimer number|Timer 时间间隔（单位：毫秒）或者 Timer 对象
---@param countOrOnComplete number|Callback 执行次数或者完成回调、信号、异步
---@param onOnce Callback 执行回调、信号、异步
---@param onComplete Callback 完成回调、信号、异步
function MTimer:onNew(result, durationOrTimer, countOrOnComplete, onOnce, onComplete)
    ---@type Timer
    local timer
    if xx.instanceOf(durationOrTimer, Timer) then
        timer = durationOrTimer
        if xx.isNil(timer.onComplete) and xx.instanceOf(countOrOnComplete, xx.Callback) then
            timer.onComplete = countOrOnComplete
        end
    else
        timer = Timer(durationOrTimer, countOrOnComplete, 1, onOnce, onComplete)
    end
    xx.arrayPush(self._timerList, timer)
    self._uidTimerMap[timer.uid] = timer
    result.data = timer.uid
end
---@param result NoticeResult 直接返回结果
---@param id string 定时器 id
function MTimer:onPause(result, id)
    if self._uidTimerMap[id] then
        self._uidTimerMap[id].isPaused = true
    end
end
---@param result NoticeResult 直接返回结果
---@param id string 定时器 id
function MTimer:onResume(result, id)
    if self._uidTimerMap[id] then
        self._uidTimerMap[id].isPaused = false
    end
end
---@param result NoticeResult 直接返回结果
---@param id string 定时器 id
---@param trigger boolean 是否触发回调
function MTimer:onStop(result, id, trigger)
    if self._uidTimerMap[id] then
        self._uidTimerMap[id].isStopped = true
        self._uidTimerMap[id].trigger = trigger
    end
end
---@param result NoticeResult 直接返回结果
---@param id string 定时器 id
---@param rate number 速率
function MTimer:onRate(result, id, rate)
    local id, rate = unpack(args)
    if self._uidTimerMap[id] then
        self._uidTimerMap[id].rate = rate
    end
end
---下一帧执行回调
---@type fun(handler:Handler,caller:any,...:any):string
---@param handler Handler 回调函数
---@param caller any 回调函数所属对象
---@vararg any
---@return string 定时器 id
function xx.later(handler, caller, ...)
    return xx.notify(GIdentifiers.ni_timer_new, 0, 1, nil, xx.Callback(handler, caller, ...))
end
---延迟指定时长执行回调
---@type fun(time:number,handler:Handler,caller:any,...:any):string
---@param time number 延迟时长（单位：毫秒）
---@param handler Handler 回调函数
---@param caller any 回调函数所属对象
---@vararg any
---@return string 定时器 id
function xx.delay(time, handler, caller, ...)
    return xx.notify(GIdentifiers.ni_timer_new, time, 1, nil, xx.Callback(handler, caller, ...))
end
---按指定间隔调用指定次数回调
---@type fun(interval:number,count:number,onOnce:Handler,caller:any,onComplete:Handler,...:any):string
---@param interval number 间隔时长（单位：毫秒）
---@param count number 调用次数
---@param onOnce Handler 单次回调函数
---@param caller any 回调函数所属对象
---@param onComplete Handler 所有次数完成回调函数
---@vararg any
---@return string 定时器 id
function xx.loop(interval, count, onOnce, caller, onComplete, ...)
    onOnce = xx.isFunction(onOnce) and xx.Callback(onOnce, caller, ...) or nil
    onComplete = xx.isFunction(onComplete) and xx.Callback(onComplete, caller, ...) or nil
    return xx.notify(GIdentifiers.ni_timer_new, interval, count, onOnce, onComplete)
end
---睡眠指定时长
---@type fun(time:number):Promise
---@param time number 等待时长（单位：毫秒）
---@return Promise 返回异步对象
function xx.sleep(time)
    local promise = xx.Promise()
    return promise, xx.delay(
        time,
        function()
            promise:resolve()
        end
    )
end
---暂停定时器
---@type fun(id:string)
---@param id string 定时器 id
function xx.timerPause(id)
    xx.notify(GIdentifiers.ni_timer_pause, id)
end
---继续定时器
---@type fun(id:string)
---@param id string 定时器 id
function xx.timerResume(id)
    xx.notify(GIdentifiers.ni_timer_resume, id)
end
---停止定时器
---@type fun(id:string,trigger:boolean)
---@param id string 定时器 id
---@param trigger boolean 是否触发完成回调，默认 false
function xx.timerStop(id, trigger)
    if not xx.isBoolean(trigger) then
        trigger = false
    end
    xx.notify(GIdentifiers.ni_timer_stop, id, trigger)
end
---修改定时器速率
---@type fun(id:string,rate:number)
---@param id string 定时器 id
---@param rate number 定时器速率，默认 1 表示恢复正常速率
function xx.timerRate(id, rate)
    if not xx.isNumber(rate) then
        rate = 1
    end
    xx.notify(GIdentifiers.ni_timer_rate, id, rate)
end
xx.getInstance("xx.MTimer")
---缓动回调步骤
---@class TweenCallbackStep:ObjectEx by wx771720@outlook.com 2019-12-09 15:51:21
---@field _tween Tween 缓动器
---@field _callback Callback 结束时回调
local TweenCallbackStep = xx.Class("TweenCallbackStep")
---构造函数
function TweenCallbackStep:ctor(tween, onComplete)
    self._tween = tween
    self._callback = onComplete
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenCallbackStep:update(interval)
    self._tween.stepIndex = self._tween.stepIndex + 1
    if self._callback then
        self._callback()
    end
    return interval
end
---缓动帧步骤
---@class TweenFrameStep:ObjectEx by wx771720@outlook.com 2019-10-28 17:05:37
---@field _tween Tween 缓动器
---@field _count number 帧数（触发后开始计数）
---
---@field _counted number 已经过帧数
local TweenFrameStep = xx.Class("xx.TweenFrameStep")
---构造函数
function TweenFrameStep:ctor(tween, count)
    self._tween = tween
    self._count = count
    self._counted = 0
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenFrameStep:update(interval)
    if self._counted >= self._count then
        self._counted = 0
        self._tween.stepIndex = self._tween.stepIndex + 1
    else
        self._counted = self._counted + 1
        interval = 0
    end
    return interval
end
---缓动循环步骤
---@class TweenLoopStep:ObjectEx by wx771720@outlook.com 2019-10-26 18:43:59
---@field _tween Tween 缓动器
---@field _count number 缓动次数（触发后开始计数）
---@field _preCount number 循环之前的步骤数量，0 表示循环之前所有的步骤
---@field _onOnce Callback 单次执行时回调
---
---@field _counted number 已执行次数
local TweenLoopStep = xx.Class("xx.TweenLoopStep")
---构造函数
function TweenLoopStep:ctor(tween, count, preCount, onOnce)
    self._tween = tween
    self._count = count or 0
    self._preCount = preCount or 0
    self._onOnce = onOnce
    self._counted = 0
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenLoopStep:update(interval)
    if self._counted > 0 and self._onOnce then
        self._onOnce()
    end
    if self._count <= 0 or self._counted < self._count then
        self._counted = self._counted + 1
        if self._preCount <= 0 or self._preCount >= self._tween.stepIndex then
            self._tween.stepIndex = 1
        else
            self._tween.stepIndex = self._tween.stepIndex - self._preCount
        end
    else
        self._counted = 0
        self._tween.stepIndex = self._tween.stepIndex + 1
    end
    return interval
end
---缓动设置速率步骤
---@class TweenRateStep:ObjectEx by wx771720@outlook.com 2019-10-26 18:58:46
---@field _tween Tween 缓动器
---@field _isTo boolean 属性值是否为最终值
---@field _rate number 速率
local TweenRateStep = xx.Class("xx.TweenRateStep")
---构造函数
function TweenRateStep:ctor(tween, isTo, rate)
    self._tween = tween
    self._isTo = isTo
    self._rate = rate or 1
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenRateStep:update(interval)
    self._tween.rate = self._isTo and self._rate or self._tween.rate + self._rate
    self._tween.stepIndex = self._tween.stepIndex + 1
    return interval
end
---缓动设置属性步骤
---@class TweenSetStep:ObjectEx by wx771720@outlook.com 2019-10-28 14:31:09
---@field _tween Tween 缓动器
---@field _isTo boolean 属性值是否为最终值
---@field _properties table<string,any> 键值对
local TweenSetStep = xx.Class("xx.TweenSetStep")
---构造函数
function TweenSetStep:ctor(tween, isTo, properties)
    self._tween = tween
    self._isTo = isTo
    self._properties = properties
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenSetStep:update(interval)
    for _, target in ipairs(self._tween.targets) do
        for k, v in pairs(self._properties) do
            if not self._isTo then
                v = v + self._tween.curValueMap[target][k]
            end
            self._tween.curValueMap[target][k] = v
            target[k] = v
        end
    end
    self._tween.stepIndex = self._tween.stepIndex + 1
    return interval
end
---缓动睡眠步骤
---@class TweenSleepStep:ObjectEx by wx771720@outlook.com 2019-10-28 14:27:08
---@field _tween Tween 缓动器
---@field _time number 睡眠时长（单位：毫秒）
---
---@field _timePassed number 已经过时长
local TweenSleepStep = xx.Class("xx.TweenSleepStep")
---构造函数
function TweenSleepStep:ctor(tween, time)
    self._tween = tween
    self._time = time or 1000
    self._timePassed = 0
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenSleepStep:update(interval)
    self._timePassed = self._timePassed + interval
    if self._timePassed >= self._time then
        interval = self._timePassed - self._time
        self._timePassed = 0
        self._tween.stepIndex = self._tween.stepIndex + 1
    else
        interval = 0
    end
    return interval
end
---缓动步骤
---@class TweenStep:ObjectEx by wx771720@outlook.com 2019-10-28 15:22:39
---@field _tween Tween 缓动器
---@field _isTo boolean 属性值是否为最终值
---@field _properties table<string,any> 键值对
---@field _time number 缓动时长（单位：毫秒）
---@field _playback boolean 是否回播
---@field _ease Ease 缓动函数
---@field _onPlayback Callback 回播时回调
---@field _onUpdate Callback 更新时回调
---
---@field _timePassed number 已经过的时长（单位：毫秒）
---@field _beginMap table<any,table<string,any>> 对象 - 起始键值对
---@field _changeMap table<any,table<string,any>> 对象 - 变化键值对
local TweenStep = xx.Class("xx.TweenStep")
---构造函数
function TweenStep:ctor(tween, isTo, properties, time, playback, ease, onPlayback, onUpdate)
    self._tween = tween
    self._isTo = isTo
    self._properties = properties
    self._time = time or 1000
    if xx.isBoolean(playback) then
        self._playback = playback
    else
        self._playback = false
    end
    self._ease = ease or xx.easeLinear
    self._onPlayback = onPlayback
    self._onUpdate = onUpdate
    self._timePassed = 0
end
---更新
---type fun(interval:number):number
---@param interval number 帧间隔（单位：毫秒）
---@return number 剩余时长（单位：毫秒）
function TweenStep:update(interval)
    if not self._beginMap then
        self._beginMap = {}
        self._changeMap = {}
        for _, target in ipairs(self._tween.targets) do
            local beginMap = {}
            local changeMap = {}
            for k, v in pairs(self._properties) do
                beginMap[k] = self._tween.curValueMap[target][k]
                if xx.isTable(v) then
                    changeMap[k] = {0}
                    for i = 1, xx.arrayCount(v) do
                        xx.arrayPush(changeMap[k], self._isTo and v[i] - beginMap[k] or v[i])
                    end
                else -- 普通缓动
                    changeMap[k] = self._isTo and v - beginMap[k] or v
                end
            end
            self._beginMap[target] = beginMap
            self._changeMap[target] = changeMap
        end
    end
    local halfTime = self._time / 2
    local isPlayback = self._playback and self._timePassed < halfTime and self._timePassed + interval >= halfTime
    self._timePassed = self._timePassed + interval
    local value
    local time = self._timePassed > self._time and self._time or self._timePassed
    if self._playback then
        time = (time < halfTime and time or self._time - time) * 2
    end
    for _, target in ipairs(self._tween.targets) do
        local beginMap = self._beginMap[target]
        local changeMap = self._changeMap[target]
        for k, beginV in pairs(beginMap) do
            local change = changeMap[k]
            if xx.isTable(change) then
                value = beginV + xx.bezier(self._ease(time, 0, 1, self._time), unpack(change))
            else
                value = self._ease(time, beginV, change, self._time)
            end
            self._tween.curValueMap[target][k] = value
            target[k] = value
            if self._onUpdate then
                self._onUpdate(target, k, value)
            end
        end
    end
    if isPlayback and self._onPlayback then
        self._onPlayback()
    end
    if self._timePassed >= self._time then
        interval = self._timePassed - self._time
        self._timePassed = 0
        self._beginMap = nil
        self._changeMap = nil
        self._tween.stepIndex = self._tween.stepIndex + 1
    else
        interval = 0
    end
    return interval
end
---停止缓动对象类
---@class TweenStop:ObjectEx by wx771720@outlook.com 2019-10-25 20:22:03
---@field target any 对象
---@field trigger boolean 是否在停止时触发回调
---@field toEnd boolean 是否在停止时设置属性为结束值
local TweenStop = xx.Class("TweenStop")
---构造函数
function TweenStop:ctor(target, trigger, toEnd)
    self.target = target
    self.trigger = trigger
    self.toEnd = toEnd
end
---缓动函数
---@alias Ease fun(time:number,begin:number,change:number,duration:number):number
---线性
function xx.easeLinear(time, begin, change, duration)
    return begin + change * time / duration
end
---平方根-以较慢速度开始运动，然后在执行时加快运动速度
function xx.CircularIn(time, begin, change, duration)
    time = time / duration
    return -change * (math.sqrt(1 - time * time) - 1) + begin
end
---平方根-以较快速度开始运动，然后在执行时减慢运动速度
function xx.CircularOut(time, begin, change, duration)
    time = time / duration - 1
    return change * math.sqrt(1 - time * time) + begin
end
---平方根-缓慢地开始运动，进行加速运动，再进行减速
function xx.CircularInOut(time, begin, change, duration)
    time = 2 * time / duration
    if time < 1 then
        return -change / 2 * (math.sqrt(1 - time * time) - 1) + begin
    end
    time = time - 2
    return change / 2 * (math.sqrt(1 - time * time) + 1) + begin
end
---二次-以零速率开始运动，然后在执行时加快运动速度
function xx.QuadraticIn(time, begin, change, duration)
    time = time / duration
    return change * time * time + begin
end
---二次-以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零
function xx.QuadraticOut(time, begin, change, duration)
    time = time / duration
    return -change * time * (time - 2) + begin
end
---二次-开始运动时速率为零，先对运动进行加速，再减速直到速率为零
function xx.QuadraticInOut(time, begin, change, duration)
    time = 2 * time / duration
    if time < 1 then
        return change / 2 * time * time + begin
    end
    time = time - 1
    return -change / 2 * (time * (time - 2) - 1) + begin
end
---三次-以零速率开始运动，然后在执行时加快运动速度
function xx.CubicIn(time, begin, change, duration)
    time = time / duration
    return change * time * time * time + begin
end
---三次-以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零
function xx.CubicOut(time, begin, change, duration)
    time = time / duration - 1
    return change * (time * time * time + 1) + begin
end
---三次-开始运动时速率为零，先对运动进行加速，再减速直到速率为零
function xx.CubicInOut(time, begin, change, duration)
    time = 2 * time / duration
    if time < 1 then
        return change / 2 * time * time * time + begin
    end
    time = time - 2
    return change / 2 * (time * time * time + 2) + begin
end
---四次-以零速率开始运动，然后在执行时加快运动速度
function xx.QuarticIn(time, begin, change, duration)
    time = time / duration
    return change * time * time * time * time + begin
end
---四次-以较快的速度开始运动，然后减慢运行速度，直至速率为零
function xx.QuarticOut(time, begin, change, duration)
    time = time / duration - 1
    return -change * (time * time * time * time - 1) + begin
end
---四次-开始运动时速率为零，先对运动进行加速，再减速直到速率为零
function xx.QuarticInOut(time, begin, change, duration)
    time = 2 * time / duration
    if time < 1 then
        return change / 2 * time * time * time * time + begin
    end
    time = time - 2
    return -change / 2 * (time * time * time * time - 2) + begin
end
---五次-以零速率开始运动，然后在执行时加快运动速度
function xx.QuinticIn(time, begin, change, duration)
    time = time / duration
    return change * time * time * time * time * time + begin
end
---五次-以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零
function xx.QuinticOut(time, begin, change, duration)
    time = time / duration - 1
    return change * (time * time * time * time * time + 1) + begin
end
---五次-开始运动时速率为零，先对运动进行加速，再减速直到速率为零
function xx.QuinticInOut(time, begin, change, duration)
    time = 2 * time / duration
    if time < 1 then
        return change / 2 * time * time * time * time * time + begin
    end
    time = time - 2
    return change / 2 * (time * time * time * time * time + 2) + begin
end
---幂-以较慢速度开始运动，然后在执行时加快运动速度
function xx.ExponentialIn(time, begin, change, duration)
    if 0 == time then
        return begin
    end
    return change * (2 ^ (10 * (time / duration - 1))) + begin
end
---幂-以较快速度开始运动，然后在执行时减慢运动速度
function xx.ExponentialOut(time, begin, change, duration)
    if time == duration then
        return begin + change
    end
    return change * (1 - (2 ^ (-10 * time / duration))) + begin
end
---幂-缓慢地开始运动，进行加速运动，再进行减速
function xx.ExponentialInOut(time, begin, change, duration)
    if 0 == time then
        return begin
    end
    if time == duration then
        return begin + change
    end
    time = 2 * time / duration
    if time < 1 then
        return change / 2 * (2 ^ (10 * (time - 1))) + begin
    end
    time = time - 1
    return change / 2 * (2 - (2 ^ (-10 * time))) + begin
end
---三角函数-以零速率开始运动，然后在执行时加快运动速度
function xx.SineIn(time, begin, change, duration)
    return -change * math.cos(time / duration * (math.pi / 2)) + change + begin
end
---三角函数-以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零
function xx.SineOut(time, begin, change, duration)
    return change * math.sin(time / duration * (math.pi / 2)) + begin
end
---三角函数-开始运动时速率为零，先对运动进行加速，再减速直到速率为零
function xx.SineInOut(time, begin, change, duration)
    return -change / 2 * (math.cos(math.pi * time / duration) - 1) + begin
end
---碰撞反弹-以较慢速度开始回弹运动，然后在执行时加快运动速度
function xx.BounceIn(time, begin, change, duration)
    return change - xx.BounceOut(duration - time, 0, change, duration) + begin
end
---碰撞反弹-以较快速度开始回弹运动，然后在执行时减慢运动速度
function xx.BounceOut(time, begin, change, duration)
    time = time / duration
    if time < (1 / 2.75) then
        return change * (7.5625 * time * time) + begin
    elseif time < (2 / 2.75) then
        time = time - (1.5 / 2.75)
        return change * (7.5625 * time * time + 0.75) + begin
    elseif time < (2.5 / 2.75) then
        time = time - (2.25 / 2.75)
        return change * (7.5625 * time * time + 0.9375) + begin
    end
    time = time - (2.625 / 2.75)
    return change * (7.5625 * time * time + 0.984375) + begin
end
---碰撞反弹-缓慢地开始跳动，进行加速运动，再进行减速
function xx.BounceInOut(time, begin, change, duration)
    if time < duration / 2 then
        return xx.BounceIn(time * 2, 0, change, duration) * 0.5 + begin
    end
    return xx.BounceOut(time * 2 - duration, 0, change, duration) * 0.5 + change * 0.5 + begin
end
local BACK = 1.70158
---过冲-开始时朝后运动，然后反向朝目标移动
function xx.BackIn(time, begin, change, duration)
    time = time / duration
    return change * time * time * ((BACK + 1) * time - BACK) + begin
end
---过冲-开始运动时是朝目标移动，稍微过冲，再倒转方向回来朝着目标
function xx.BackOut(time, begin, change, duration)
    time = time / duration - 1
    return change * (time * time * ((BACK + 1) * time + BACK) + 1) + begin
end
---过冲-开始运动时是朝后跟踪，再倒转方向并朝目标移动，稍微过冲目标，然后再次倒转方向，回来朝目标移动
function xx.BackInOut(time, begin, change, duration)
    local s = BACK
    time = 2 * time / duration
    if time < 1 then
        s = s * 1.525
        return change / 2 * (time * time * ((s + 1) * time - s)) + begin
    end
    time = time - 2
    s = s * 1.525
    return change / 2 * (time * time * ((s + 1) * time + s) + 2) + begin
end
---弹簧-以较慢速度开始运动，然后在执行时加快运动速度
function xx.ElasticIn(time, begin, change, duration)
    if 0 == time then
        return begin
    end
    time = time / duration
    if 1 == time then
        return begin + change
    end
    local p = duration * 0.3
    local s = p / 4
    time = time - 1
    return -(change * (2 ^ (10 * time)) * math.sin((time * duration - s) * (2 * math.pi) / p)) + begin
end
---弹簧-以较快速度开始运动，然后在执行时减慢运动速度
function xx.ElasticOut(time, begin, change, duration)
    if 0 == time then
        return begin
    end
    time = time / duration
    if 1 == time then
        return begin + change
    end
    local p = duration * 0.3
    local s = p / 4
    return change * (2 ^ (-10 * time)) * math.sin((time * duration - s) * (2 * math.pi) / p) + change + begin
end
---弹簧-缓慢地开始运动，进行加速运动，再进行减速
function xx.ElasticInOut(time, begin, change, duration)
    if 0 == time then
        return begin
    end
    time = 2 * time / duration
    if 2 == time then
        return begin + change
    end
    local p = duration * (0.3 * 1.5)
    local s = p / 4
    if time < 1 then
        time = time - 1
        return -0.5 * (change * (2 ^ (10 * time)) * math.sin((time * duration - s) * (2 * math.pi) / p)) + begin
    end
    time = time - 1
    return change * (2 ^ (-10 * time)) * math.sin((time * duration - s) * (2 * math.pi) / p) * 0.5 + change + begin
end
---缓动器
---@class Tween:Promise by wx771720@outlook.com 2019-10-25 18:17:58
---@field rate number 速率
---@field targets any[] 缓动对象列表
---@field curValueMap table<any,table<string,any>> 缓动对象 - 当前值[k-v]
---@field endValueMap table<any,table<string,any>> 缓动对象 - 结束值[k-v]
---@field stepIndex number 当前步骤索引
---@field stepList TweenStep[] 步骤列表
---@field stopList TweenStop[] 停止缓动对象列表
---@field isPaused boolean 是否已暂停
---@field isStopped boolean 是否已停止
---@field trigger boolean 是否在停止时触发回调
---@field toEnd boolean 是否在停止时设置属性为结束值
---@field isCompleted boolean 判断缓动器是否已结束
local Tween = xx.Class("xx.Tween", xx.Promise)
---构造函数
function Tween:ctor(...)
    self.rate = 1
    self.targets = {...}
    self.curValueMap = {}
    self.endValueMap = {}
    for _, target in ipairs(self.targets) do
        self.curValueMap[target] = {}
        self.endValueMap[target] = {}
    end
    self.stepIndex = 1
    self.stepList = {}
    self.stopList = {}
    self.isPaused = false
    self.isStopped = false
    self.trigger = false
    self.toEnd = false
    self.isCompleted = false
end
---获取属性值
---@type fun(key:string):any
---@param key string 属性名
---@return any 属性值
function Tween:getter(key)
    if "isCompleted" == key then
        return self.stepIndex > xx.arrayCount(self.stepList)
    end
    return xx.Class.getter(self, key)
end
---暂停
---@type fun()
function Tween:pause()
    self.isPaused = true
end
---继续
---@type fun()
function Tween:resume()
    self.isPaused = false
end
---停止
---@type fun(trigger:boolean,toEnd:boolean,...:any)
---@param trigger boolean 是否在停止时触发回调
---@param trigger boolean 是否在停止时设置属性为结束值
---@vararg any
function Tween:stop(trigger, toEnd, ...)
    local targets = {...}
    local count = xx.arrayCount(targets)
    if 0 == count then
        self.isStopped = true
        self.trigger = trigger
        self.toEnd = toEnd
    else
        for i = 1, count do
            xx.arrayPush(TweenStop(targets[i], trigger, toEnd))
        end
    end
end
---添加缓动属性值步骤
---@type fun(properties:table<string,number>,time:number,playback:boolean|nil,ease:Ease|nil,onPlayback:Callback|nil,onUpdate:Callback|nil):Tween
---@param properties table<string,number> 键值对，支持 number[] 值表表示贝塞尔缓动
---@param time number 缓动时长（单位：毫秒）
---@param playback boolean|nil 是否回播，默认 false
---@param ease Ease|nil 缓动函数，默认 nil 表示线性缓动
---@param onPlayback Callback 回播时回调，默认 nil
---@param onUpdate Callback 更新时回调，默认 nil
---@return Tween self
function Tween:to(properties, time, playback, ease, onPlayback, onUpdate)
    for _, target in ipairs(self.targets) do
        local curMap = self.curValueMap[target]
        local endMap = self.endValueMap[target]
        for k, v in pairs(properties) do
            if not curMap[k] then
                curMap[k] = target[k]
            end
            if not playback then
                endMap[k] = xx.isTable(v) and v[xx.arrayCount(v)] or v
            elseif not endMap[k] then
                endMap[k] = curMap[k]
            end
        end
    end
    xx.arrayPush(self.stepList, TweenStep(self, true, properties, time, playback, ease, onPlayback, onUpdate))
    return self
end
---添加缓动属性值步骤
---@type fun(properties:table<string,number>,time:number,playback:boolean|nil,ease:Ease|nil,onPlayback:Callback|nil,onUpdate:Callback|nil):Tween
---@param properties table<string,number> 键值对，支持 number[] 值表表示贝塞尔缓动
---@param time number 缓动时长（单位：毫秒）
---@param playback boolean|nil 是否回播，默认 false
---@param ease Ease|nil 缓动函数，默认 nil 表示线性缓动
---@param onPlayback Callback|nil 回播时回调，默认 nil
---@param onUpdate Callback|nil 更新时回调，默认 nil
---@return Tween self
function Tween:by(properties, time, playback, ease, onPlayback, onUpdate)
    for _, target in ipairs(self.targets) do
        local curMap = self.curValueMap[target]
        local endMap = self.endValueMap[target]
        for k, v in pairs(properties) do
            if not curMap[k] then
                curMap[k] = target[k]
            end
            if not playback then
                if xx.isTable(v) then
                    v = v[xx.arrayCount(v)]
                end
                endMap[k] = (endMap[k] or curMap[k]) + v
            elseif not endMap[k] then
                endMap[k] = curMap[k]
            end
        end
    end
    xx.arrayPush(self.stepList, TweenStep(self, false, properties, time, playback, ease, onPlayback, onUpdate))
    return self
end
---添加设置属性值步骤
---@type fun(properties:table<string,number>):Tween
---@param properties table<string,number> 键值对，支持 number[] 值表表示贝塞尔缓动
---@return Tween self
function Tween:setTo(properties)
    for _, target in ipairs(self.targets) do
        local curMap = self.curValueMap[target]
        local endMap = self.endValueMap[target]
        for k, v in pairs(properties) do
            if not curMap[k] then
                curMap[k] = target[k]
            end
            endMap[k] = v
        end
    end
    xx.arrayPush(self.stepList, TweenSetStep(self, true, properties))
    return self
end
---添加设置属性值步骤
---@type fun(properties:table<string,number>):Tween
---@param properties table<string,number> 键值对，支持 number[] 值表表示贝塞尔缓动
---@return Tween self
function Tween:setBy(properties)
    for _, target in ipairs(self.targets) do
        local curMap = self.curValueMap[target]
        local endMap = self.endValueMap[target]
        for k, v in pairs(properties) do
            if not curMap[k] then
                curMap[k] = target[k]
            end
            endMap[k] = (endMap[k] or curMap[k]) + v
        end
    end
    xx.arrayPush(self.stepList, TweenSetStep(self, false, properties))
    return self
end
---添加设置速率步骤
---@type fun(rate:number|nil):Tween
---@param rate number|nil 速率
---@return Tween self
function Tween:rateTo(rate)
    xx.arrayPush(self.stepList, TweenRateStep(self, true, rate))
    return self
end
---添加设置速率步骤
---@type fun(rate:number|nil):Tween
---@param rate number|nil 速率
---@return Tween self
function Tween:rateBy(rate)
    xx.arrayPush(self.stepList, TweenRateStep(self, false, rate))
    return self
end
---添加睡眠步骤
---@type fun(time:number):Tween
---@param time number 睡眠时长（单位：毫秒）
---@return Tween self
function Tween:sleep(time)
    xx.arrayPush(self.stepList, TweenSleepStep(self, time))
    return self
end
---添加帧步骤
---@type fun(count:number):Tween
---@param count number 帧数（触发后开始计数）
---@return Tween self
function Tween:frame(count)
    xx.arrayPush(self.stepList, TweenFrameStep(self, count))
    return self
end
---添加循环步骤
---@type fun(count:number|nil,preCount:number|nil,onOnce:Callback|nil):Tween
---@param count number|nil 循环次数（触发后开始计数），默认 0 表示无限循环
---@param preCount number|nil 循环之前的步骤数量，默认 0 表示循环之前所有步骤
---@param onOnce Callback|nil 单次执行时回调
---@return Tween self
function Tween:loop(count, preCount, onOnce)
    xx.arrayPush(self.stepList, TweenLoopStep(self, count, preCount, onOnce))
    return self
end
---添加回调步骤
---@type fun(callback:Callback):Tween
---@param callback Callback 回调
---@return Tween self
function Tween:callback(callback)
    xx.arrayPush(self.stepList, TweenCallbackStep(self, callback))
    return self
end
---缓动模块
---@class MTween:Module by wx771720@outlook.com 2019-10-25 15:37:39
---@field _isPaused boolean 是否已暂停定时器模块
---@field _tweenList Tween[] 缓动器列表
---@field _uidTweenMap table<string,Tween> uid - 缓动器
---@field _targetUIDsMap table<any,string[]> 对象 - 缓动器 uid 列表
local MTween = xx.Class("xx.MTween", xx.Module)
---构造函数
function MTween:ctor()
    self._isPaused = false
    self._tweenList = {}
    self._uidTweenMap = {}
    self._targetUIDsMap = {}
    self._noticeHandlerMap[GIdentifiers.nb_timer] = self.onAppTimer
    self._noticeHandlerMap[GIdentifiers.nb_pause] = self.onAppPause
    self._noticeHandlerMap[GIdentifiers.nb_resume] = self.onAppResume
    self._noticeHandlerMap[GIdentifiers.ni_tween_new] = self.onNew
    self._noticeHandlerMap[GIdentifiers.ni_tween_stop] = self.onStop
end
---帧循环
---@type fun(result:NoticeResult,interval:number)
---@param result NoticeResult 直接返回结果
---@param interval number 帧间隔（单位：毫秒）
function MTween:onAppTimer(result, interval)
    if self._isPaused or interval >= 1000 then
        return
    end
    local uids
    for index = xx.arrayCount(self._tweenList), 1, -1 do
        local tween = self._tweenList[index]
        if xx.arrayCount(tween.stopList) > 0 then
            for _, stop in ipairs(tween.stopList) do
                tween.trigger = tween.trigger or stop.trigger
                local map = tween.endValueMap[stop.target]
                xx.arrayRemove(tween.targets, stop.target)
                tween.curValueMap[stop.target] = nil
                tween.endValueMap[stop.target] = nil
                uids = self._targetUIDsMap[stop.target]
                if 1 == xx.arrayCount(uids) then
                    self._targetUIDsMap[stop.target] = nil
                else
                    xx.arrayRemove(uids, tween.uid)
                end
                if stop.toEnd then
                    for k, v in pairs(map) do
                        stop.target[k] = v
                    end
                end
            end
            xx.arrayContains(tween.stopList)
            tween.isStopped = tween.isStopped or 0 == xx.arrayCount(tween.targets)
        end
        repeat
            if tween.isStopped then
                xx.arrayRemoveAt(self._tweenList, index)
                self._uidTweenMap[tween.uid] = nil
                for _, target in ipairs(tween.targets) do
                    uids = self._targetUIDsMap[target]
                    if 1 == xx.arrayCount(uids) then
                        self._targetUIDsMap[target] = nil
                    else
                        xx.arrayRemove(uids, tween.uid)
                    end
                    if tween.toEnd then
                        local map = tween.endValueMap[target]
                        for k, v in pairs(map) do
                            target[k] = v
                        end
                    end
                end
                if tween.trigger then
                    tween:resolve()
                else
                    tween:cancel()
                end
                break
            end
            if tween.isPaused then
                break
            end
            local time = interval * tween.rate
            if time < 0 then
                break
            end
            while self._uidTweenMap[tween.uid] and time > 0 and not tween.isCompleted do
                time = tween.stepList[tween.stepIndex]:update(time)
            end
            if tween.isCompleted then
                xx.arrayRemoveAt(self._tweenList, index)
                self._uidTweenMap[tween.uid] = nil
                for _, target in ipairs(tween.targets) do
                    uids = self._targetUIDsMap[target]
                    if 1 == xx.arrayCount(target) then
                        self._targetUIDsMap[target] = nil
                    else
                        xx.arrayRemove(uids, tween.uid)
                    end
                end
                tween:resolve()
            end
        until true
    end
end
---@param result NoticeResult 直接返回结果
function MTween:onAppPause(result)
    self._isPaused = true
end
---@param result NoticeResult 直接返回结果
function MTween:onAppResume(result)
    self._isPaused = false
end
---@param result NoticeResult 直接返回结果
---@vararg any
function MTween:onNew(result, ...)
    local tween = Tween(...)
    xx.arrayPush(self._tweenList, tween)
    self._uidTweenMap[tween.uid] = tween
    for _, target in ipairs(tween.targets) do
        if self._targetUIDsMap[target] then
            xx.arrayPush(self._targetUIDsMap[target], tween.uid)
        else
            self._targetUIDsMap[target] = {tween.uid}
        end
    end
    result.data = tween
end
---停止对象缓动
---@param result NoticeResult 直接返回结果
---@param target any 对象
---@param trigger boolean 是否在停止时触发回调
---@param toEnd boolean 是否在停止时设置属性为结束值
function MTween:onStop(result, target, trigger, toEnd)
    if self._targetUIDsMap[target] then
        local uids = self._targetUIDsMap[target]
        for _, uid in ipairs(uids) do
            self._uidTweenMap[uid]:stop(trigger, toEnd, target)
        end
    end
end
---缓动对象列表
---@type fun(...:any):Tween
---@vararg any
---@return Tween
function xx.tween(...)
    return xx.notify(GIdentifiers.ni_tween_new, ...)
end
---停止对象缓动
---@type fun(target:any,trigger:boolean|nil,toEnd:boolean|nil)
---@param target any 缓动对象
---@param trigger boolean 是否在停止时触发回调，默认 false
---@param toEnd boolean 是否在停止时设置属性为结束值，默认 false
function xx.tweenStop(target, trigger, toEnd)
    xx.notify(GIdentifiers.ni_tween_stop, target, trigger, toEnd)
end
xx.getInstance("xx.MTween")
---启动模块
---@class MLauncher:Module by wx771720@outlook.com 2019-10-12 16:42:43
local MLauncher = xx.Class("xx.MLauncher", xx.Module)
---构造函数
function MLauncher:ctor()
    self._noticeHandlerMap[GIdentifiers.nb_lauch] = self.onLaunch
end
---@param result NoticeResult
---@param root GameObject
function MLauncher:onLaunch(result)
    ---@type Root
    xx.root = xx.Root(xx.Util.GetRootCVS(), xx.Util.GetRootGO())
    xx.addInstance(xx.root)
end
xx.getInstance("xx.MLauncher")
---资源加载模块
---@class MLoad:Module by wx771720@outlook.com 2019-12-19 17:57:42
local MLoad = xx.Class("xx.MLoad", xx.Module)
---构造函数
function MLoad:ctor()
    self._noticeHandlerMap[GIdentifiers.ni_load] = self.onLoad
    self._noticeHandlerMap[GIdentifiers.ni_load_stop] = self.onStop
end
---@param result NoticeResult
---@param url string 资源地址
---@param type string 资源类型
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@param onRetry Callback 重试时回调
---@param onComplete Callback 加载完成后回调，参数：string|byte[]|null
function MLoad:onLoad(result, url, type, tryCount, tryDelay, timeout, onRetry, onComplete)
    result.data =
        xx.Util.Load(
        url,
        function(...)
            if onComplete then
                onComplete(...)
            end
        end,
        function(...)
            if onRetry then
                onRetry(...)
            end
        end,
        type,
        tryCount or 0,
        tryDelay or 1000,
        timeout or 0
    )
end
---@param result NoticeResult
---@param id string 加载 id
function MLoad:onStop(result, id)
    xx.Util.LoadStop(id)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,type:nil|string,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param type string 资源类型
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.load(url, onComplete, onRetry, type, tryCount, tryDelay, timeout)
    xx.notify(
        GIdentifiers.ni_load,
        url,
        type,
        tryCount,
        tryDelay,
        timeout,
        xx.Callback(onRetry),
        xx.Callback(onComplete)
    )
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadBinary(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_binary, tryCount, tryDelay, timeout)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadString(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_string, tryCount, tryDelay, timeout)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadTexture(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_texture, tryCount, tryDelay, timeout)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadSprite(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_sprite, tryCount, tryDelay, timeout)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadAudio(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_audioclip, tryCount, tryDelay, timeout)
end
---加载资源
---@type fun(url:string,onComplete:nil|Handler,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):string
---@param url string 资源地址
---@param onComplete Handler 加载完成后回调，参数：string|byte[]|null
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return string 返回加载 id
function xx.loadAssetBundle(url, onComplete, onRetry, tryCount, tryDelay, timeout)
    xx.load(url, onComplete, onRetry, GIdentifiers.load_type_assetbundle, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,type:nil|string,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param type string 资源类型
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadAsync(url, onRetry, type, tryCount, tryDelay, timeout)
    local promise = xx.Promise()
    return promise, xx.load(
        url,
        function(...)
            promise:resolve(...)
        end,
        onRetry,
        type,
        tryCount,
        tryDelay,
        timeout
    )
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadBinaryAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_binary, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadStringAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_string, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadTextureAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_texture, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadSpriteAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_sprite, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadAudioAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_audioclip, tryCount, tryDelay, timeout)
end
---异步加载资源
---@type fun(url:string,onRetry:nil|Handler,tryCount:nil|number,tryDelay:nil|number,timeout:nil|number):Promise
---@param url string 资源地址
---@param onRetry Handler 重试时回调
---@param tryCount number 加载超时后的重试次数，小于 0 表示无限次数，等于 0 表示不重试
---@param tryDelay number 加载超时后重试间隔时长（单位：毫秒）
---@param timeout number 加载超时时长（单位：毫秒）
---@return Promise 异步对象
function xx.loadAssetBundleAsync(url, onRetry, tryCount, tryDelay, timeout)
    return xx.loadAsync(url, onRetry, GIdentifiers.load_type_assetbundle, tryCount, tryDelay, timeout)
end
---停止加载资源
---@type fun(id:string)
---@param id string 加载 id
function xx.loadStop(id)
    xx.notify(GIdentifiers.ni_load_stop, id)
end
xx.getInstance("xx.MLoad")
