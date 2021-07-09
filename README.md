## Note! I no longer use Github. This repo may be out of date.

All my ex-Github repos are now stored and maintained at [my personal website](http://www.robertgrantstats.co.uk/code.html).

Why did I leave Github? Because I consider the compulsory imposition of 2-factor authentication to be inappropriate for people writing software, including cryptography, which can attract severe punishments in certain jurisdictions. We all know that the organisations that hold the 2nd factors (mobile telephony providers, tech companies) are compromised, willingly or otherwise, in their relationships with security agencies, benign or otherwise.

Why not just close it down? Because you might use it programmatically, via http or API, and I don't want to hurt you (by breaking your code) while trying to help you (by raising issues of privacy and confidentiality).




# *Data Visualization: charts, maps and interactive graphics*: the making of

This repository accompanies my book [*Data Visualization: charts, maps and interactive graphics*](https://www.routledge.com/Data-Visualization-Charts-Maps-and-Interactive-Graphics/Grant/p/book/9781138707603), which was published by CRC Press in collaboration with the American Statistical Association in 2018. It is part of the CRC-ASA series on Statistical Reasoning In Science And Society. The code and explanations here are also available [on my own website](http://www.robertgrantstats.co.uk/dataviz-book.html), and you might prefer to view that if you are new to Git and Github.

I explain how I made the images in the book, and some of the back story behind the examples made by others. Everything is arranged by chapter. There are code files for R and Stata, data files, and SVG original images. All the code files here are my own work and I release them under [The Unlicense](http://unlicense.org/).

Please remember that these are not intended as teaching material, nor as examples of best practice in coding. In the R code in particular, you will find some idiosyncracies of mine which are unfashionable, such as looping at the first opportunity or mixing base and tidyverse.

The Table Of Contents is here as TOC-dataviz.pdf

Files are named after the chapter and figure numbers. Each chapter has a .md Markdown file that you should read first. Where there is no .svg for a particular image, this is explained in the .md file. As of 2018, GitHub seems to display SVGs that came from Stata or Inkscape, but struggles with those that came straight from R's `svglite::svglite` graphics device. Hopefully that will get sorted out soon; you can always download them and view them locally, and they should appear all right if you follow the same link on [my website](http://www.robertgrantstats.co.uk/dataviz-book.html), although there are still some quirks between browsers.

My general workflow is to make a basic chart out of the data in R or Stata, and then export it as SVG (a vector graphics format which contains instructions to make the image -- put a circle here and a line there -- without committing to any image size or dots per inch), in many cases edit it in the text editor or Inkscape (vector graphics editor), and occasionally in GIMP (raster graphics editor) betwixt SVG and PNG for publication (but I tried to avoid that). Some images were created *ex nihilo* in the text editor. This is all discussed for individual images in the .md files, but in many cases the SVG tweaking was just to make text legible in book format, which is perhaps not necessary for your own work if you want to adapt what is here.
