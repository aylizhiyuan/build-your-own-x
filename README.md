# 0️⃣从零构建你热爱的技术

😈希望你在阅读的时候是充满热情的,因为这跟我此时的心情😄一样,我们永远都想理解那些我们生活中发生的事情和使用的东西,我们希望能够改进🔨它,熟练的使用它,甚至超越大部分的人,而我们惧怕的仅仅是开始的勇气和先做个垃圾出来的决心,我希望我们对待技术,就像对待大多数事情一样,在这些构建中体会到快乐,充实以及内心的充盈,永远不要认为从0️⃣开始很痛苦

## 🔥2025年值得关注热点项目


## 🚀2025年那些值得尝试的IDEA

### 1. 🕷[推特爬虫](https://github.com/aylizhiyuan/twitter-crawler)

**- 仓库地址:** https://github.com/aylizhiyuan/twitter-crawler

**- 技术栈:** `PlayWright` + `NodeJS`

**- 实现思路:** 利用无头浏览器爬取Twitter数据,并返回数据交于LLM分析后,TG推送,实时监控推特舆情,监控内容包括新闻、项目上线、空投、链上地址、KOL

**- Why:** 那我为什么做这个呢?其实就是我每天都会做的一件事儿,我每天都会阅读大量KOL的Twitter,所以我觉得应该有很多人都会从中找到开盘项目或者新闻,那么,不知不觉中,这个项目花费了我大概3个月左右的时间开发,可以说这个项目的难点非常的多,仅仅是爬虫这块就困难重重,Twitter的数据是非常难以抓取得,无论是状态判断还是数据展示都有非常多的问题,其中又涉及到定时任务的问题,同时为了更好的解决问题,还要涉及到日志问题,当时大多数的服务器是不太支持爬虫的,所以,为了找到更好的爬虫服务器,也是跟服务商沟通了很久才最终找到.这还仅仅是爬虫方面的,从运维到开发部署,我都是独立设计和完成的,TG的机器人和调用LLM模型也是踩了很多的坑才得以顺利的接入,通过前期对于数据处理的要求和测试,成功的将产品上线了.上线后,很自然的,项目在冷启动阶段就已经失败了,这个耗费了我巨大心血的项目还没开始就结束了

### 2. ⭐️[JS运行时](https://github.com/aylizhiyuan/zero-js-runtime)

**- 仓库地址:** https://github.com/aylizhiyuan/zero-js-runtime 

**- 技术栈:** `QuickJS` `libuv`

**- 实现思路:** QuickJS实现对同步代码的解析执行,异步async/await/promise/timer交给libuv事件队列处理即可

**- 意义:** 我觉得这个项目才是真正让我理解异步了,所以,它的意义就是从底层的角度让我理解了什么是异步以及异步是如何实现的,而不是简单看几篇文章理解的,因为之前我就有libuv的源码的经验,所以,加上简单的组合以后,我很快窥见了JS-Runtime的真正面纱


## 🎉系统调用


### 操作系统视角下的程序

```

高级语言代码（Python/JavaScript/...）
    ↓
高级语言解释器（CPython / V8 / JVM ...）
    ↓
解释器内部的 C/C++ 代码
    ↓
C 语言库（glibc、musl）/ C++标准库
    ↓
系统调用（syscall）
    ↓
操作系统内核（Linux/Windows/...）
```

所以,实际你能做的就是将这些系统调用利用起来,但是你通常不必知道他们的实现,甚至高级语言提供了更上一层的封装,既然这样,我们就可以知道我们能做什么,我们做的事情的范畴在哪儿,以及我们通过这些调用我们可以实现哪些...



### 系统调用示例

```c
#include <syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
int main(void) {
    /*-----------------------------*/
    /* direct system call */
    /* SYS_getpid (func no. is 20) */
    /*-----------------------------*/
    ID1 = syscall(SYS_getpid);
    printf ("syscall(SYS_getpid)=%ld\n", ID1);
    /*-----------------------------*/
    /* "libc" wrapped system call */
    /* SYS_getpid (Func No. is 20) */
    /*-----------------------------*/
    ID2 = getpid();
    printf ("getpid()=%ld\n", ID2);
    return(0);
}
```

### 系统调用速查表

