//
//  ArgoDataBindingCBridge.m
//  ArgoUI
//
//  Created by Dongpeng Dai on 2020/8/28.
//

#import "ArgoDataBindingCBridge.h"
#import "NSObject+MLNUIKVO.h"
#import "MLNUITableView.h"
#import "MLNUIExtScope.h"
#import "MLNUIKit.h"
#import "ArgoDataBinding.h"
#import "ArgoDataBindingProtocol.h"
#import "NSObject+MLNUIReflect.h"

#import "ArgoLuaObserver.h"
#import "ArgoListenerProtocol.h"
#import "ArgoObservableArray.h"
#import "ArgoObservableMap.h"
#import "ArgoObserverHelper.h"


@implementation ArgoDataBindingCBridge

NS_INLINE id _argo_data_for_keypath(MLNUILuaCore *luaCore,NSString *keyPath) {
    if(!keyPath) return nil;
    UIViewController<ArgoDataBindingProtocol> *kitViewController = (UIViewController<ArgoDataBindingProtocol> *)MLNUI_KIT_INSTANCE(luaCore).viewController;
    NSObject *obj = [kitViewController.argo_dataBinding argo_get:keyPath];
    return obj;
}

NS_INLINE ArgoDataBinding * _argo_get_dataBinding(MLNUILuaCore *luaCore) {
    UIViewController<ArgoDataBindingProtocol> *kitViewController = (UIViewController<ArgoDataBindingProtocol> *)MLNUI_KIT_INSTANCE(luaCore).viewController;
    return kitViewController.argo_dataBinding;
}

NS_INLINE void _argo_on_error_log(MLNUILuaCore *luaCore,NSString *log) {
#if DEBUG
    NSLog(@"%@",log);
    MLNUIError(luaCore, @"%@",log);
#endif
}

#pragma mark - Bridge

static int argo_get (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    NSString *nKey = [luaCore toString:-1 error:NULL];
    NSObject *obj = _argo_data_for_keypath(luaCore, nKey);
    //TODO: 优化，使用lua table
    NSObject *convertedObj = [obj mlnui_convertToLuaObject];
    int nret = [luaCore pushNativeObject:convertedObj error:NULL];
    PCallDBEnd(__func__);
    TOCK("argo_get key %s",nKey.UTF8String);
    return nret;
}

static int argo_update (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    //TODO: 使用lua table
    id value = [luaCore toNativeObject:-1 error:NULL];
    value = [value mlnui_convertToNativeObject];
    [dataBind argo_updateValue:value forKeyPath:nKey];
    PCallDBEnd(__func__);
    TOCK("argo_update key %s",nKey.UTF8String);
    return 1;
}

static int argo_watch(lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    MLNUIBlock *handler = [luaCore toNativeObject:-1 error:NULL];
    
    NSInteger obid = [dataBind argo_watchKeyPath:nKey withHandler:handler];
    lua_pushnumber(L, obid);
    PCallDBEnd(__func__);
    TOCK("argo_watch key %s",nKey.UTF8String);
    return 1;
}

static int argo_unwatch(lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSInteger obid = lua_tonumber(L, -1);
    [dataBind argo_unwatch:obid];
    
    PCallDBEnd(__func__);
    TOCK("argo_unwatch key %s",nKey.UTF8String);
    return 1;
}

static int argo_mock (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    NSDictionary *dic = [luaCore toNativeObject:-1 error:NULL];
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        NSString *log = [NSString stringWithFormat:@"data %@ should be kindOf NSDictionary",dic.class];
        _argo_on_error_log(luaCore, log);
        return 1;
    }
    id<ArgoListenerProtocol> map = [dic mlnui_convertToNativeObject];
    [dataBind bindData:map forKey:nKey];
    PCallDBEnd(__func__);
    TOCK("argo_mock key %s",nKey.UTF8String);
    return 1;
}

static int argo_mock_array (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSString *nKey = [luaCore toString:-3 error:NULL];
    
    ArgoObservableArray *existData = [dataBind argo_get:nKey];
    if ([existData isKindOfClass:[ArgoObservableArray class]]) {
//        [existData mlnui_startKVOIfMutable];
        PCallDBEnd(__func__);
        TOCK("argo_mockArray key %s",nKey.UTF8String);
        return 1;
    }
    
    NSArray *data = [luaCore toNativeObject:-2 error:NULL];
    if (![data isKindOfClass:[NSArray class]]) {
        NSString *log = [NSString stringWithFormat:@"data %@ should be kindOf NSArray",data.class];
        _argo_on_error_log(luaCore, log);
        return 1;
    }
    ArgoObservableArray *array = [data mlnui_convertToNativeObject];
//    [array mlnui_startKVOIfMutable];
//    [dataBind bindArray:array forKey:nKey];
    [dataBind bindData:array forKey:nKey];
    PCallDBEnd(__func__);
    TOCK("argo_mockArray key %s",nKey.UTF8String);
    return 1;
}

static int argo_insert (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    
    id value = [luaCore toNativeObject:-1 error:NULL];
    int index = lua_tonumber(L, -2);
    NSString *nKey = [luaCore toString:-3 error:NULL];

    ArgoObservableArray *arr = _argo_data_for_keypath(luaCore, nKey);
    if ([arr isKindOfClass:[ArgoObservableArray class]]) {
        NSObject *newValue = [value mlnui_convertToNativeObject];
        if(!newValue) return 1;
        
        if (index == -1) {
            [arr addObject:newValue];
            return 1;
        }
        index--;
        if (index >= 0 &&  index <= arr.count) {
            [arr insertObject:newValue atIndex:index];
            return 1;
        } else {
            NSString *log = [NSString stringWithFormat:@"index %d illeage, should match range of array [1, %zd]",index+1,arr.count];
            _argo_on_error_log(luaCore, log);
        }
    } else {
        NSString *log = [NSString stringWithFormat:@"type of object is %@, is not ArgoObserableArray",arr.class];
        _argo_on_error_log(luaCore, log);
    }
    
    PCallDBEnd(__func__);
    TOCK("luaui_insert key %s",nKey.UTF8String);
    return 1;
}

