# pppp
hopefully one day some kind of universal text preprocessing thing

# eventual goal
some kind of configurable text preprocessor

```
#define tag { contents } => <tag>contents</tag>
#define !function args... => function(args)
```

`h1 { hi world }` -> `<h1>hi world</h1>`

`!console.log 'hello world' 'hi'` -> `console.log('hello world', 'hi')`
