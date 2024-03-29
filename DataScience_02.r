
#######################################################################################################
#HEC Lausanne - MScF
#Data Science for Finance
#Exercise Session 2 - 27.09.2019
#Marceau Pierron, Taulant Ukshini, David Sasselli, Nora Koennyu
#######################################################################################################


#######################################################################################################
#Question 2.1 - graphing the distribution of the average randomly drawn from
#               a Poisson distribution with different sample sizes
#######################################################################################################

#initialization
mutotal=c()
parameter=0.5
size=c(30,100,1000,10000)
colours=c("black","red","green","blue")

#sampling
for(i in size){
  mu=c()
  for(j in 1:1000){
    y=rpois(i,parameter)
    s=mean(y)
    mu=c(mu,s)
  }
  
  mutotal=cbind(mutotal,mu)
  
}

#charting the results
postscript("Q1_3plot.eps")
par(bty="n")

plot(density(mutotal[,1]),
     ylim=c(0,50),
     col="black",
     main="",
     xlab="")

for(k in c(2,3,4)){
  lines(density(mutotal[,k]),
        col=colours[k])
}

legend(x="right",y=0.92,c("30 Observations","100 Observations","1000 Observations","10000 Observations"),
       cex=0.8,
       lty=1,
       col=colours,
       box.lty=0
)
dev.off()

#######################################################################################################
#Question 2.2 - graphing the standard deviation
#######################################################################################################

#calculating standard deviation
mu_func = function(n){
  mu=c()
  for(j in 1:1000){
    x=rpois(n,0.5)
    s=mean(x)
    mu=c(mu,s)
  }
  
  return(sd(mu))
  
}

func_1 = function(x){
  return(1/sqrt(x))
}

#charting results
postscript("Q1_4plot.eps")
par(bty="n")
plot(func_1,
     main="",
     col="red",
     col.main="black",
     lwd=4,
     xlab="Number of Observations",
     ylab="Volatility of Estimator",
     xlim=c(-50,10000),
     ylim=c(0.01,0.2)
)
i=0

while(i <= 10000){
  points(i,mu_func(i),pch=3)
  i=i+200
}

legend(x="right",y=0.92,c("Estimated Volatility of the Estimator","1/sqrt(n)"),
       cex=0.8,
       lty=c(NA,1),
       col=c("black","red"),
       pch=c(NA,3),
       box.lty=0
)
dev.off()

#######################################################################################################
# Question 1.3 - graphing the distribution of the estimator along with
#                the normal distribution
#######################################################################################################

postscript("Q1_5plot.eps")
layout(matrix(1:4,2,2))
for (i in 1:length(size)){
  temp=(mutotal[,i]-parameter)/(sqrt(parameter))*sqrt(size[i])
  dens=density(temp)
  plot(dens, 
       xlim =c(-4,4),
       ylim =c(0,0.5),
       main=size[i])
  lines(dens$x,dnorm(dens$x),col="red")
}
dev.off()

#######################################################################################################
# Question 2.1 - computing optimal portfolio
#######################################################################################################

#loading data
X=read.delim("data_lausanne_equity.csv",sep=";",header=FALSE)

#calculating optimal weights
X=diff(as.matrix(log(X)),1)
mu2=apply(X,2,mean) 
sigma=cov(X)
sigma_inv=solve(sigma)
gamma=3
w=1/gamma*sigma_inv%*%mu2

#######################################################################################################
#Question 2.2 - computing realized compounded performance
#######################################################################################################

postscript("Q2_2plot.eps")
variance_of_return = t(w)%*%sigma%*%w
performance = t(mu2)%*%w                  #expected return on the portfolio               
print(paste("Expected return on the portfolio = ", performance))
print(paste("Expected variance of the portfolio = ",variance_of_return))
plot(seq(-0.5,0.5,by=0.01), 
     dnorm(seq(-0.5,0.5,by=0.01), mean=performance, sd=sqrt(variance_of_return)),
     xlab="Performance",
     ylab="")
dev.off()
