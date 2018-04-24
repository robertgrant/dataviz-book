
# Figure 1.3 Anscombe
# code adapted from the R help file for datasets::anscombe
ff <- y ~ x
mods <- setNames(as.list(1:4), paste0("lm", 1:4))
for(i in 1:4) {
  ff[2:3] <- lapply(paste0(c("y","x"), i), as.name)
  mods[[i]] <- lmi <- lm(ff, data = anscombe)
  print(anova(lmi))
}
svglite::svglite('1-anscombe.svg')
op <- par(mfrow = c(2, 2), mar = 0.1+c(4,4,1,1), oma =  c(0, 0, 2, 0))
for(i in 1:4) {
  ff[2:3] <- lapply(paste0(c("y","x"), i), as.name)
  plot(ff, data = anscombe, pch=19,col='#00000088',xlab='X',ylab='Y',
       xlim = c(3, 19), ylim = c(3, 13))
  abline(mods[[i]])
}
par(op)
dev.off()
