# Sample projects that one can try out

Here is a list of projects that you can work on. This is only a suggestion.
If you are interested in any project go ahead.

Haskell is rich in libraries and applications to do various
tasks. However, it requires a bit of experience to find the right one
for the application in mind. You can consult your other friends and
also ask me for suggestion on how to proceed.

Here are some suggestions. Of the 30% marks, 10% of the marks goes to
the the professionalism of the project. What I mean by this is that
your project should

1. Use a version control system. If you have never used one try out
   [darcs]. It is easy to learn and will change your life for the better.

2. Package the application/library as a [cabal] package.

3. If it is a library use Haddock to document it.

Of course you won't get the 10% marks for writing a well documented
version of Hello World.


## Networking

Networking projects can be quite useful. However, remember to use fast
string libraries like Data.ByteString and parser libraries like
Attoparsec for parsing and generation. An exceptionally fast string
building library is the Blaze library. Search google for links.

1. Implementation of standard protocols like DHCP, DNS, HTTP, SMTP,
   POP, IMAP etc

2. A purely Haskell version of the X-Window protocol. The X-windows
   system is a client, server based windowing system. The current X
   library is a wraper library on the C, Xlib library. Since the
   protocol is open it would be a good idea to implement a client
   library like Xlib fully in haskell. The power of Haskell can be
   made use of to make certain constructs type safe which the original
   library does not. For example both windows and Pixmaps are
   represented by integers in C. So one can legally pass a pixmap id
   instead of a windows id leading to sometimes disastrous
   consequences.

## Web frameworks

1. [Yesod] and [Happstack] are two very interesting frameworks for Haskell
   web development. Think of a nice web based application and try
   coding it up.

2. Use one of the above framework to build an [OpenID] authentication
   server.

## Language and Compiler theory

To build parsers in Haskell there are two routes that one can uses.
One is the Alex/Happy route which is like the lex/yacc route for
Haskell (but better). Other is the combinator library for parsing like
Parsec. Before the start of the project make a decision on which to
use and then start. It is usually easier to pick up Parsec (because
you dont have to learn another language) than using Alex/Happy however
the parsers that use Alex and Happy tend to be faster. Explore both
options and the decide on one.

1. One standard project that people can do is to build a scheme/lisp
   interpreter.

2. [M4] is a simple but powerful macro processor. Implement an [M4]
   processor.

3. There are many applications/libraries/languages to do vector
   graphics.  Example include METAFONT, METAPOST for 2-D graphics
   (mainly used for font generation). All these are mostly imperative
   ones. Build a library to build vector graphics images. Possible
   backends could be PDF/PostScript, SVG LaTeX pgf package etc.


## Haskell Graphics

1. Haskell has support to OpenGL. What about designing a simple game in Haskell ?
   like for example paddle-ball game or pacman.

2. Developing a CAD system. Think of ways in which engineers can specify plans
   of buildings, machine parts etc. Use OpenGL for rendering.

3. Console based menu system. See [dialog] for some idea. You need to
   find out what terminal library Haskell supports. Checkout terminfo and
   its support in Haskell.

## Logic and symbolic computation

1. Theorem provers.

2. Sat solvers.

3. [Symbolic integration]

## Projects already taken up few students this semester

[Click here](list-chosen.html) to find a list of projects
taken up already.

Please send a mail with your project title, online summary and the
project group to me ASAP.


## References

1. [Real world Haskell](http://book.realworldhaskell.org/read/)
2. [Haskell.org](http://www.haskell.org)

[dialog]: <http://en.wikipedia.org/wiki/Dialog_%28software%29>

[darcs]: <http://darcs.net>

[m4]: <http://en.wikipedia.org/wiki/M4_%28computer_language%29>

[Symbolic integration]: <http://en.wikipedia.org/wiki/Symbolic_integration>

[Yesod]: <http://www.yesodweb.com>
[Happstack]: <http://www.happstack.com>
[OpenID]: <http://openid.net>
[Haddock]: <http://www.haskell.org/haddock>
[cabal]: <http://www.haskell.org/cabal>