Managing projects with GNU Make
===============================

It is a translation of the O'Reilly *Managing projects with GNU Make*
book (3 edition) to Russian.

Original
========

You can find original of the book at
[O'Reilly web site](http://oreilly.com/catalog/make3/book/index.csp). It
is also possible to download the original using progect `Makefile`:
just execute the following command (requires `wget` and ~4.5M
of free space):

    make download-origin

Build
=====
At the moment the build is possible only on UNIX systems. To build the
book you need to have latex and mpost. If you have Latex Live
distributive installed, just execute `make` in project directory. To
get more help regarding project build execute `make help`.

If you want to build the book on Windows very much, you can do it
manually. Of course, you still have to install latex. All you need is
to:

1. process all the figures from `figures` directory with metapost
   processor (`mpost`);

2. rename processed files from `<name>.1` to `<name>.eps`;

3. build `main.tex` file with `pdflatex`.

Alternatively, you can write some kind of Makefile for Windows.

License
=======

This work is distributed under GNU FDL 1.3. A copy of this license
located in the LICENSE file. You can find additional info about this
license on [GNU official web site](http://www.gnu.org).

Contacts
========

If you have questions or want to contribute please contact me:
[Roman Kashitsyn](mailto:roman.kashitsyn@gmail.com)
