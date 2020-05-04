# prrr
some kind of text preprocessing thing?

# current state
use the syntax
```
#define <regex> <replacement, using @s to reference captured groups>
```
to define a replacement.

note: do not use `/g`; all replacements are global.

# example (markdown emulator)
input:
```
#define /## (.+)/ <h2>@1</h2>
#define /# (.+)/ <h1>@1</h1>
#define /```(.+?)```/ <pre>@1</pre>
#define /`(.+?)`/ <code>@1</code>
#define /\[(.+?)\]\((.+?)\)/ <a href="@2">@1</a>

# hello
## how are you today

here is `some code`
here is ```some code in a block```
here is [link](https://google.com)
```

output:
```
<h1>hello</h1>
<h2>how are you today</h2>

here is <code>some code</code>
here is <pre>some code in a block</pre>
here is <a href="https://google.com">link</a>
```

# notes
- is a single script that uses stdin/stdout
- example usage: `./prrr.rb < test.prrr > out.html`

# eventual goal
some kind of configurable text preprocessor

```
#define tag { contents } => <tag>contents</tag>
#define !function args... => function(args)
```

`h1 { hi world }` -> `<h1>hi world</h1>`

`!console.log 'hello world' 'hi'` -> `console.log('hello world', 'hi')`
