#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Review on ASUS Zenbook S14 Laptop (LNL) with Linux" "2025-05-02"]{
    @para{
      I am trying to pick a laptop that is as close to Macbook Mx Airs as
      possible - light, low power consumption and long battery life, with the
      only exception of not being an Apple
      device@cite["asus-ux5406-1"]@cite["asus-ux5406-2"]@cite["asus-ux5406-3"] -
      for the upcoming coursework. As for the chip itself, the closest I can get
      is Intel's
      @link["https://www.pcworld.com/article/2463714/tested-intels-lunar-lake-wants-you-to-forget-snapdragon-ever-existed.html"]{Lunar Lake CPUs}
      whose successor unfortunatelly Intel will not develop due to their
      @link["https://medium.com/@mingchikuo/inside-intels-lunar-lake-a-promise-that-became-a-problem-e91d872cee62"]{management incompetentness}.
      Among all LNL laptops, it seems that
      @link["https://www.notebookcheck.net/Asus-Zenbook-S-14-UX5406-laptop-review-Excellent-everyday-laptop-with-Intel-Lunar-Lake.892978.0.html"]{ASUS Zenbook S14}
      is of top quality, has a reasonable price and does not repulse Linux like
      Lenovo's counterpart Yoga@cite["asus-ux5406-4"].
    }
    @para{
      According to @link["https://github.com/dantmnf/zenbook-s14-linux"]{a GitHub repo}
      (more on this repo later), LNL is well-supported on Linux 6.12.5+, which is
      not a problem on my OpenSUSE TW. It mostly works out of the box, has nice
      secure boot and TPM2.0 support, with the need to install @code{sof-firmware}
      for the audio to work. Surprisingly, the NPU card has its driver
      @code{intel_vpu} loaded. I've yet to test it, which Intel promotes as having
      @link["https://www.intel.com/content/www/us/en/products/sku/240957/intel-core-ultra-7-processor-258v-12m-cache-up-to-4-80-ghz/specifications.html"]{47 TOPS};
      I was really tempted to try out the NPU in the pre-installed Windows but
      gave up when copilot forced me to login my Microsoft Account.
    }
    @para{
      The battery life is as good as it promoted. As the writing of this post,
      which happens to be my expected workflow with this laptop, I am working on
      my Emacs with some trivial packages and the built-in Mozilla Firefox with
      about 20 pages loaded (no heavy media); in the background there is a
      syncthing daemon running, a Mozilla Thunderbird, a Libreoffice Writer and an
      Akregator; my desktop is KDE and has no special customization. Under a
      battery of 70%, screen brightness 20% and power profile set to
      @code{powersave}, the estimated battery life reaches 8 hours. Expect a
      charger-free day when your job only involves light office-work or light
      development. The laptop is also quite pleasantly chilly, whose CPU sits
      under 40C in the room temperature of 25C. One can barely feel any heat on
      the chasis.
    }
    @para{
      It does have some quirks, though, with the first being KDE seemingly not
      recognizing my graphics card. It kept telling me it's using @code{llvmpipe}
      while actually utilizing the GPU. The information is fixed by installing
      @code{intel-vaapi-driver}. The second counter-intuitive point is that
      @code{intel_gpu_top} doesn't work on such @code{xe} GPUs. It's an easy fix
      as @code{nvtop} is a nice replacement to it.
    }
    @para{
      The last issue was not trivial and took me three days to find the cause.
      The laptop occasionally slowed down until I reboot and
      @code{cpupower frequency-info} showed me that CPU frequency policy was
      randomly throttled to only 400MHz max and changing the governer had zero
      help. I suspected on @code{BD_PROCHOT}, even a faulty sensor in my laptop,
      but @code{rdmsr} showed no signs of error. I asked for help on OpenSUSE
      forum, Tom's Hardware forum and even Reddit. The issue is eventually
      clarified
      @link["https://github.com/dantmnf/zenbook-s14-linux/issues/11#issuecomment-2846600130"]{by a dude met in the previously mentioned repo}.
      It seems that @code{powertop} has some iffy interaction with the firmware
      and randomly throttles max frequency even if I only use the monitor part of
      it. The issue has never occured after stopping using @code{powertop}.
    }
    @para{
      That's all for now, and I'm overall pretty satisfied with this machine and
      consider it a pretty close approximation of the Macbook M1 Air.
    }
  })

(provide post)
