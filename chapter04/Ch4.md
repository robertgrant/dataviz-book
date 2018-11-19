**Chapter 4**

All the R code is in [Ch4.R](Ch4.R) and the Stata code in [Ch4.do](Ch4.do).

[Figure 4.1](4-bar-binary2.svg) started as a bar chart in Stata. I opened this in Inkscape, copied everything to appear again alongside, then replaced the bar with a series of rectangles and added annotation down the side. The three colors are generated from [colorhexa.com](https://www.colorhexa.com/7575b6) as ternary colors, that stand out clearly together, though I then chose to brighten up the red somewhat. That red originally came from a leaf in my local park, sampled with the [ColorGrab app](https://play.google.com/store/apps/details?id=com.loomatix.colorgrab&hl=en) on my phone.

Figure 4.2 is a very [simple waffle plot](4-drugs-waffle.svg). I felt that none of the R waffling options were simple enough, so I just wrote a loop that writes out SVG code into a text file. Each pass through the loop is a square, and pulls in the relevant color (hex code). This got labels added in Inkscape.

[Figure 4.3](4-ternary.svg), a somewhat tongue-in-cheek illustration of a ternary plot, with a tip of the hat to an old Mars bar advert, was made entirely in Inkscape.

Figure 4.4, a [simple bar chart with two bars](4-bar-compare-questions.svg), is entirely made in Stata.

Figures 4.5 (a [stacked bar chart](4-bar-stacked.svg)) and 4.6 (two [clustered bar charts](4-bar-compare-time.svg)) were generated from Stata. The two parts of Figure 4.6 were combined in Inkscape and the font enlarged accordingly.

Figure 4.7 (two [clustered bar charts](4-bar-compare-ranked.svg)) was made by removing the bars from the SVG of Figure 4.6 and adding new bar SVG code generated in R. I wanted to keep the rest of the graph identical in dimensions to Figure 4.6, although I lived to regret it. This is not an easy way to make a graph, and you'd only consider this kind of approach if you are writing a book!

Figure 4.8, a [parallel sets plot, a.k.a. Sankey diagram](4-parallel-sets.svg), was generated from R; there are many options for this but I went with `ggalluvial`. You might like to compare it with the (to my mind) [inferior version](4-parallel-sets2.svg).

Figure 4.9, a [treemap](4-treemap.svg), is created from R and then had labels edited in the SVG code.

Figure 4.10 is [a tree containing three waffle plots](4-tree-waffle.svg). The waffles were made in R, then combined in Inkscape. The tree part was created there.
