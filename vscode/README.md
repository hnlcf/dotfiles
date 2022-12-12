##  打造vim-like的vscode

本配置的目标为在vscode中通过更改快捷键达到类似vim的操作逻辑。

[视频介绍](https://www.bilibili.com/video/BV1s34y1Y79u?spm_id_from=333.999.0.0)

## 1. 依赖

本配置依赖：

1. vim插件

![image-20220609120843405](https://ravenxrz-blog.oss-cn-chengdu.aliyuncs.com/img/oss_img/image-20220609120843405.png)

2. multi-command插件

![image-20220609120904405](https://ravenxrz-blog.oss-cn-chengdu.aliyuncs.com/img/oss_img/image-20220609120904405.png)

3. which key插件

![image-20220609120937448](https://ravenxrz-blog.oss-cn-chengdu.aliyuncs.com/img/oss_img/image-20220609120937448.png)

## 2. 安装

配置包含三个文件：

1. [settings.json](https://github.com/ravenxrz/dotfiles/blob/master/vscode/settings.json)， 该文件为vscode的整体配置文件，将其中以 "vim." 开头的字段配置和 "whichkey."开头的字段配置粘贴到自己的 settings.json文件中。该文件中包含一部分的快捷键设置。
2. [keybindings.json](https://github.com/ravenxrz/dotfiles/blob/master/vscode/keybindings.json), 该文件包含大部分的快捷键设置。
3. [vsvimrc](https://github.com/ravenxrz/dotfiles/blob/master/vscode/vsvimrc), 该文件做了少量快捷键配置。

安装完后，配置 vim 插件的 vsvvimrc 路径选项为 vsvimrc 所在路径，重启vscode即可。

## 3. 快捷键说明

**注意：随着个人使用习惯的改变，快捷键可能会有所更改。**

### 1.文件目录 

| 快捷键        | 功能                  |
| ------------- | --------------------- |
| `<space>` + e | 开关目录树            |
| o             | 打开文件/打开文件目录 |
| h             | 折叠一个层级目录      |
| d             | 删除文件              |
| a             | 新建文件              |
| A             | 新建文件夹            |
| r             | 重命名文件            |
| j             | 下移动条目            |
| k             | 上移动条目            |

### 2. 常规动作

| 快捷键             | 功能                                                         |
| ------------------ | ------------------------------------------------------------ |
| `<space>` + o      | 开关大纲                                                     |
| `<space>` + f      | 搜索文件                                                     |
| `<space>` + F      | 搜索字符（输入要搜索的字符后，按tab可切换到搜索结果，shift+tab回到搜索框) |
| E                  | 打开左边标签页                                               |
| R                  | 打开右边标签页                                               |
| `<leader>` + q     | 关闭当前编辑文件                                             |
| `<leader>` + gq    | 关闭当前编辑组                                               |
| `<ctrl>` + h/j/k/l | 进入左边/下边/上边/右边窗口                                  |
| `<ctrl> + \`       | 开关终端                                                     |
| `<ctrl> + p`       | 开关panel                                                    |

### 3.代码导航

| 快捷键          | 功能                                                         |
| --------------- | ------------------------------------------------------------ |
| `<leader>` + t  | 在声明/定义间来回跳转 (c和cpp项目，需要导出compile_commands.json文件) |
| `<leader>` + u  | 查看代码引用(浮动窗)                                         |
| `<leader>` + U  | 查看代码引用（单独引用panel)                                 |
| `<leader>`+ in  | 函数调用链                                                   |
| `alt` + o       | c/c++ 切换源文件和头文件                                     |
| `]]`            | 跳转到下一个函数头                                           |
| `][`            | 跳转到下一个函数尾                                           |
| `[[`            | 跳转到上一个函数头                                           |
| `[]`            | 跳转到上一个函数尾                                           |
| gh              | 查看函数签名+注释文档                                        |
| `<leader>` + rn | 重命名符号                                                   |
| `<space>` + s   | 搜索当前窗口下的符号 (vscode的 `@`)                          |
| `<space>` + S   | 搜索项目下的符号 (vscode `#`)                                |

### 4. 代码诊断

| 快捷键          | 功能       |
| --------------- | ---------- |
| `<leader>` + dj | 下一个错误 |
| `<leader>`+ dk  | 上一个错误 |

### 5. Git操作

| 快捷键          | 功能         |
| --------------- | ------------ |
| `<leader>` + j  | 下一个hunk   |
| `<leader>` + k  | 上一个hunk   |
| `<leader>` + hs | stage hunk   |
| `<leader>` + hu | unstage hunk |
| `<leader>` + hr | reset hunk   |
| `<space>` + g   | 打开git tab  |

### 6. Debug

| 快捷键          | 功能         |
| --------------- | ------------ |
| `<leader>` + db | 开关断点     |
| `<F5>`          | 开始调试     |
| `<F4>`          | 结束调试会话 |
| `<F6>`          | stepover     |
| `<F7>`          | stepinto     |
| `<F8>`          | stepout      |


## 4. FAQ

**1. outline只能通过快捷键打开，无法关闭**

目前的配置outline 只能放在secondary side bar中才能自动关闭, 可自行调整outline的快捷键配置。
> hint: outline配置在 settings.json文件中， 搜索**outline**即可

## 5. 其他

- [neovim IDE配置](https://github.com/ravenxrz/dotfiles/tree/master/nvim)