|编号|函数名|作用|源代码位置
|:---|:---------|:--------------|:-------|
|1|exit|终止当前进程|kernel/exit.c|
|2|fork|创建一个子进程|arch/i386/kernel/process.c|
|3|read|从文件描述符读入|fs/read_write.c|
|4|write|写入到文件描述符|fs/read_write.c|
|5|open|打开文件或设备|fs/open.c|
|6|close|关闭一个文件描述符|fs/open.c|
|7|waitpid|等待进程结束|kernel/exit.c|
|8|creat|创建一个文件或设备（使用 “man 2 open”查看更多信息|fs/open.c|
|9|link|为文件创建一个新名字|fs/namei.c|
|10|unlink|删除掉文件的一个名字，可能删除掉这个名字指向的文件|fs/namei.c|
|11|execve|执行程序|arch/i386/kernel/process.c|
|12|chdir|改变工作目录|fs/open.c|
|13|time|获取以秒为单位的时间|kernel/time.c|
|14|mknod|创建一个特殊或者普通的文件|fs/namei.c|
|15|chmod|改变文件权限|fs/open.c|
|16|lchown|改变文件所有权|fs/open.c|
|17|stat|获得文件状态|fs/stat.c|
|18|lseek|修改 读/写 文件偏移量|fs/read_write.c|
|19|getpid|获得 pid|kernel/sched.c|
|20|mount|挂载文件系统|fs/super.c|
|21|umount|卸载文件系统|fs/super.c|
|22|setuid|设置实际用户ID|kernel/sys.c|
|23|getuid|获得实际用户ID|kernel/sched.c|
|24|stime|设置系统时间和日期|kernel/time.c|
|25|ptrace|允许父进程控制子进程的执行|arch/i386/kernel/ptrace.c|
|26|alarm|设置发送信号的闹钟|kernel/sched.c|
|27|fstat|获得文件状态|fs/stat.c|
|28|pause|在信号到来之前休眠进程|arch/i386/kernel/sys_i386.c|
|29|utime|设置文件访问和修改时间|fs/open.c|
|30|access|检查用户对文件的权限|fs/open.c|
|31|nice|改变进程优先级|kernel/sched.c|
|32|sync|更新超级块|fs/buffer.c|
|33|kill|想进程发送信号|kernel/signal.c|
|34|rename|改变文件的名字或位置|fs/namei.c|
|35|mkdir|创建一个目录|fs/namei.c|
|36|rmdir|删除一个目录|fs/namei.c|
|37|dup|复制一个打开的文件描述符|fs/fcntl.c|
|38|pipe|创建一个进程间的通道(管道)|arch/i386/kernel/sys_i386.c|
|39|times|获得进程时间|kernel/sys.c|
|40|brk|调整进程数据段空间的大小|mm/mmap.c|
|41|setgid|设置实际用户组ID|kernel/sys.c|
|42|getgid|获得实际用户组|kernel/sched.c|
|43|sys_signal|ANSI C 信号处理|kernel/signal.c|
|44|geteuid|获得有效用户ID|kernel/sched.c|
|45|getegid|获得有效用户组ID|kernel/sched.c|
|46|acct|启用或禁用进程记账|kernel/acct.c|
|47|umount2|卸载文件系统|fs/super.c|
|48|ioctl|控制设备|fs/ioctl.c|
|49|fcntl|文件控制|fs/fnctl.c|
|50|mpx|未实现| |
|51|setpgid|设置进程组 id|kernel/sys.c|
|52|ulimt|未实现| |
|53|olduname|淘汰的 uname 系统调用|arch/i386/kernel/sys_i386.c|
|54|umask|设置文件创建掩码|kernel/sys.c|
|55|chroot|改变根目录|fs/open.c|
|56|ustat|获得文件系统信息|fs/super.c|
|57|dup2|复制文件描述符|fs/fcntl.c|
|58|getppid|获得父进程 id|kernel/sched.c|
|59|getpgrp|获得进程组 id|kernel/sys.c|
|60|setsid|创建一个会话，设置进程组id|kernel/sys.c|
|61|sigaction|POSIX 信号处理函数|arch/i386/kernel/signal.c|
|62|sgetmask|ANSI C 信号处理函数|kernel/signal.c|
|63|ssetmask|ANSI C 信号处理|kernel/signal.c|
|64|setreuid|设置实际和有效用户 id|kernel/sys.c|
|65|setregid|设置实际和有效用户组 id|kernel/sys.c|
|66|sigsupend|设置信号掩码，挂起进程等待特定信号|arch/i386/kernel/signal.c|
|67|sigpending|检查阻塞或者等待的信号|kernel/signal.c|
|68|sethostname|设置主机名|kernel/sys.c|
|69|setrlimit|设置最大系统资源|kernel/sys.c|
|70|getrlimit|获得系统最大资源|kernel/sys.c|
|71|getrusage|获得系统资源使用情况|kernel/sys.c|
|72|gettimeodday|获得日期和时间|kernel/time.c|
|73|settimeofday|设置日期和时间|kernel/time.c|
|74|getgroups|获得后备组 id 列表|kernel/sys.c|
|75|setgroups|设置后备组 id 列表|kernel/sys.c|
|76|old_select|同步 I/O 多路复用|arch/i386/kernel/sys_i386.c|
|77|symlink|为一个文件创建符号链接|fs/namei.c|
|78|lstat|获得文件状态|fs/stat.c|
|79|readlink|读取符号链接的内容|fs/stat.c|
|80|uselib|选择共享库|fs/exec.c|
|81|swapon|启用文件或者设备的交换文件|mm/swapfile.c|
|82|reboot|重启或者启用/禁用 Ctrl-Alt-Del|kernel/sys.c|
|83|old_readdir|读取目录项|fs/readdir.c|
|84|old_mmap|映射内存页|arch/i386/kernel/sys_i386.c|
|85|munmap|取消映射内存页|mm/mmap.c|
|86|truncate|截断文件长度|fs/open.c|
|87|ftruncate|截断文件长度|fs/open.c|
|88|fchmod|改变文件的访问权限|fs/open.c|
|89|fchown|改变文件的所有者和所有组|fs/open.c|
|90|getpriority|获得程序调度优先级|kernel/sys.c|
|91|setpriority|设置程序调度优先级|kernel/sys.c|
|92|profil|进行时间分析| |
|93|statfs|获得文件系统信息|fs/open.c|
|94|fstatfs|获得文件系统信息|fs/open.c|
|95|ioperm|设置端口 i/o 权限|arch/i386/kernel/ioport.c|
|96|socketcall| socket 系统调用|net/socket.c|
|97|syslog|读取或/和清除内核信息环形缓冲区|kernel/printk.c|
|98|setitimer|设置内部定时器的值|kernel/itimer.c|
|99|getitimer|获得内部定时器的值|kernel/itimer.c|
|100|sys_newstat|获得文件状态|fs/stat.c|
|101|sys_newlstat|获得文件状态|fs/stat.c|
|102|sys_newfstat|获得文件状态|fs/stat.c|
|103|old_uname|获得当前内核的名字和信息|arch/i386/kernel/sys_i386.c|
|104|iopl|改变 I/O 特权等级|arch/i386/kernel/ioport.c|
|105|vhangup|挂起当前终端|fs/open.c|
|106|idle|创建进程 0 idle|arch/i386/kernel/process.c|
|107|vm86old|进入模拟 8086 模式|arch/i386/kernel/vm86.c|
|108|wait4|等待进程终止，BSD 风格|kernel/exit.c|
|109|swapoff|停用文件/设备的交换文件|mm/swapfile.c|
|110|sysinfo|返回全部的系统信息|kernel/info.c|
|111|ipc|Sytem V IPC 系统调用|arch/i386/kernel/sys_i386.c|
|112|fsync|把内存中的文件同步到磁盘上|fs/buffer.c|
|113|sigreturn|从信号处理函数返回，并且清理栈帧|arch/i386/kernel/signal.c|
|114|clone|创建子进程|arch/i386/kernel/process.c|
|115|setdomainname|设置域名|kernel/sys.c|
|116|uname|获得当前内核的名字和信息|kernel/sys.c|
|117|modify_ldt|获取或设置 ldt|arch/i386/kernel/ldt.c|
|118|adjtimex|调整内核时钟|kernel/time.c|
|119|mprotect|设置内存映像保护|mm/mprotect.c|
|120|sigprocmask|POSIX 信号处理函数|kernel/signal.c|
|121|create_module|创建一个可载入的模块项|kernel/module.c|
|122|init_module|初始化一个可载入的模块项|kernel/module.c|
|123|delete_module|删除一个可载入的模块项|kernel/module.c|
|124|get_kernel_syms|回复导出的内核模块符号|kernel/module.c|
|125|quotactl|维护磁盘配额|fs/dquot.c|
|126|getpgid|获得进程组 id|kernel/sys.c|
|127|fchdir|改变工作目录|fs/open.c|
|128|bdflush|启动,刷新,或调整缓冲区脏刷新为守护进程|fs/buffer.c|
|129|sysfs|获得文件系统类型信息|fs/super.c|
|130|personality|设置进程执行域|kernel/exec_domain.c|
|131|afs_syscall|(未实现)| |
|132|setfsuid|设置用来文件系统检查的用户 id|kernel/sys.c|
|133|setfsgid|设置用来文件系统检查的组 id|kernel/sys.c|
|134|sys_llseek|移动可扩展的读/写的文件指针|fs/read_write.c|
|135|getdents|读取目录项|fs/readdir.c|
|136|select|同步 I/O 多路复用|fs/select.c|
|137|flock|在一个打开的文件上添加或移除文件锁|fs/locks.c|
|138|msync|同步文件和内存映射|mm/filemap.c|
|139|readv|读取数据到多个缓冲区|fs/read_write.c|
|140|writev|将数据写到多个缓冲区|fs/read_write.c|
|141|sys_getsid|获得会话领导进程的组 id |kernel/sys.c|
|142|fdatasync|同步内核态文件到硬盘中|fs/buffer.c|
|143|sysctl|读/写系统变量|kernel/sysctl.c|
|144|mlock|对内存页上锁|mm/mlock.c|
|145|munlock|对内存页解锁|mm/mlock.c|
|146|mlockall|禁用调用进程的内存页面|mm/mlock.c|
|147|munlockall|重新启用调用进程的内存页面|mm/mlock.c|
|148|sched_setparam|设置调度变量|kernel/sched.c|
|149|sched_getparam|获得调度变量|kernel/sched.c|
|150|sched_setscheduler|设置调度算法变量|kernel/sched.c|
|151|sched_getscheduler|获得调度算法变量|kernel/sched.c|
|152|sched_yield|让出处理器|kernel/sched.c|
|153|sched_get_priority_max|获得最大的静态权限范围|kernel/sched.c|
|154|sched_get_priority_min|获得最小的静态权限范围|kernel/sched.c|
|155|sched_rr_get_interval|获得有名进程的 SCHEDRR interval |kernel/sched.c| 
|156|nanosleep|暂停执行指定的时间(纳秒单位)|kernel/sched.c|
|157|mremap|重新映射虚拟内存地址|mm/mremap.c|
|158|setresuid|设置实际、有效、设置用户/组 id|kernel/sys.c|
|159|getresuid|获得实际、有效、设置用户/组 id|kernel/sys.c|
|160|vm86|进入模拟 8086 模式 |arch/i386/kernel/vm86.c|
|161|query_module|查询内核的关于模块的各个位|kernel/module.c|
|162|poll|等待一个文件描述符上的某些事件|fs/select.c|
|163|nfsservctl|内核 nfs 后台的系统调用|fs/filesystems.c|
|164|setresgid|设置实际、有效、设置用户/组 id |kernel/sys.c|
|165|getresgid|设置实际、有效、设置用户/组 id|kernel/sys.c|
|166|prctl|对线程的操作|kernel/sys.c|
|167|rt_sigreturn| |arch/i386/kernel/signal.c|
|168|rt_sigaction| |kernel/signal.c|
|169|rt_sigprocmask| |kernel/signal.c|
|170|rt_sigpending| |kernel/signal.c|
|171|rt_sigtimedwait| |kernel/signal.c|
|172|rt_sigqueueinfo| |kernel/signal.c|
|173|rt_sigsuspend| |kernel/signal.c|
|174|pread|从文件描述符指定的偏移量开始读|fs/read_write.c|
|175|sys_pwrite|从文件描述符指定的偏移量开始写|fs/read_write.c|
|176|chown|改变文件所有权|fs/open.c|
|177|getcwd|获得当前工作目录|fs/dcache.c|
|178|capget|获得进程权限|kernel/capability.c|
|179|capset|设置进程权限|kernel/capability.c|
|180|sigaltstack|设置/获得信号栈内容|arch/i386/kernel/signal.c|
|181|sendfile|在文件描述符之间传输文件|mm/filemap.c|
|182|getpmsg|未实现||
|183|putpmsg|未实现||
|184|vfork|创建一个子进程，然后阻塞父进程|arch/i386/kernel/process.c|

总的来说,`系统调用`可以分为以下:

- **进程管理:** 用于创建、终止、控制和管理进程

- **文件系统:** 用于操作文件和目录

- **内存管理:** 用于管理进程的内存空间,通常只有底层语言暴漏

- **网络:** 网络通信

- **设备控制:** 用于控制硬件设备,通常只有底层语言暴露

- **时间管理:** 用于获取和设置系统时间

- **用户和组管理:**  用于管理用户和组的权限

- **进程间通信:** 用户进程之间的通信和同步


### 内核中的操作视角

内核代码的实现更像是直接与硬件层面进行操作了

```
应用程序 ---> 系统调用 ---> 内核程序 ---> 驱动程序 ---> 硬件
```







## 💐贡献

- ❓欢迎提交,发送PR或者创建问题
- 💻如果你有更好的Idea,或者你对我某个项目感兴趣,希望你能同我一起💰









