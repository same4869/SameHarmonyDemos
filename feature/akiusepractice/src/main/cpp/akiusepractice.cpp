//
// Created on 2024/6/9.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

/**
 * 实现步骤：
 * 1.使用AKI的JSBIND_ADDON注册OpenHarmony Native插件。
 * 2.使用AKI的JSBIND_GLOBAL注册FFI特性。在JSBIND_GLOBAL作用域下使用AKI的JSBIND_FUNCTION绑定C++全局函数AkiThreadsCallJs。
 * 3.在AkiThreadsCallJs中创建子线程，子线程中使用aki::JSBind::GetJSFunction获取指定JavaScript函数akiAccumulate的句柄后，使用Invoke触发调用JS函数。
 */

#include <aki/jsbind.h>

//  定义C++函数AkiThreadsCallJs。从native主线程中创建子线程subThread调用JavaScript函数。
void AkiThreadsCallJs(int value){
       // 创建子线程subThread
    std::thread subThread([=](){
        // TODO：知识点：使用aki::JSBind::GetJSFunction获取指定JavaScript函数句柄后，使用Invoke触发调用。这里获取JS侧定义的函数akiAccumulate。
        if (auto func = aki::JSBind::GetJSFunction("akiAccumulate")) {
            // 定义一个函数对象callback，该函数对象接受一个整数参数并返回void。
            std::function<void(int)> callback = [](int value) {};
            // 调用JavaScript函数，Invoke<T>指定返回值类型。
            func->Invoke<void>(value, callback);
        }
    });
    // 将子线程subThread从主线程中分离出来,独立运行。
    subThread.detach();
    return;
}

// TODO：知识点：使用JSBIND_ADDON注册OpenHarmony Native插件，可从JavaScript import导入插件。注册AKI插件名:即为编译*.so名称，规则与NAPI一致。这里注册AKI插件名为:aki_use_practice
JSBIND_ADDON(aki_use_practice)

// TODO：知识点：使用JSBIND_GLOBAL注册FFI特性。用于圈定需要绑定的全局函数作用域。
JSBIND_GLOBAL() {
    // 在JSBIND_GLOBAL作用域下使用JSBIND_FUNCTION绑定C++全局函数后，可从JavaScript直接调用。
    JSBIND_FUNCTION(AkiThreadsCallJs);
}