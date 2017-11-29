data = read.csv("springtail-param-exp.xls", header = T)

# Doesn't work -> need to investigate ggplot
# x = table(subset(data, max.gap.m = 0, select = -species))
# sub = subset(data, max.gap.m == 0, select = c(alignments, palindromes))
# m = t(as.matrix(sub))[1:2,]
# counts = table(data$alignments[data$max.gap.m == 0],data$palindromes[data$max.gap.m == 0])


sub0 = subset(data, max.gap.m == 0, select = c(alignments, palindromes))
sub1 = subset(data, max.gap.m == 1, select = c(alignments, palindromes))
sub5 = subset(data, max.gap.m == 5, select = c(alignments, palindromes))

              
par(mfrow = c(3,1))
barplot(t(as.matrix(sub0)), beside = TRUE, 
        main="Parameters exploration: min gap = 0",
        xlab="max size", col=c("darkblue","red"),
        legend = colnames(sub0), names.arg = c(1:5), ylim = c(0,48))
barplot(t(as.matrix(sub1)), beside = TRUE, 
        main="min gap = 1",
        xlab="max size", col=c("darkblue","red"),
        legend = colnames(sub0), names.arg = c(1:5), ylim = c(0,48))
barplot(t(as.matrix(sub5)), beside = TRUE, 
        main="min gap = 5",
        xlab="max size", col=c("darkblue","red"),
        legend = colnames(sub0), names.arg = c(1:5), ylim = c(0,48))



