#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["华硕 Zenbook S14 笔记本（LNL）Linux 使用评测" "2025-05-02" #:lang "zh"]{
    @para{
      为了接下来的课程作业，我正在挑一台尽可能接近 MacBook Mx Air 的笔记本：轻、功耗低、续航长，唯一的例外是它不是 Apple 设备@cite["asus-ux5406-1"]@cite["asus-ux5406-2"]@cite["asus-ux5406-3"]。
      至于芯片本身，我能找到最接近的是 Intel 的
      @link["https://www.pcworld.com/article/2463714/tested-intels-lunar-lake-wants-you-to-forget-snapdragon-ever-existed.html"]{Lunar Lake 处理器}；
      遗憾的是，Intel 不会开发它的后继产品，因为其
      @link["https://medium.com/@mingchikuo/inside-intels-lunar-lake-a-promise-that-became-a-problem-e91d872cee62"]{管理层无能}。
      在所有 LNL 笔记本中，
      @link["https://www.notebookcheck.net/Asus-Zenbook-S-14-UX5406-laptop-review-Excellent-everyday-laptop-with-Intel-Lunar-Lake.892978.0.html"]{华硕 Zenbook S14}
      似乎品质最好、价格合理，也不像联想的同类产品 Yoga@cite["asus-ux5406-4"] 那样排斥 Linux。
    }
    @para{
      根据 @link["https://github.com/dantmnf/zenbook-s14-linux"]{一个 GitHub 仓库}
      （这个仓库后面还会提到），LNL 在 Linux 6.12.5+ 上支持良好，这在我的 OpenSUSE TW 上不是问题。它基本开箱即用，Secure Boot 和 TPM2.0 支持不错，只是音频要安装 @code{sof-firmware} 才能工作。意外的是，NPU 卡已经加载了驱动 @code{intel_vpu}。我还没测试过它；Intel 宣传它有
      @link["https://www.intel.com/content/www/us/en/products/sku/240957/intel-core-ultra-7-processor-258v-12m-cache-up-to-4-80-ghz/specifications.html"]{47 TOPS}。
      我本来很想在预装的 Windows 里试试 NPU，但 Copilot 强迫我登录 Microsoft 账户后，我就放弃了。
    }
    @para{
      续航和宣传的一样好。写这篇文章时——这恰好是我预期在这台笔记本上的工作方式——我正在用 Emacs，装了一些简单的小包，自带的 Mozilla Firefox 开了约 20 个页面（没有大型媒体内容）；后台跑着 Syncthing 守护进程、Mozilla Thunderbird、LibreOffice Writer 和 Akregator；桌面是 KDE，没有特别定制。在电量 70%、屏幕亮度 20%、电源配置设为 @code{powersave} 的情况下，预估续航达到 8 小时。如果你的工作只涉及轻量办公或轻量开发，可以指望一整天不用充电。这台笔记本还凉快得很舒服：室温 25°C 时 CPU 不到 40°C，机身上几乎感觉不到热量。
    }
    @para{
      不过它确实有些小毛病。第一个是 KDE 似乎认不出我的显卡：它一直告诉我正在用 @code{llvmpipe}，实际上却在用 GPU。安装 @code{intel-vaapi-driver} 后这个显示信息就正常了。第二个反直觉的地方是 @code{intel_gpu_top} 在这类 @code{xe} GPU 上不能用；这很好解决，@code{nvtop} 是个不错的替代品。
    }
    @para{
      最后一个问题不简单，我花了三天才找到原因。笔记本偶尔会变慢，直到重启才恢复；@code{cpupower frequency-info} 显示 CPU 频率策略被随机限制到最高只有 400MHz，改 governor 也毫无帮助。我怀疑过 @code{BD_PROCHOT}，甚至怀疑笔记本里有传感器坏了，但 @code{rdmsr} 没有显示任何错误迹象。我在 OpenSUSE 论坛、Tom's Hardware 论坛甚至 Reddit 上求助。最终，@link["https://github.com/dantmnf/zenbook-s14-linux/issues/11#issuecomment-2846600130"]{在前述仓库里遇到的一位网友} 把问题解释清楚了。似乎 @code{powertop} 和固件之间有些说不清的相互作用，即使我只用它的监控部分，它也会随机限制最高频率。停用 @code{powertop} 后，这个问题再没出现过。
    }
    @para{
      目前就这些。总的来说，我对这台机器相当满意，认为它很接近 MacBook M1 Air。
    }
  })

(provide post)