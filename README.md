# prrr
some kind of text preprocessing thing?

## current state
use the syntax
```
#def <regex> <replacement> #fed
```
to define a replacement, using `@<group number>` to reference regex groups.

note: do not use `/g`; all replacements are global.

## example (markdown emulator)
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
- can use #include <filename relative to current file> to include files (see `example/posts/first.txt` for example)
- example usage: `./prrr.rb example/posts/first.txt`

## eventual goal
some kind of configurable text preprocessor

```
#define tag { contents } => <tag>contents</tag>
#define !function args... => function(args)
```

`h1 { hi world }` -> `<h1>hi world</h1>`

`!console.log 'hello world' 'hi'` -> `console.log('hello world', 'hi')`
