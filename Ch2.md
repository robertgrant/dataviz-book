**Chapter 2**

Figs 2.1-2.6 are generated from base R graphics. Because they are all showing variations on the same plot, there is one function defined at the beginning, with some options, such as to show markers or lines, and then this is repeatedly called inside png() and svglite::svglite() graphics devices. This ensures that there is consistency in things like margins and labeling, because they can be changed in just on place and affect all the graphs generated from that function.

The data was assembled from a few different Excel spreadsheets published by the Office of the Rail Regulator. You can get my cleaned up version in trains.dta which can be converted as you please with haven::read_dta

Figs 2.3-2.5 are pairs of images put together in Inkscape. Nothing else was changed. Since I did that, the function multipanelfigure came along. That could have saved me a lot of time.

The images in Table 2.1 and figure 2.7 were just SVG typed into a text editor.

Figure 2.8 is made in Inkscape with the SVG train icon from Wikimedia Commons.

Figs 2.9-2.11 are made by other people

Fig 2.12 was just SVG typed into a text editor, and Fig 2.13 was generated as repeated lines of text in R that made up an SVG waffle.
