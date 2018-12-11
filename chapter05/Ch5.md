**Chapter 5**

All figures except 5.4 were made in R. The code for 5.1 and 5.3 is in [Ch5.R](Ch5.R), and the code for 5.4, 5.5 and 5.6 is in [../chapter02/traindelays-4weeks.R](../chapter02/traindelays-4weeks.R).

[Figure 5.1](5-dotplot.svg) is simply a scatter plot where the data supplied are actually summary statistics. In this case, I just made up some stats to go alongside the previous example of Atlanta commuters.

[Figure 5.2](5-distro-examples-normal.svg) is a base R histogram with more invented data. Systolic blood pressure really does have a very normal distribution in healthy populations, because of the many small factors bumping your SBP up or down at any given time. Because these are pretty much independent of each other, they act according to the Central Limit Theorem and provide a normal distribution with mean about 120 and SD about 12. I didn't save this rudimentary R code, but it would be something like:
```
hist(rnorm(1000,mean=100,sd=12),xlab="Systolic Blood Pressure (mmHg)",ylab="Number of people",breaks=20,main='')
```

[Figure 5.3](5-meansplot-errorbars.svg) is a scatterplot with lines added. This sort of plot is easy to construct in base R graphics. You might feel it's cool to use ggplot2, but if you need to make charts quickly for internal consumption / user-testing and then polish them up in SVG, it doesn't matter what you use for basics like this. If you prefer ggplot2 and find it easier to code, use it. If you prefer base, do likewise.

Figure 5.4 was drawn from a scientific paper, ["A multi-professional educational intervention to improve and sustain respondents' confidence to deliver palliative care: A mixed-methods study"](https://journals.sagepub.com/doi/abs/10.1177/0269216317709973?journalCode=pmja), which I contributed to. This tracked health professionals as they took a course in end-of-life care. In this chart, their confidence is shown on a set of nine topics, across three time points: baseline, 3 months later and six months later. It was done in Stata with ```graph box```. The colors are generated as shades of the logo of [Princess Alice Hospice](https://www.pah.org.uk/), which provided the training.

Figures 5.5, 5.6 and 5.7 return to the train delays data and show summary statistics from that dataset. 5.5 shows the [boxplot (quartiles and extreme values)](5-trainsdelays-boxplot.svg) for each of the twenty years, alongside the [mean (dotplot)](5-traindelays-meansplot.svg) for each year. 5.6 shows the [quartiles]((5-traindelays-quartiles.svg)) as a line chart with a bolder central line, and the same design using the [Winsorised mean and median absolute deviation](5-traindelays-winsor-mad.svg). 5.7 shows two smoothed lines, [splines](5-traindelays-spline.svg) and [LOESS](5-traindelays-loess.svg), and in this case new values are generated on a finer grid from the smoothing algorithm, and those new values are drawn.
