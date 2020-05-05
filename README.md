# prrr
some kind of text preprocessing thing?

## current state
the pattern
```
#def <regex> <replacement> #fed
```
defines a replacement that will continually replace `<regex>` with `<replacement>`. the pattern `@<group number>` found within `<replacement>` will be replaced with the corresponding regex group.

note: do not use `/g`; all replacements are global.

the pattern
```
#include <filename>
```
will be replaced by the output of `./prrr <filename>`. also, any replacements defined in `./prrr <filename>` will be available to the current file.

## single-file example (markdown emulator)
input:
```
#def /## (.+)/ <h2>@1</h2> #fed
#def /# (.+)/ <h1>@1</h1> #fed
#def /```(.+?)```/ <pre>@1</pre> #fed
#def /`(.+?)`/ <code>@1</code> #fed
#def /\*(.+?)\*/ <em>@1</em> #fed
#def /\[(.+?)\]\((.+?)\)/ <a href="@2">@1</a> #fed

# hello
## how are you today

here is `some code` and some *emphasized text*
here is ```some code in a block```
here is [link](https://google.com)
```

output:
```
<h1>hello</h1>
<h2>how are you today</h2>

here is <code>some code</code> and some <em>emphasized text</em>
here is <pre>some code in a block</pre>
here is <a href="https://google.com">link</a>
```

## multi-file example (blog)
see [example/posts/first.txt](https://github.com/hywn/prrr/blob/master/example/posts/first.txt)

## note about multi-line replacements
currently, prrr will try to align multi-line replacements, e.g.
```
#def /!important (.+)/
Please pay attention:
@1
Thank you for your time
#fed

I have something to say. !important The cow says moo
```
will produce
```
I have something to say. Please pay attention:
                         The cow says moo
                         Thank you for your time
```

## other notes
- accepts input via filename *or* stdin (uses Ruby's ARGF)
- example usage: `./prrr.rb file.txt`
