# Elm impossible msg

This repo reproduces a behaviour of Elm program that should be impossible and,
supposedly, demonstrates a bug in one of core packages or runtime (which should
be further clarified).

## How to see the bug

1. Run `elm install`
2. Run `elm reactor`
3. Open [http://localhost:8000/src/Main.elm](http://localhost:8000/src/Main.elm)
4. Open browser Console
5. Start typing in the input below "First form" title
6. You will be immediately switched to the second form
7. Inspect the output of Console. You will notice that after UrlChange msg goes
`SecondForm Blur`, which is not possible from the types defined in Main.elm

I managed to reproduce this bug using combination of
`Browser.Navigation.pushUrl`,
`Html.Events.onBlur` and `Html.map`. In real world usage this behaviour can
cause runtime exception.
