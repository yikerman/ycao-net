#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Building a Search Engine for 6,000 Personal Blogs" "2026-08-03"]{
    @para{
      TL;DR: Semsearch is an embedding-based search engine whose corpus is bootstrapped from 
      @link["https://indieblog.page/faq#data"]{indieblog.page's blog list}. It aims to make indie
      blogs more discoverable. At the time of writing, the live instance is up at @link["https://semsearch.blog"]{semsearch.blog}
      with @link["https://archive.today/2026.07.29-180627/https://semsearch.blog/status"]{roughly 6,000 unique blog sites, 154k pages, and 1.4B tokens}.
      The source code is at @link["https://github.com/yikerman/semantic-search"]{github.com/yikerman/semantic-search}.
    }
    @heading["motivation"]{Motivation}
    @para{
      The idea for this project emerged when I read about @link["https://danielstanica.com/posts/Great-Blogging-Collapse"]{The Great Blogging Collapse}
      (@link["https://news.ycombinator.com/item?id=48758802"]{HN discussion}). While the post itself 
      has a couple of problems, its broader point resonated with me as a blogger: there are fewer ways 
      to promote small and individual blogs. In the past, many visits began when Google led users to
      your blog. But Google, as shown in @it{The Great Blogging Collapse}, is doing so less and less
      for various reasons, such as the rise of AI summarization that completely eliminates visits to 
      other sites.
    }
    @para{
      This aligns with other sources: @link["https://dkb.blog/p/google-search-is-dying"]{people (including me) prefer searching on Reddit}
      since Google's top results are cluttered by ads and SEO-optimized content farms. For example, a
      Google search for the old @link["https://www.google.com/search?q=postgres+vs+mysql"]{Postgres vs MySQL} debate
      returns mostly AWS and IBM articles that are of little use. (Interestingly, at the time
      of writing, it seems that Google has boosted Reddit's ranking and put it among the top results.)
    }
    @img["/files/20260730/google-search1.png"]{Google Search for PostgreSQL vs MySQL}
    @para{
      While the debate has largely settled, this would have been the perfect scenario to display some
      old-n-wise engineer writing about his experience with both in production, even if his webpage is
      styled uglier than @link["https://motherfuckingwebsite.com/"]{@it{The Motherfucking Website}}.
    }
    @para{
      Recent embedding models have made it practical to search by meaning rather than exact keywords
      (which also requires non-trivial tricks to work effectively), and vector databases have also
      proven to be practical and easy to use. While most existing embedding-based search systems are
      used to provide agentic LLMs with retrieval capabilities, I want to explore the possibility of using
      purely embedding-based search to help people discover indie blogs.
    }
    @heading["method"]{Implementation}
    @para{
      I used FastAPI for the web app and @link["https://hub.docker.com/r/tensorchord/vchord-suite"]{Postgres + VectorChord}
      for the database. The set of blogs is bootstrapped from @link["https://indieblog.page/faq#data"]{indieblog.page's blog list}.
      For each page discovered through either an RSS feed or a sitemap, I used @link["https://github.com/adbar/trafilatura"]{Trafilatura}
      to extract the text content, then chunked it into overlapping 384-token segments. For the
      embedding task, I chose @link["https://huggingface.co/Qwen/Qwen3-Embedding-4B"]{Qwen3-Embedding-4B}  
      as the embedding model, since it topped the @link["http://archive.today/2026.08.01-143048/https://mteb-leaderboard.hf.space/models/Qwen/Qwen3-Embedding-4B"]{MTEB leaderboard}
      at the time of writing, is open source, and is relatively cheap to run. Every chunk is stored in
      the database as a 2,560-dimensional halfvec.
    }
    @para{
      At query time, Semsearch embeds the query once and runs designated retrievers. By default, only
      the dense retriever, based on the cosine similarity between the query embedding and chunk embeddings,
      is used, and the top 64 entries are returned. There is also an optional BM25@cite["robertsonProbabilisticRelevance2009"]
      retriever for both evaluation and combining results through RRF@cite["cormackReciprocalRankFusion2009"]
      (Anthropic claims that the hybrid approach performs better@cite["anthropicContextualRetrieval2026"]).
      For details, see @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/search/pipeline.py#L60"]{the search pipeline}
      and the @link["https://github.com/yikerman/semantic-search/blob/afff9c7aa41e08e80e22359a0ac51f89cab42ddf/src/semsearch/web/db.py#L198"]{SQL doing the heavy lifting}.
    }
    @heading["deploy"]{Deployment}
    @para{
      Deployment is a bit tricky, since the @link["https://github.com/pgvector/pgvector#hnsw"]{HNSW index} 
      takes about 30 GB of RAM to load at the current scale, and VPS costs scale a lot with RAM. 
      For reference, an @code{r6a.xlarge} instance on AWS costs $0.252/hr. I ended up getting a 
      dedicated i7-6700 box from Hetzner's server auction for €55/mo. While the CPU is crappy by modern
      standards, it comes with 64 GB RAM and 2 × 512 GB NVMe SSDs, an absolute bargain in the RAMageddon era.
    }
    @para{
      I used @link["https://openrouter.ai/qwen/qwen3-embedding-4b"]{OpenRouter's API} to run the
      embedding model, since it is relatively cheap, namely $0.02/M tokens. Indexing the current 
      corpus cost a modest $28.60, which is not bad. The latency and throughput are not
      ideal, though: I get roughly 6,000 tokens/sec on OpenRouter, and it bottlenecked the initial 
      indexing process.
    }
    @heading["eval"]{Evaluation}
    @para{
      So how do the results look? Going back to the @link["https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{earlier query of Postgres vs MySQL}
      (@link["http://archive.today/2026.08.03-083542/https://semsearch.blog/?q=Postgres+vs+MySQL&lang=en"]{archived}),
      the results are mixed and sit somewhere between useful, fun, and nonsense.
    }
    @ul{
      @item{@link["https://dnitza.com/bookmarks/299536c3ab8e69e071f50d4a81f4df925d3779ff"]{The first result} is a
        funny not-quite-a-failure. It is a cached Hacker News comment (why are you caching all the
        content you bookmark on your blog, Nitsikopoulos?) from a submission about a company migrating from MongoDB to
        PostgreSQL. The comment compares operating Postgres and MySQL at scale (while the submission 
        itself is, indeed, about MongoDB), which explains the high similarity score. The search works 
        and provides deep insights, but the presentation can be confusing to users in certain cases.}
      @item{The @link["https://flaviocopes.com/postgres-vs-mysql/"]{2nd}
        and @link["https://zaiste.net/databases/vs/postgresql-mysql/"]{3rd} results are indeed very
        relevant, but the writing is thin and of mediocre quality.}
      @item{The @link["https://www.taskboy.com/2002-08-06-Postgres_Ahoy_.html"]{4th result}
        is an old blog post dating back to 2002 and is the kind of fun content I would like to see. It is obscure
        and based on firsthand experience, and much of the technical advice is now historical.}
      @item{The @link["https://binaryigor.com/mysql-and-postgresql-different-approaches.html"]{5th result}
        is probably the strongest answer overall: Roztropiński has a detailed comparison of the two,
        with some deep dives into their storage models and some benchmark code.}
    }
    @para{
      After fiddling around, I found that it gives more insightful results when my query is an assertion
      a blogger might make in a post, and that longer queries resembling a sentence work better. Some extra
      interesting examples I tried:
    }
    @ul{
      @item{@link["https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{what homelab brings to a people}
      (@link["http://archive.today/2026.08.03-114624/https://semsearch.blog/?q=what+homelab+brings+to+a+people&lang=en"]{archived})
      yields some funny anecdotes about Nicole's overpowered homelab, and also some low-quality content farms.}
      @item{@link["https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{the camera I kept for years}
      (@link["http://archive.today/2026.08.03-115240/https://semsearch.blog/?q=the+camera+I+kept+for+years&lang=en"]{archived})
      introduced me to Henry's Canon PowerShot A510 and the beautiful pictures taken with it.}
      @item{For @link["https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{working remotely made me lonely}
      (@link["http://archive.today/2026.08.03-115755/https://semsearch.blog/?q=working+remotely+made+me+lonely&lang=en"]{archived})
      I expected to find some COVID-19-era blogs, but was surprised to find Jasdev Singh's 2015 writing
      at the top.}
      @item{@link["https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{why you should use Linux Desktop}
      (@link["http://archive.today/2026.08.03-121229/https://semsearch.blog/?q=why+you+should+use+Linux+Desktop&lang=en"]{archived})
      returns loads of convenient links to send to your friends and lure them into using Linux. Also obligatory: @link["https://semsearch.blog/?q=Windows+11+sucks&lang=en"]{Windows 11 sucks}.}
    }
    @para{
      In conclusion, the search definitely works and offers a more personal side of the Internet from
      time to time. As expected, quality heavily depends on the corpus, while the search can only
      suggest relevance. The frontend can be confusing sometimes, since it only displays the title
      and the first few lines of a post, and the user may have a hard time locating the relevant chunk
      in the original post again.
    }
    @heading["limit"]{Limitations & Future Work}
    @para{
      This is still an early proof of concept, and some quirks exist. A notable one is that the
      embedding model is not very robust to slightly nonstandard phrasing. For example, the query
      @link["https://semsearch.blog/?q=framework+laptop+review&lang=en"]{"framework laptop review"} 
      (@link["http://archive.today/2026.08.03-121718/https://semsearch.blog/?q=framework+laptop+review&lang=en"]{archived}) 
      returns gibberish results, while the properly capitalized query
      @link["https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{"Framework Laptop review"}
      (@link["http://archive.today/2026.08.03-122117/https://semsearch.blog/?q=Framework+Laptop+review&lang=en"]{archived}) 
      returns relevant results. The website would also benefit from displaying relevant chunks in the
      search results as discussed above, and some community voting mechanism may be useful to filter 
      out low-quality content (though it will introduce other problems).
    }
    @para{
      I plan to build a homelab and get a 3090 for self-hosting and further experiments, namely:
    }
    @ul{
      @item{Assemble a standardized evaluation dataset and test the following approaches against it.}
      @item{Test more chunking strategies, such as the late chunking method@cite["michaelLateChunking2025"].}
      @item{Test other embedding models and address the quirk mentioned above.}
      @item{More blogs! A potential source is @link["https://github.com/kagisearch/smallweb"]{Kagi Small Web}.}
    }
  })

(provide post)
