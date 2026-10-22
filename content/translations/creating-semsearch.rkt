#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["为 6,000 个个人博客搭建搜索引擎" "2026-08-03" #:lang "zh"]{
    @para{
      简而言之：Semsearch 是一个基于嵌入的搜索引擎，其语料库从 indieblog.page 的博客列表起步。它想让独立博客更容易被发现。结果只按语义相关性排序，不参考链接流行度，也不使用从 SEO 推导出的信号。撰写本文时，线上实例位于 @link["https://semsearch.blog"]{@bold{semsearch.blog}}，收录 @link["https://archive.today/2026.07.29-180627/https://semsearch.blog/status"]{约 6,000 个不同博客站点、15.4 万个页面和 14 亿个 token}。源代码在 @link["https://github.com/yikerman/semantic-search"]{github.com/yikerman/semantic-search}。
    }
    @heading["motivation"]{动机}
    @para{
      这个项目源于我读到 @link["https://danielstanica.com/posts/Great-Blogging-Collapse"]{《博客大崩溃》}
      （@link["https://news.ycombinator.com/item?id=48758802"]{HN 讨论}）。那篇文章本身有几个问题，但作为一个博主，它更宏观的观点引起了我的共鸣：推广小型博客和个人博客的渠道越来越少。过去，很多访问来自 Google 把用户引到你的博客。但正如 @it{《博客大崩溃》} 所示，由于各种原因，Google 越来越少这样做，比如 AI 摘要的兴起，让用户完全不必再访问其他网站。
    }
    @para{
      这也与其他来源一致：@link["https://dkb.blog/p/google-search-is-dying"]{人们（包括我）更愿意在 Reddit 上搜索}，因为 Google 的顶部结果被广告和靠 SEO 优化的内容农场塞满了。比如，用 Google 搜那场由来已久的 @link["https://www.google.com/search?q=postgres+vs+mysql"]{Postgres vs MySQL} 之争，返回的大多是 AWS 和 IBM 的文章，没什么用。（有意思的是，撰写本文时，Google 似乎提高了 Reddit 的排名，把它放进了顶部结果。）
    }
    @img["/files/20260730/google-search1.png"]{用 Google 搜索 PostgreSQL vs MySQL}
    @para{
      这场争论虽然大体上已经尘埃落定，但这本来是个绝佳场景，正该让某位老练的工程师写写自己在生产环境中使用两者的经验，哪怕他的网页比 @link["https://motherfuckingwebsite.com/"]{@it{The Motherfucking Website}} 还丑。
    }
    @para{
      近来的嵌入模型让按语义而不是精确关键词搜索变得可行（精确关键词搜索想有效，也得用上不少技巧），向量数据库也被证明既实用又好上手。现有的基于嵌入的搜索系统大多用来为智能体式 LLM 提供检索能力，而我想探索一种可能：只用基于嵌入的搜索来帮人们发现独立博客。
    }
    @heading["method"]{实现}
    @para{
      Web 应用我用了 FastAPI，数据库用了 @link["https://hub.docker.com/r/tensorchord/vchord-suite"]{Postgres + VectorChord}。博客集合取自 @link["https://indieblog.page/faq#data"]{indieblog.page 的博客列表}。对通过 RSS 源或站点地图发现的每个页面，我用 @link["https://github.com/adbar/trafilatura"]{Trafilatura} 提取文本内容，再切成有重叠的 384 token 片段。嵌入任务我选择 @link["https://huggingface.co/Qwen/Qwen3-Embedding-4B"]{Qwen3-Embedding-4B} 作为嵌入模型，因为撰写本文时它位居 @link["http://archive.today/2026.08.01-143048/https://mteb-leaderboard.hf.space/models/Qwen/Qwen3-Embedding-4B"]{MTEB 排行榜}榜首，开源，而且运行成本相对较低。每个片段都以 2,560 维 halfvec 存入数据库。
    }
    @para{
      查询时，Semsearch 先把查询嵌入一次，再运行指定的检索器。默认只用稠密检索器，它基于查询嵌入与片段嵌入之间的余弦相似度，返回前 64 条。另有一个可选的 BM25@cite["robertsonProbabilisticRelevance2009"]
      检索器，既用于评估，也用于通过 RRF@cite["cormackReciprocalRankFusion2009"] 合并结果
      （Anthropic 声称混合方案效果更好@cite["anthropicContextualRetrieval2026"]）。
      细节见 @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/search/pipeline.py#L60"]{搜索流水线}
      和 @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/db.py#L198"]{实际干重活的 SQL}。
    }
    @heading["deploy"]{部署}
    @para{
      部署有点麻烦，因为按当前规模，@link["https://github.com/pgvector/pgvector#hnsw"]{HNSW 索引}
      加载起来要占用约 30 GB 内存，而 VPS 成本又和内存密切相关。供参考，AWS 上的 @code{r6a.xlarge} 实例每小时 0.252 美元。我最后从 Hetzner 的服务器拍卖中弄到一台 i7-6700 独立服务器，每月 55 欧元。按现代标准，这 CPU 很差劲，但它带 64 GB 内存和 2 × 512 GB NVMe SSD，在“内存末日”时代简直是捡漏。
    }
    @para{
      我用 @link["https://openrouter.ai/qwen/qwen3-embedding-4b"]{OpenRouter 的 API} 来运行嵌入模型，因为这样相对便宜，每百万 token 0.02 美元。索引当前语料库只花了 28.60 美元，还不错。不过延迟和吞吐不太理想：在 OpenRouter 上我大约能跑到每秒 6,000 token，它成了最初索引过程的瓶颈。
    }
    @heading["eval"]{评估}
    @para{
      那么结果看起来如何？回到前面那个 @link["https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{Postgres vs MySQL 的查询}
      （@link["http://archive.today/2026.08.03-083542/https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{已存档}），结果有好有坏，介于有用、有趣和胡扯之间。
    }
    @ul{
      @item{@link["https://dnitza.com/bookmarks/299536c3ab8e69e071f50d4a81f4df925d3779ff"]{第一条结果}有点好笑，算不上失败。它是缓存下来的 Hacker News 评论（Nitsikopoulos，你为什么把自己收藏的所有内容都缓存到博客里？），来自一篇讲某公司从 MongoDB 迁移到 PostgreSQL 的帖子。这条评论比较的是大规模运维 Postgres 和 MySQL 的情况（而原帖本身确实在讲 MongoDB），这也解释了它为什么相似度得分很高。搜索确实有效，也能给出深入见解，但在某些情况下，这种呈现方式会让用户困惑。}
      @item{@link["https://flaviocopes.com/postgres-vs-mysql/"]{第二条}
        和 @link["https://zaiste.net/databases/vs/postgresql-mysql/"]{第三条}结果确实很相关，但内容单薄，质量平平。}
      @item{@link["https://www.taskboy.com/2002-08-06-Postgres_Ahoy_.html"]{第四条结果}
        是一篇 2002 年的老博文，正是我想看到的那种有趣内容。它冷门，基于第一手经验，其中的技术建议如今大多已成历史。}
      @item{@link["https://binaryigor.com/mysql-and-postgresql-different-approaches.html"]{第五条结果}
        大概是整体上最强的答案：Roztropiński 详细比较了两者，深入探讨了它们的存储模型，还附了一些基准测试代码。}
    }
    @para{
      我摆弄了一阵后发现，当查询写成博主可能会在文章里下的断言时，结果更有洞见；而像句子一样的长查询效果更好。我又试了几个有意思的例子：
    }
    @ul{
      @item{@link["https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{homelab 能给人带来什么}
      （@link["http://archive.today/2026.08.03-114624/https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{已存档}）
      会搜出一些关于 Nicole 那台性能过剩的 homelab 的趣事，也会带出一些低质量内容农场。}
      @item{@link["https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{我用了多年的那台相机}
      （@link["http://archive.today/2026.08.03-115240/https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{已存档}）
      让我认识了 Henry 的 Canon PowerShot A510，以及用它拍出的漂亮照片。}
      @item{搜 @link["https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{远程工作让我孤独}
      （@link["http://archive.today/2026.08.03-115755/https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{已存档}）时，
      我本以为会找到一些新冠时期的博客，却惊讶地发现排在最前的是 Jasdev Singh 2015 年写的内容。}
      @item{@link["https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{为什么你该用 Linux 桌面}
      （@link["http://archive.today/2026.08.03-121229/https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{已存档}）
      会返回一大堆方便发给朋友、引诱他们用 Linux 的链接。还有必不可少的：@link["https://semsearch.blog/?q=Windows+11+sucks&lang=en"]{Windows 11 烂透了}。}
    }
    @para{
      总而言之，这个搜索确实能用，而且时不时能呈现互联网更个人化的一面。不出所料，质量很大程度上取决于语料库，而搜索只能提示相关性。前端有时也会让人困惑，因为它只显示文章标题和开头几行，用户可能很难再回到原文里找到那个相关片段。
    }
    @heading["limit"]{局限与未来工作}
    @para{
      这仍然是个早期概念验证，存在一些怪毛病。一个明显的问题是，嵌入模型对稍微不标准的措辞不太稳健。比如，查询
      @link["https://semsearch.blog/?q=framework+laptop+review&lang=en"]{"framework laptop review"}
      （@link["http://archive.today/2026.08.03-121718/https://semsearch.blog/?q=framework+laptop+review&lang=en"]{已存档}）
      会返回一堆乱糟糟的结果，而大小写正确的查询
      @link["https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{"Framework Laptop review"}
      （@link["http://archive.today/2026.08.03-122117/https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{已存档}）
      就能返回相关结果。网站如果像前面说的那样，在搜索结果里显示相关片段，也会更好；某种社区投票机制或许有助于过滤低质量内容（不过也会带来别的问题）。
    }
    @para{
      我打算搭建一个 homelab，再弄一块 3090 用于自托管和进一步实验，具体来说：
    }
    @ul{
      @item{整理一套标准化的评估数据集，并拿下面这些方法在它上面测试。}
      @item{测试更多分块策略，比如 late chunking 方法@cite["michaelLateChunking2025"]。}
      @item{测试其他嵌入模型，并解决上面提到的怪毛病。}
      @item{更多博客！一个潜在来源是 @link["https://github.com/kagisearch/smallweb"]{Kagi Small Web}。}
    }
  })

(provide post)