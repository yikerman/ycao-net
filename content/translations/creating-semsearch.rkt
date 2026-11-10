#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["为 6,000 个个人博客构建搜索引擎" "2026-08-03" #:lang "zh"]{
    @para{
      省流：Semsearch 是一个基于向量嵌入（embedding）的搜索引擎，初始语料取自 indieblog.page 的博客列表，旨在让独立博客更容易被发现。搜索结果仅按语义相关性排序，不看链接权重或 SEO 信号。截至撰稿时，在线实例已部署在 @link["https://semsearch.blog"]{@bold{semsearch.blog}}，收录了@link["https://archive.today/2026.07.29-180627/https://semsearch.blog/status"]{大约 6,000 个独立博客站点、15.4 万个页面以及 14 亿个词元（token）}。源代码托管在 @link["https://github.com/yikerman/semantic-search"]{github.com/yikerman/semantic-search}。
    }
    @heading["motivation"]{动机}
    @para{
      这个项目的想法源于我读到的《@link["https://danielstanica.com/posts/Great-Blogging-Collapse"]{博客大崩溃（The Great Blogging Collapse）}》一文（@link["https://news.ycombinator.com/item?id=48758802"]{HN 讨论}）。虽然文章本身有几处问题，但其核心观点还是让我作为一名博主深感共鸣：推广小众和个人博客的渠道越来越少了。过去，许多访问都始于 Google 的引流。但正如《@it{博客大崩溃}》所言，出于种种原因，Google 的引流正日渐减少，比如 AI 摘要的兴起就彻底截断了流向其他网站的访问。
    }
    @para{
      这也与其他观察一致：由于 Google 排名靠前的结果塞满了广告和做过 SEO 的内容农场，@link["https://dkb.blog/p/google-search-is-dying"]{大家（包括我）现在更喜欢在 Reddit 上搜索}。举个例子，在 Google 上搜索老生常谈的 @link["https://www.google.com/search?q=postgres+vs+mysql"]{Postgres vs MySQL} 之争，返回的大多是 AWS 和 IBM 那些没什么用的文章。（有意思的是，撰稿时 Google 似乎调高了 Reddit 的权重，把它排在了前几名。）
    }
    @img["/files/20260730/google-search1.png"]{在 Google 搜索 PostgreSQL vs MySQL}
    @para{
      尽管这场争论基本已有定论，但这本是个绝佳的场景，适合展示某位经验丰富的老工程师在生产环境中使用这两款数据库的体会——哪怕他的网页排版比 @link["https://motherfuckingwebsite.com/"]{@it{The Motherfucking Website}} 还要丑。
    }
    @para{
      近来的嵌入模型让按语义而非精确关键词搜索（后者同样需要不少技巧才能奏效）变得切实可行，向量数据库也证明了自己实用且易用。现有的向量检索系统大多用来为智能体（agentic）大语言模型提供检索能力，而我想探索一下，能否用纯粹的向量检索来帮大家发现独立博客。
    }
    @heading["method"]{实现}
    @para{
      Web 应用使用了 FastAPI，数据库则用了 @link["https://hub.docker.com/r/tensorchord/vchord-suite"]{Postgres + VectorChord}。博客列表的初始数据取自 @link["https://indieblog.page/faq#data"]{indieblog.page 的博客列表}。对于通过 RSS 订阅源或网站地图（sitemap）发现的每个页面，我用 @link["https://github.com/adbar/trafilatura"]{Trafilatura} 提取正文，再将其切分为有重叠的文本块（chunk），每块 384 个词元。嵌入模型我选择了 @link["https://huggingface.co/Qwen/Qwen3-Embedding-4B"]{Qwen3-Embedding-4B}，因为撰稿时它在 @link["http://archive.today/2026.08.01-143048/https://mteb-leaderboard.hf.space/models/Qwen/Qwen3-Embedding-4B"]{MTEB 排行榜}上位列榜首，开源且运行成本相对较低。每个文本块在数据库中都存为 2,560 维的半精度向量（halfvec）。
    }
    @para{
      查询时，Semsearch 会将查询词嵌入一次，然后运行指定的检索器（retriever）。默认只启用稠密检索器（dense retriever），计算查询向量与文本块向量之间的余弦相似度，并返回前 64 条结果。此外还有一个可选的 BM25@cite["robertsonProbabilisticRelevance2009"] 检索器，既可用于评估，也可通过倒数排序融合（RRF，Reciprocal Rank Fusion）@cite["cormackReciprocalRankFusion2009"]来合并结果（Anthropic 声称混合检索的效果更好@cite["anthropicContextualRetrieval2026"]）。详情可参阅@link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/search/pipeline.py#L60"]{搜索流水线}以及@link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/db.py#L198"]{挑大梁的 SQL 代码}。
    }
    @heading["deploy"]{部署}
    @para{
      部署起来有点棘手，因为在当前规模下，加载 @link["https://github.com/pgvector/pgvector#hnsw"]{HNSW 索引}需要占用大约 30 GB 内存，而 VPS 的价格会随内存容量大幅上涨。作为参考，AWS 上的 @code{r6a.xlarge} 实例每小时要 0.252 美元。最后我从 Hetzner 的服务器拍卖区淘了一台 i7-6700 独服，月付 55 欧元。按现在的标准来看这颗 CPU 确实很烂，但它配有 64 GB 内存和两块 512 GB NVMe 固态硬盘，在如今这个内存天价（RAMageddon）的时代绝对算得上白菜价了。
    }
    @para{
      我通过 @link["https://openrouter.ai/qwen/qwen3-embedding-4b"]{OpenRouter 的 API} 来运行嵌入模型，因为价格还算便宜，只要 0.02 美元/百万词元。为目前的语料库建索引一共只花了 28.60 美元，还算不错。不过延迟和吞吐量不太理想：我在 OpenRouter 上大约只能跑出 6,000 词元/秒的速度，这成了初始索引构建阶段的瓶颈。
    }
    @heading["eval"]{评估}
    @para{
      那么搜索效果究竟如何呢？回到@link["https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{前面那个 Postgres vs MySQL 的查询}（@link["http://archive.today/2026.08.03-083542/https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{存档}），结果喜忧参半，介于有用、有趣和胡言乱语之间。
    }
    @ul{
      @item{@link["https://dnitza.com/bookmarks/299536c3ab8e69e071f50d4a81f4df925d3779ff"]{第一条结果}是个挺逗的例子，虽有偏差但也不算翻车。它是一条缓存的 Hacker News 评论（Nitsikopoulos，你为什么要在博客上把你收藏的所有内容都缓存下来？），原帖讲的是一家公司从 MongoDB 迁移到 PostgreSQL。这条评论对比了大规模运维 Postgres 和 MySQL 的体验（尽管原帖本身确实是在讲 MongoDB），这就解释了为什么它的相似度得分这么高。搜索确实奏效了，也提供了深刻的见解，但在某些情况下，这种展示方式可能会让用户摸不着头脑。}
      @item{@link["https://flaviocopes.com/postgres-vs-mysql/"]{第二}和@link["https://zaiste.net/databases/vs/postgresql-mysql/"]{第三条}结果确实非常相关，但内容单薄，质量平平。}
      @item{@link["https://www.taskboy.com/2002-08-06-Postgres_Ahoy_.html"]{第四条结果}是一篇 2002 年的老博文，正是我想看到的那种有趣内容。它足够冷门，基于第一手经验，里面很多技术建议如今都已成了历史。}
      @item{@link["https://binaryigor.com/mysql-and-postgresql-different-approaches.html"]{第五条结果}总体来说可能是最扎实的回答：Roztropiński 对两者做了详尽的对比，深入探讨了它们的存储模型，还附上了一些基准测试代码。}
    }
    @para{
      摸索了一番后，我发现如果把查询词写成博主可能会在文章里写下的观点，或者用类似句子的长查询，搜出来的结果会更有启发性。下面是我试过的一些比较有趣的例子：
    }
    @ul{
      @item{搜索 @link["https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{what homelab brings to a people}（@link["http://archive.today/2026.08.03-114624/https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{存档}）会出来一些关于 Nicole 那套配置过剩的家庭实验室（homelab）的趣闻，不过也混杂了一些低质内容农场。}
      @item{搜索 @link["https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{the camera I kept for years}（@link["http://archive.today/2026.08.03-115240/https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{存档}）让我认识了 Henry 的佳能 PowerShot A510，还看到了用它拍出的精美照片。}
      @item{搜索 @link["https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{working remotely made me lonely}（@link["http://archive.today/2026.08.03-115755/https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{存档}）时，我原本以为会搜出一些新冠疫情期间的博客，没想到排在最前面的却是 Jasdev Singh 写于 2015 年的文章。}
      @item{搜索 @link["https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{why you should use Linux Desktop}（@link["http://archive.today/2026.08.03-121229/https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{存档}）会返回一大堆好用的链接，方便你发给朋友，忽悠他们入坑 Linux。当然还少不了这个必搜项：@link["https://semsearch.blog/?q=Windows+11+sucks&lang=en"]{Windows 11 sucks}。}
    }
    @para{
      总而言之，这个搜索确实管用，时不时还能展现互联网更具人情味的一面。不出所料，结果的质量高度依赖于语料库本身，搜索算法只能反映相关性。前端界面有时会让人困惑，因为它只显示文章标题和前几行字，用户点进原文后可能很难再次定位到匹配的文本块。
    }
    @heading["limit"]{局限与未来工作}
    @para{
      目前这还只是一个早期的概念验证（proof of concept），存在一些怪毛病。一个明显的问题是，嵌入模型对略微不规范的表述不够稳健。例如，搜索 @link["https://semsearch.blog/?q=framework+laptop+review&lang=en"]{"framework laptop review"}（@link["http://archive.today/2026.08.03-121718/https://semsearch.blog/?q=framework+laptop+review&lang=en"]{存档}）会返回一堆不知所云的结果，而正确大写的 @link["https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{"Framework Laptop review"}（@link["http://archive.today/2026.08.03-122117/https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{存档}）就能搜出相关内容。如前所述，如果在搜索结果中直接展示匹配的文本块，体验也会好很多；此外，引入某种社区投票机制或许有助于过滤低质内容（尽管这也会带来其他问题）。
    }
    @para{
      我打算搭一个家庭实验室，弄一张 3090 显卡来做自托管（self-hosting）并开展进一步实验，具体包括：
    }
    @ul{
      @item{构建一个标准化的评估数据集，用来测试以下方案。}
      @item{测试更多分块（chunking）策略，比如延迟分块法（late chunking）@cite["michaelLateChunking2025"]。}
      @item{测试其他嵌入模型，解决上面提到的怪毛病。}
      @item{收录更多博客！一个潜在的数据源是 @link["https://github.com/kagisearch/smallweb"]{Kagi Small Web}。}
    }
  })

(provide post)