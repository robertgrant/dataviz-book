**Chapter 2**

Figs 2.1-2.6 are generated from base R graphics (see [traindelays-4weeks.R](https://github.com/robertgrant/dataviz-book/blob/master/chapter02/traindelays-4weeks.R)). Because they are all showing variations on the same plot, there is one function defined at the beginning, with some options, such as to show markers or lines, and then this is repeatedly called inside `png()` and `svglite::svglite()` graphics devices. This ensures that there is consistency in things like margins and labeling, because they can be changed in just one place and affect all the graphs generated from that function.

The data was assembled from a few different Excel spreadsheets published by the Office of the Rail Regulator (now, the Office of Rail and Road). You can get my cleaned up version in [trains.dta](https://github.com/robertgrant/dataviz-book/blob/master/data/trains.dta), which is Stata format (v14), and can be converted as you please via R with `haven::read_dta()`.

Figure 2.1 is intended to be a basic scatter plot (the SVG file is [here](2-traindelays-scatter1.svg)), and Figure 2.2 a basic line chart of the same data (the SVG file is [here](2-traindelays-line1.svg)). I like this time series and how it has served several different purposes in the book. Here, the occasional spikes in the line chart show that a line chart emphasises outliers by putting more ink on the page for them. Sometimes, that is what you want to do, but sometimes not.

Figure 2.3 is about highlighting (and overloading the reader), so it is the same as 2.2 but with extra markers or rectangles added in R. The SVG file is [here](2-traindelays-line2.svg). Figure 2.4 changes the encoding of variables to axes (the SVG file is [here](2-traindelays-3.svg)), and Figure 2.5 adds color coding to Figure 2.4 (the SVG file is [here](2-traindelays-4.svg)).

Figs 2.3-2.5 are pairs of images put together into one in Inkscape. Nothing else was changed. Since I did that, the function `multipanelfigure` came along. That could have saved me a lot of time.

The images in Table 2.1 and figure 2.7 were just typed into a text editor. If you look at the SVG file [2-different-lines.svg](2-different-lines.svg) and the various files beginning 2-table1..., you'll see how simple the SVG can be to read and write, once you understand a few basics.

Figure 2.8 is made in Inkscape. I downloaded an SVG train icon from Wikimedia Commons (I chose a particularly stylized one), and repeated it in rows, cropping one, and then adding text. The SVG file is [here](2-icons.svg).

Figure 2.12 was just SVG typed into a text editor; the SVG file is [here](2-bars.svg).

Figure 2.13 was generated as repeated lines of text in R (see [Ch2.R](Ch2.R)) that made up an SVG waffle. The SVG file is [here](2-waffle.svg), and if you look at it in the text editor, you'll see how each line is written out, changing only the x and y coordinates as it goes along. In some print runs of the book, the waffle came out looking like there are slightly wider gaps between some of the rows and columns of the grid; that's just a printing artifact and you can see it's not there in the original SVG.

Figures 2.6 and 2.9-2.11 are made by other people.
