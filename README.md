## Clojure transducers in a typed setting, in Haskell

I was struggling to understand Rich Hickey's notion of *transducers* in Clojure that he announced in a [blog post](http://blog.cognitect.com/blog/2014/8/6/transducers-are-coming) and posted some [sample code](https://gist.github.com/richhickey/b5aefa622180681e1c81) for in response to a [discussion thread](https://news.ycombinator.com/item?id=8143905). The discussion there was very confusing to me, and I decided I could not really understand what was going on until I actually reimplemented the ideas in a statically typed language.

Fortunately, on another [discussion thread](http://www.reddit.com/r/haskell/comments/2cv6l4/clojures_transducers_are_perverse_lenses/), he posted actually running [Haskell code](http://www.reddit.com/r/haskell/comments/2cv6l4/clojures_transducers_are_perverse_lenses/cjjyay7), which helped me **tremendously**, since most of the discussion I had seen so far was either very vague or very abstract.

So I refactored his code to fit just exactly what he did, not something far more general, and posted my refactored code in response. I hope this will help more people understand *exactly* what they do, using types.

### Rank-2 types

Note that the critical component of this work involves using [rank-2 types](http://www.haskell.org/haskellwiki/Rank-N_types). Transducers *cannot* be expressed in a weaker type system that does not support higher-rank types.

I hope that the introduction of transducers will create a lot of interest among those who are not already familiar with higher-rank types.

## My blog post

I wrote a [blog post about this code](http://ConscientiousProgrammer.com/blog/2014/08/07/understanding-cloure-transducers-through-types/).