#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["为 6,000 个个人博客构建搜索引擎" "2026-08-03" #:lang "zh"]{
    @para{
      简而言之：Semsearch 是一个基于嵌入的搜索引擎，其语料库从 indieblog.page 的博客列表起步。
      目标是让独立博客更容易被发现。结果仅按语义相关性排序，不考虑链接流行度或来自 SEO 的信号。
      撰写本文时，线上实例位于 @link["https://semsearch.blog"]{@bold{semsearch.blog}}，
      包含 @link["https://archive.today/2026.07.29-180627/https://semsearch.blog/status"]{约 6,000 个独立博客站点、15.4 万页面和 14 亿 token}。
      源代码位于 @link["https://github.com/yikerman/semantic-search"]{github.com/yikerman/semantic-search}。
    }
    @heading["motivation"]{动机}
    @para{
      这个项目的想法，源自我读到 @link["https://danielstanica.com/posts/Great-Blogging-Collapse"]{《博客大崩溃》}
      （@link["https://news.ycombinator.com/item?id=48758802"]{HN 讨论}）的时候。那篇文章本身有几个问题，
      但作为博主，我更认同它更宏观的观点：推广小型和个人博客的途径越来越少。过去，许多访问始于
      Google 把用户带到你的博客。但正如 @it{《博客大崩溃》} 所示，Google 这样做的次数越来越少，
      原因有很多，比如 AI 摘要的兴起，直接消除了对其他网站的访问。
    }
    @para{
      这与其它来源的说法一致：@link["https://dkb.blog/p/google-search-is-dying"]{人们（包括我）更愿意在 Reddit 上搜索}，
      因为 Google 的顶部结果被广告和 SEO 优化的内容农场塞满。例如，在 Google 上搜索当年的
      @link["https://www.google.com/search?q=postgres+vs+mysql"]{Postgres vs MySQL} 之争，
      返回的多数是 AWS 和 IBM 的文章，没什么用。（有意思的是，撰写本文时，Google 似乎已提升
      Reddit 的排名，把它放进了顶部结果。）
    }
    @img["/files/20260730/google-search1.png"]{Google 搜索 PostgreSQL vs MySQL}
    @para{
      虽然这场争论大体上已经平息，但这本该是展示某位经验丰富的老工程师写下自己在生产环境使用两者的经历的完美场景，
      哪怕他的网页比 @link["https://motherfuckingwebsite.com/"]{@it{The Motherfucking Website}} 还丑。
    }
    @para{
      最近的嵌入模型让按含义而非精确关键词搜索变得可行（后者要有效工作也需要不少技巧），向量数据库
      也被证明实用且易用。现有基于嵌入的搜索系统大多用来为智能体式 LLM 提供检索能力，而我想探索
      用纯基于嵌入的搜索帮助人们发现独立博客的可能性。
    }
    @heading["method"]{实现}
    @para{
      网页应用用 FastAPI，数据库用 @link["https://hub.docker.com/r/tensorchord/vchord-suite"]{Postgres + VectorChord}。
      博客集合来自 @link["https://indieblog.page/faq#data"]{indieblog.page 的博客列表}。
      对于通过 RSS feed 或 sitemap 发现的每个页面，我用 @link["https://github.com/adbar/trafilatura"]{Trafilatura}
      提取文本内容，然后切分成有重叠的 384 token 片段。嵌入任务我选择
      @link["https://huggingface.co/Qwen/Qwen3-Embedding-4B"]{Qwen3-Embedding-4B}
      作为嵌入模型，因为撰写本文时它位居 @link["http://archive.today/2026.08.01-143048/https://mteb-leaderboard.hf.space/models/Qwen/Qwen3-Embedding-4B"]{MTEB 排行榜}
      榜首，开源，运行成本也相对低。每个片段都以 2,560 维 halfvec 存进数据库。
    }
    @para{
      查询时，Semsearch 会把查询嵌入一次，然后运行指定的检索器。默认只用基于查询嵌入与片段嵌入
      余弦相似度的稠密检索器，返回前 64 条。还有一个可选的 BM25@cite["robertsonProbabilisticRelevance2009"]
      检索器，用于评估，也用于通过 RRF@cite["cormackReciprocalRankFusion2009"] 合并结果
      （Anthropic 声称混合方法效果更好@cite["anthropicContextualRetrieval2026"]）。细节见
      @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/search/pipeline.py#L60"]{搜索流水线}
      和 @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/db.py#L198"]{承担重任的 SQL}。
    }
    @heading["deploy"]{部署}
    @para{
      部署有点棘手，因为当前规模下 @link["https://github.com/pgvector/pgvector#hnsw"]{HNSW 索引}
      加载大约要占 30 GB 内存，而 VPS 成本又会随内存大幅上涨。作为参考，AWS 上 @code{r6a.xlarge}
      实例每小时 $0.252。我最后从 Hetzner 的服务器拍卖中拍了一台专用 i7-6700 机器，每月 €55。
      按现代标准，这 CPU 很烂，但它有 64 GB 内存和 2 × 512 GB NVMe SSD，在内存末日时代简直是白菜价。
    }
    @para{
      我用 @link["https://openrouter.ai/qwen/qwen3-embedding-4b"]{OpenRouter 的 API} 运行嵌入模型，
      因为它相对便宜，也就是每百万 token $0.02。索引当前语料库花了 $28.60，不算多，还可以。
      不过延迟和吞吐不理想：在 OpenRouter 上大约每秒 6,000 token，这拖慢了最初的索引过程。
    }
    @heading["eval"]{评估}
    @para{
      那么结果如何？回到 @link["https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{之前那个 Postgres vs MySQL 查询}
      （@link["http://archive.today/2026.08.03-083542/https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{存档}），
      结果好坏参半，介于有用、有趣和胡说之间。
    }
    @ul{
      @item{@link["https://dnitza.com/bookmarks/299536c3ab8e69e071f50d4a81f4df925d3779ff"]{第一条结果} 是个好笑但算不上失败的结果。
        它是一条缓存下来的 Hacker News 评论（Nitsikopoulos，你为什么把博客里收藏的所有内容都缓存下来？），
        来自一篇关于某公司从 MongoDB 迁移到 PostgreSQL 的投稿。评论比较了大规模运行 Postgres 和 MySQL 的情况
        （虽然那篇投稿本身确实讲的是 MongoDB），这就解释了为什么相似度得分高。搜索是有效的，也提供了深入见解，
        但在某些情况下，这种呈现方式会让用户困惑。}
      @item{@link["https://flaviocopes.com/postgres-vs-mysql/"]{第二条}
        和 @link["https://zaiste.net/databases/vs/postgresql-mysql/"]{第三条}结果确实很相关，但内容单薄，质量平庸。}
      @item{@link["https://www.taskboy.com/2002-08-06-Postgres_Ahoy_.html"]{第四条结果}
        是一篇可追溯到 2002 年的老博客文章，正是我喜欢看到的那种有趣内容。它冷门，基于亲身经验，
        其中许多技术建议如今已成为历史。}
      @item{@link["https://binaryigor.com/mysql-and-postgresql-different-approaches.html"]{第五条结果}
        大概是整体上最强的答案：Roztropiński 详细比较了两者，深入探讨了它们的存储模型，还附有一些基准测试代码。}
    }
    @para{
      折腾一阵后，我发现，当查询是博主可能在文章里做出的断言时，结果更有见地；而更像句子的较长查询
      效果更好。我还试了一些其他有意思的例子：
    }
    @ul{
      @item{@link["https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{homelab 给人们带来什么}
      （@link["http://archive.today/2026.08.03-114624/https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{存档}）
      给出了一些关于 Nicole 那台性能过剩的 homelab 的有趣轶事，也混进了一些低质量内容农场。}
      @item{@link["https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{我留了多年的相机}
      （@link["http://archive.today/2026.08.03-115240/https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{存档}）
      让我认识了 Henry 的 Canon PowerShot A510，以及用它拍出的美丽照片。}
      @item{对于 @link["https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{远程工作让我孤独}
      （@link["http://archive.today/2026.08.03-115755/https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{存档}），
      我本以为会找到一些 COVID-19 时期的博客，却惊讶地发现 Jasdev Singh 2015 年的文章排在顶部。}
      @item{@link["https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{为什么你应该用 Linux 桌面}
      （@link["http://archive.today/2026.08.03-121229/https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{存档}）
      返回了大量方便的链接，可以发给朋友，引诱他们用 Linux。还有必不可少的：@link["https://semsearch.blog/?q=Windows+11+sucks&lang=en"]{Windows 11 很烂}。}
    }
    @para{
      总之，这个搜索确实能用，也不时呈现出互联网更个人化的一面。不出所料，质量很大程度上取决于
      语料库，而搜索只能提示相关性。前端有时会让人困惑，因为它只显示标题和文章开头几行，
      用户可能很难在原文中再次找到相关片段。
    }
    @heading["limit"]{局限与未来工作}
    @para{
      这仍是一个早期概念验证，存在一些怪癖。一个显眼的怪癖是，嵌入模型对稍微不标准的措辞不太稳健。
      例如，查询 @link["https://semsearch.blog/?q=framework+laptop+review&lang=en"]{"framework laptop review"}
      （@link["http://archive.today/2026.08.03-121718/https://semsearch.blog/?q=framework+laptop+review&lang=en"]{存档}）
      返回乱七八糟的结果，而大小写正确的查询
      @link["https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{"Framework Laptop review"}
      （@link["http://archive.today/2026.08.03-122117/https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{存档}）
      则返回相关结果。如上所述，网站若能在搜索结果中显示相关片段也会更好；某种社区投票机制
      或许有助于过滤低质量内容（不过也会引入其他问题）。
    }
    @para{
      我打算搭一个 homelab，再弄一块 3090 用于自托管和进一步实验，具体如下：
    }
    @ul{
      @item{整理一个标准化评估数据集，并针对它测试以下方法。}
      @item{测试更多分块策略，比如 late chunking 方法@cite["michaelLateChunking2025"]。}
      @item{测试其他嵌入模型，并解决上面提到的怪癖。}
      @item{更多博客！一个潜在来源是 @link["https://github.com/kagisearch/smallweb"]{Kagi Small Web}。}
    }
  })

(provide post)