static int argo_remove (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    int index = lua_tonumber(L, -1);
    
    ArgoObservableArray *arr = _argo_data_for_keypath(luaCore, nKey);
    if ([arr isKindOfClass:[ArgoObservableArray class]]) {
        if (index == -1) {
            [arr removeLastObject];
            PCallDBEnd(__func__);
            TOCK("argo_remove key %s",nKey.UTF8String);
            return 1;
        }
        index--;
        if (index >= 0 && index < arr.count) {
            [arr removeObjectAtIndex:index];
        } else {
            NSString *log = [NSString stringWithFormat:@"index %d illeage, should match range of array [1, %zd]",index+1,arr.count];
            _argo_on_error_log(luaCore, log);
        }
    } else {
        NSString *log = [NSString stringWithFormat:@"type of object is %@, is not ArgoObservableArray",arr.class];
        _argo_on_error_log(luaCore, log);
    }
    PCallDBEnd(__func__);
    TOCK("argo_remove key %s",nKey.UTF8String);
    return 1;
}

static int argo_array_size (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    NSString *nKey = [luaCore toString:-1 error:NULL];
    NSArray *arr = _argo_data_for_keypath(luaCore, nKey);
    
    if (![arr isKindOfClass: [NSArray  class]]) {
        NSString *log = [NSString stringWithFormat:@"%@ is not NSArray",nKey];
        _argo_on_error_log(luaCore, log);
        return 1;
    }
    
    lua_pushinteger(L, arr.count);
    PCallDBEnd(__func__);
    TOCK("argo_array_size key %s",nKey.UTF8String);
    return 1;
}

static int argo_bind_listview (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    UIView *listView = [luaCore toNativeObject:-1 error:NULL];
    [dataBind argo_bindListView:listView forTag:nKey];
    PCallDBEnd(__func__);
    TOCK("luaui_bindListView key %s",nKey.UTF8String);
    return 1;
}

static int argo_section_count (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    NSString *nKey = [luaCore toString:-1 error:NULL];
    NSArray *arr = _argo_data_for_keypath(luaCore, nKey);
    NSUInteger count = 1;
    if ([ArgoObserverHelper arrayIs2D:arr]) {
        count = arr.count;
    }
    lua_pushinteger(L, count);
    PCallDBEnd(__func__);
    TOCK("argo_getSectionCount key %s",nKey.UTF8String);
    return 1;
}

static int argo_row_count (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    NSString *nKey = [luaCore toString:-2 error:NULL];
    int section = lua_tonumber(L, -1);
    NSUInteger count = 0;
    
    NSArray *arr = _argo_data_for_keypath(luaCore, nKey);
    if (section > arr.count || section == 0) {
        count = 0;
    } else if([ArgoObserverHelper arrayIs2D:arr]){
        NSArray *subArr = [arr mlnui_objectAtIndex:section - 1];
        count = [subArr count];
    } else if (section == 1) {
        count = arr.count;
    }
    lua_pushinteger(L, count);
    PCallDBEnd(__func__);
    TOCK("argo_getRowCount key %s",nKey.UTF8String);
    return 1;
}

static int argo_bind_cell (lua_State *L) {
    PCallDBStart(__func__);
    TICK();
    
    MLNUILuaCore *luaCore = MLNUI_LUA_CORE(L);
    ArgoDataBinding *dataBind = _argo_get_dataBinding(luaCore);
    UIViewController<MLNUIDataBindingProtocol> *kitViewController = (UIViewController<MLNUIDataBindingProtocol> *)MLNUI_KIT_INSTANCE(luaCore).viewController;

    NSString *nKey = [luaCore toString:-4 error:NULL];
    NSUInteger section = lua_tonumber(L, -3);
    NSUInteger row = lua_tonumber(L, -2);
    NSArray *paths = [luaCore toNativeObject:-1 error:NULL];
    if (paths.count == 0) {
        return 1;
    }
    [dataBind argo_bindCellWithController:kitViewController KeyPath:nKey section:section row:row paths:paths];
    PCallDBEnd(__func__);
    TOCK("argo_bindCell key %s section %zd row %zd",nKey.UTF8String, section, row);
    return 1;
}

static int test_nop(lua_State *L) {
    return 1;
}

LUAUI_NEW_EXPORT_GLOBAL_FUNC_BEGIN(ArgoDataBindingCBridge)

LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(get, argo_get, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(update, argo_update, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(watch, argo_watch, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(removeObserver, argo_unwatch, ArgoDataBindingCBridge)

LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(mock, argo_mock, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(mockArray, argo_mock_array, ArgoDataBindingCBridge)

LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(insert, argo_insert, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(remove, argo_remove, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(arraySize, argo_array_size, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(bindListView, argo_bind_listview, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(getSectionCount, argo_section_count, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(getRowCount, argo_row_count, ArgoDataBindingCBridge)
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(bindCell, argo_bind_cell, ArgoDataBindingCBridge)

//
//LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(getCellData, luaui_get_cell_data, ArgoDataBindingCBridge)
//
#ifdef DEBUG
LUAUI_NEW_EXPORT_GLOBAL_C_FUNC(test_nop, test_nop, ArgoDataBindingCBridge)
#endif

LUAUI_NEW_EXPORT_GLOBAL_FUNC_WITH_NAME_END(ArgoDataBindingCBridge, DataBinding, NULL)

@end