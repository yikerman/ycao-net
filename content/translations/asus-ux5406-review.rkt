#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Linux 下 ASUS Zenbook S14 笔记本（LNL）评测" "2025-05-02" #:lang "zh"]{
    @para{
      为了接下来的课程，我想挑一台尽可能接近 Macbook Mx Air 的笔记本——轻、功耗低、续航长，唯一区别在于不是 Apple 设备@cite["asus-ux5406-1"]@cite["asus-ux5406-2"]@cite["asus-ux5406-3"]。芯片方面，我能找到最接近的是 Intel 的
      @link["https://www.pcworld.com/article/2463714/tested-intels-lunar-lake-wants-you-to-forget-snapdragon-ever-existed.html"]{Lunar Lake CPU}
      ；可惜由于 Intel 的
      @link["https://medium.com/@mingchikuo/inside-intels-lunar-lake-a-promise-that-became-a-problem-e91d872cee62"]{管理层无能}
      ，其继任产品不会继续开发。在所有 LNL 笔记本里，
      @link["https://www.notebookcheck.net/Asus-Zenbook-S-14-UX5406-laptop-review-Excellent-everyday-laptop-with-Intel-Lunar-Lake.892978.0.html"]{ASUS Zenbook S14}
      似乎质量最好、价格合理，也不像联想的 Yoga 那样排斥 Linux@cite["asus-ux5406-4"]。
    }
    @para{
      根据 @link["https://github.com/dantmnf/zenbook-s14-linux"]{一个 GitHub 仓库}
      （这个仓库后面还会提到），LNL 在 Linux 6.12.5+ 上支持良好，我的 OpenSUSE TW 不成问题。它基本开箱即用，安全启动和 TPM2.0 支持都很好，只是音频要装 @code{sof-firmware} 才能工作。意外的是，NPU 卡已经加载了驱动
      @code{intel_vpu}。我还没测过它；Intel 宣传它有
      @link["https://www.intel.com/content/www/us/en/products/sku/240957/intel-core-ultra-7-processor-258v-12m-cache-up-to-4-80-ghz/specifications.html"]{47 TOPS}。
      我本来很想在预装 Windows 里试试 NPU，但 copilot 强迫我登录 Microsoft 账户后就放弃了。
    }
    @para{
      续航和宣传的一样好。写这篇帖子时——这恰好也是我用这台笔记本预期的工作流——我在用 Emacs，装了一些无关紧要的包；内置的 Mozilla Firefox 开了约 20 个页面（没有大型媒体内容）；后台跑着一个 syncthing 守护进程、一个 Mozilla Thunderbird、一个 Libreoffice Writer 和一个 Akregator；桌面是 KDE，没有特别定制。电量 70%、屏幕亮度 20%、电源配置设为
      @code{powersave} 时，预估续航达到 8 小时。如果你的工作只涉及轻度办公或轻度开发，可以指望一天不用充电器。笔记本也相当凉快，室温 25C 下 CPU 不到 40C。机身上几乎感觉不到热。
    }
    @para{
      不过它确实有些怪毛病。第一个是 KDE 似乎不认我的显卡。它一直说我在用 @code{llvmpipe}，实际上却在用 GPU。安装
      @code{intel-vaapi-driver} 后这个信息就正常了。第二个反直觉的地方是
      @code{intel_gpu_top} 在这类 @code{xe} GPU 上不能用。这个容易解决，@code{nvtop} 就是不错的替代品。
    }
    @para{
      最后一个问题不简单，我花了三天才找到原因。笔记本偶尔会变慢，直到我重启；
      @code{cpupower frequency-info} 显示 CPU 频率策略被随机限制到最高只有 400MHz，改 governor 也毫无帮助。我怀疑是 @code{BD_PROCHOT}，甚至怀疑笔记本里的传感器有故障，但 @code{rdmsr} 没有显示任何错误迹象。我在 OpenSUSE 论坛、Tom's Hardware 论坛甚至 Reddit 上求助。问题最终
      @link["https://github.com/dantmnf/zenbook-s14-linux/issues/11#issuecomment-2846600130"]{由在前面提到的仓库里遇到的一个人}
      澄清。看起来 @code{powertop} 和固件之间有些可疑的交互，会随机限制最高频率，哪怕我只用它的监视功能。停用 @code{powertop} 后这个问题再没出现过。
    }
    @para{
      目前就这些。总体来说，我对这台机器相当满意，认为它很接近 Macbook M1 Air。
    }
  })

(provide post)