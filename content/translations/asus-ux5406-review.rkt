#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["华硕灵耀 14 Air（Zenbook S14，LNL）Linux 使用评测" "2025-05-02" #:lang "zh"]{
    @para{
      为了应付接下来的课程作业，我打算挑选一台尽量接近 MacBook Mx Air 的笔记本电脑——轻薄、低功耗、长续航，唯一的要求就是不能是苹果设备@cite["asus-ux5406-1"]@cite["asus-ux5406-2"]@cite["asus-ux5406-3"]。单论芯片，目前最接近的选择是英特尔的
      @link["https://www.pcworld.com/article/2463714/tested-intels-lunar-lake-wants-you-to-forget-snapdragon-ever-existed.html"]{Lunar Lake 处理器}，只可惜由于英特尔
      @link["https://medium.com/@mingchikuo/inside-intels-lunar-lake-a-promise-that-became-a-problem-e91d872cee62"]{管理层的无能}，这款芯片将后继无人。在所有搭载 Lunar Lake（LNL）的笔记本中，
      @link["https://www.notebookcheck.net/Asus-Zenbook-S-14-UX5406-laptop-review-Excellent-everyday-laptop-with-Intel-Lunar-Lake.892978.0.html"]{华硕灵耀 14 Air（ASUS Zenbook S14）}似乎做工顶尖、价格合理，而且不像联想的同级别产品 Yoga 那样对 Linux 极不友好@cite["asus-ux5406-4"]。
    }
    @para{
      根据@link["https://github.com/dantmnf/zenbook-s14-linux"]{一个 GitHub 仓库}（后文还会提到）的信息，Linux 6.12.5 及以上版本的内核已经能够很好地支持 LNL，这对于我用的 OpenSUSE TW 来说自然不在话下。整机基本上开箱即用，对安全启动（Secure Boot）和 TPM2.0 的支持也很完善，只是音频方面需要安装 @code{sof-firmware} 才能发声。令人惊喜的是，NPU 的驱动 @code{intel_vpu} 也顺利加载了。英特尔宣传它拥有
      @link["https://www.intel.com/content/www/us/en/products/sku/240957/intel-core-ultra-7-processor-258v-12m-cache-up-to-4-80-ghz/specifications.html"]{47 TOPS}
      的算力，不过我还没测试过；我本来很想在预装的 Windows 里体验一下这块 NPU，但因为 Copilot 强制要求登录微软账户，最后还是作罢了。
    }
    @para{
      电池续航确实如宣传般出色。写下这篇博客时，我的使用状态恰好就是这台笔记本预期的日常工作流：前台开着挂载了几个轻量插件的 Emacs，系统自带的 Mozilla Firefox 加载了大约 20 个网页（不含重度流媒体）；后台挂着 syncthing 守护进程、Mozilla Thunderbird、LibreOffice Writer 和 Akregator；桌面环境是未经特殊定制的 KDE。在剩余电量 70%、屏幕亮度 20%、电源模式设为 @code{powersave} 的情况下，系统预估的剩余续航时间长达 8 小时。如果日常只需处理轻度办公或轻量级开发，完全可以不带充电器出门。机器的发热控制也相当宜人，在 25°C 的室温下，CPU 温度始终保持在 40°C 以下，机身表面几乎感觉不到任何热量。
    }
    @para{
      不过它也确实有些小毛病。首先是 KDE 似乎认不出我的显卡：明明实际上已经调用了 GPU，系统信息里却一直显示正在使用 @code{llvmpipe}。这个问题通过安装 @code{intel-vaapi-driver} 修正了显示信息。第二个反直觉的地方是 @code{intel_gpu_top} 不支持这种 @code{xe} 架构的 GPU。这倒也容易解决，用 @code{nvtop} 就能很好地平替。
    }
    @para{
      最后一个问题颇为棘手，花了我整整三天时间才排查出原因。这台笔记本会不定期变卡，除非重启否则无法恢复。此时运行 @code{cpupower frequency-info} 会发现 CPU 的频率策略被莫名其妙地限制到了最高 400MHz，而且切换调频器（governor）也毫无作用。我一度怀疑是触发了 @code{BD_PROCHOT}，甚至怀疑机器里的某个传感器坏了，但用 @code{rdmsr} 检查却没有发现任何异常。为此我跑去 OpenSUSE 论坛、Tom's Hardware 论坛甚至 Reddit 发帖求助，最终才由@link["https://github.com/dantmnf/zenbook-s14-linux/issues/11#issuecomment-2846600130"]{前文提到的那个仓库里遇到的一位老兄}解开了谜团。症结似乎在于 @code{powertop} 与主板固件的交互存在某种冲突，哪怕我只用它的监控功能，也会随机触发最大频率限制。停用 @code{powertop} 之后，这个问题就再也没有出现过。
    }
    @para{
      目前大概就是这些。总体而言，我对这台机器相当满意，认为它已经非常接近 MacBook M1 Air 的体验了。
    }
  })

(provide post)