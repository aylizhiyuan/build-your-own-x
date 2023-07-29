# 从0开始实现js运行时

## 环境配置

确保安装了CMake / QuickJS / libuv

构建运行时:

```shell
cd build
cmake .. && make

```

启动运行时:

```shell
 ./runtime
```

## 异步的原理

非常的简单，先执行同步代码，然后剩下的异步代码注册到uv事件中去，通过驱动uv_loop来处理各种timer事件、promise事件等异步事件


```c

    // 包含同步和异步的代码的js文件
    const char *filename = "../src/test.js";
    buf = js_load_file(ctx, &buf_len, filename);

    uv_check_start(check, check_callback);
    uv_unref((uv_handle_t *) check);
    // 这段代码用于来执行js的同步代码
    eval_buf(ctx, buf, buf_len, filename, JS_EVAL_TYPE_MODULE);
    // 启动eventLoop来执行js的异步代码
    uv_run(loop, UV_RUN_DEFAULT);
    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);
    return 0;
```

1. timer事件

- 定义timer.c函数的逻辑,在我们的函数中，我们主要做的事情其实就是设置了一个timer的结构体(uv_timer)

```c
  ┌───────────────────────────┐
┌─>│           timers          │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │     pending callbacks     │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │       idle, prepare       │
│  └─────────────┬─────────────┘      ┌───────────────┐
│  ┌─────────────┴─────────────┐      │   incoming:   │
│  │           poll            │<─────┤  connections, │
│  └─────────────┬─────────────┘      │   data, etc.  │
│  ┌─────────────┴─────────────┐      └───────────────┘
│  │           check           │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
└──┤      close callbacks      │
   └───────────────────────────┘

#include <quickjs/quickjs-libc.h>
#include <uv.h>

#define countof(x) (sizeof(x) / sizeof((x)[0]))

typedef struct {
    JSContext *ctx;
    uv_timer_t handle;
    int interval;
    JSValue obj;
    JSValue func;
    int argc;
    JSValue argv[];
} UVTimer;

static JSClassID uv_timer_class_id;

static void clearTimer(UVTimer *th) {
    JSContext *ctx = th->ctx;

    JS_FreeValue(ctx, th->func);
    th->func = JS_UNDEFINED;

    for (int i = 0; i < th->argc; i++) {
        JS_FreeValue(ctx, th->argv[i]);
        th->argv[i] = JS_UNDEFINED;
    }
    th->argc = 0;

    JSValue obj = th->obj;
    th->obj = JS_UNDEFINED;
    JS_FreeValue(ctx, obj);
}

static void callTimer(UVTimer *th) {
    JSContext *ctx = th->ctx;
    JSValue ret, func1;
    /* 'func' might be destroyed when calling itself (if it frees the handler), so must take extra care */
    func1 = JS_DupValue(ctx, th->func);
    ret = JS_Call(ctx, func1, JS_UNDEFINED, th->argc, (JSValueConst *) th->argv);
    JS_FreeValue(ctx, func1);
    // FIXME
    // if (JS_IsException(ret))
    //     dump_error(ctx);
    JS_FreeValue(ctx, ret);
}

static void timerCallback(uv_timer_t *handle) {
    UVTimer *th = handle->data;
    JSContext *ctx = th->ctx;

    JSContext *ctx1;
    int err;

    for (;;) {
        err = JS_ExecutePendingJob(JS_GetRuntime(ctx), &ctx1);
        if (err <= 0) {
            if (err < 0)
                js_std_dump_error(ctx1);
            break;
        }
    }

    callTimer(th);
    if (!th->interval)
        clearTimer(th);
}

static JSValue js_uv_setTimeout(JSContext *ctx, JSValueConst this_val,
                                int argc, JSValueConst *argv) {
    int64_t delay;
    JSValueConst func;
    UVTimer *th;
    JSValue obj;

    func = argv[0];
    if (!JS_IsFunction(ctx, func))
        return JS_ThrowTypeError(ctx, "not a function");
    if (JS_ToInt64(ctx, &delay, argv[1]))
        return JS_EXCEPTION;

    obj = JS_NewObjectClass(ctx, uv_timer_class_id);
    if (JS_IsException(obj))
        return obj;

    int nargs = argc - 2;

    th = calloc(1, sizeof(*th) + nargs * sizeof(JSValue));
    if (!th) {
        JS_FreeValue(ctx, obj);
        return JS_EXCEPTION;
    }

    th->ctx = ctx;
    uv_loop_t *loop = JS_GetContextOpaque(ctx);
    uv_timer_init(loop, &th->handle);
    th->handle.data = th;
    th->interval = 0;
    th->obj = JS_DupValue(ctx, obj);
    th->func = JS_DupValue(ctx, func);
    th->argc = nargs;
    for (int i = 0; i < nargs; i++)
        th->argv[i] = JS_DupValue(ctx, argv[i + 2]);

    uv_timer_start(&th->handle, timerCallback, delay, 0);

    JS_SetOpaque(obj, th);
    return obj;
}

static const JSCFunctionListEntry js_os_funcs[] = {
    JS_CFUNC_DEF("setTimeout", 2, js_uv_setTimeout ),
};

static int js_uv_init(JSContext *ctx, JSModuleDef *m) {        
    return JS_SetModuleExportList(ctx, m, js_os_funcs,
                                  countof(js_os_funcs));
}

JSModuleDef *js_init_module_uv(JSContext *ctx, const char *module_name) {
    JSModuleDef *m;
    m = JS_NewCModule(ctx, module_name, js_uv_init);
    if (!m)
        return NULL;
    JS_AddModuleExportList(ctx, m, js_os_funcs, countof(js_os_funcs));
    return m;
}

```

- 在uv_run阶段将这个timer事件执行掉

- 在没有任何其余的任务的时候,uv_run结束



## Promise 的执行逻辑


promise的代码放在了timer的回调函数中（待确定,代表每一轮结束的时候执行对应的微任务？）

```c
static void timerCallback(uv_timer_t *handle) {
    UVTimer *th = handle->data;
    JSContext *ctx = th->ctx;

    JSContext *ctx1;
    int err;

    for (;;) {
        err = JS_ExecutePendingJob(JS_GetRuntime(ctx), &ctx1);
        if (err <= 0) {
            if (err < 0)
                js_std_dump_error(ctx1);
            break;
        }
    }

    callTimer(th);
    if (!th->interval)
        clearTimer(th);
}
```




