#' @title Millar's original gillnet selectivity fitting function
#'
#' @description Function to estimate selectivity parameters from experimental data.
#'    This function is applied within \code{\link{select_Millar}} to derive starting
#'    parameters. \code{\link{select_Millar}} is the recommended function for
#'    selectivity estimation.
#'
#' @param data matrix with the number of individuals caught with each sized mesh
#'    (\code{CatchPerNet_mat}).
#' @param meshsizes vector with meshSizes in increasing order (\code{meshSizes}),
#' @param rtype A character string indicating which method for estimating selection curves
#'    should be used:
#'    \code{"norm.loc"} for a normal curve with common spread,
#'    \code{"norm.sca"} for a normal curve with variable spread,
#'    \code{"lognorm"} for a lognormal curve,
#'    \code{"gamma"} for a gamma curve.
#' @param rel.power A string indicating the relative power of different meshSizes,
#'    must have same length as \code{meshSizes} (Default: \code{rel.power = NULL}).
#' @param plotlens lengths which should be used for graphical output,
#'    for more detailed curves. Default : NULL
#' @param details logical; should details be included in the output?
#'
#' @source https://www.stat.auckland.ac.nz/~millar/selectware/
#'
#' @return list of fitted parameters
#'
#' @importFrom stats as.formula coef confint glm poisson resid
#'
#' @examples
#' data(gillnet)
#'
#' dat <- matrix(c(gillnet$midLengths, gillnet$CatchPerNet_mat),
#'          byrow = FALSE, ncol=(dim(gillnet$CatchPerNet_mat)[2]+1))
#'
#' gillnetfit(data = dat, meshsizes = gillnet$meshSizes)
#'
#'
#' @references
#' Millar, R. B., Holst, R., 1997. Estimation of gillnet and hook selectivity
#'  using log-linear models. \emph{ICES Journal of Marine Science: Journal du Conseil},
#'  54(3):471-477
#'
#' @export

gillnetfit <- function(data, meshsizes,
                       rtype="norm.loc",
                       rel.power=NULL,
                       plotlens=NULL,
                       details=FALSE){
  # Adapted R code from Russell Millar (https://www.stat.auckland.ac.nz/~millar/selectware/)


 if(sum(sort(meshsizes)==meshsizes)!=length(meshsizes))
   stop("Mesh sizes must be ascending order")
 lens=rep(data[,1],ncol(data[,-1]))
 msizes=rep(meshsizes,rep(nrow(data),ncol(data[,-1])))
 msize1=msizes[1]
 dat=as.vector(data[,-1])
 var1=lens*msizes; var2=msizes^2; var3=(lens/msizes)^2
 var4=lens/msizes; var5=-log(msizes); var6=log(msizes/msizes[1])
 var7=var6*log(lens) - 0.5*var6*var6; var8=lens*lens
 var9=msizes/lens

 if(is.null(plotlens)) plotlens=data[,1]
 if(is.null(rel.power)) os=0
  else os=rep(log(rel.power),rep(nrow(data),ncol(data[,-1])))
 switch(rtype,
  "norm.loc"={
  if(missing(rel.power))
   fit=glm(dat ~ -1 + var1 + var2 + as.factor(lens),family=poisson)
  else
   fit=glm(dat ~ -1 + var1 + var2 + as.factor(lens) + offset(os),family=poisson)
  x=coef(fit)[c("var1","var2")]
  varx=summary(fit)$cov.unscaled[1:2,1:2]
  k=-2*x[2]/x[1]; sigma=sqrt(-2*x[2]/(x[1]^2))
  vartemp=msm::deltamethod(list(~-2*x2/x1,~sqrt(-2*x2/(x1^2))),x,varx,ses=F)
  pars=c(k,sigma,k*msizes[1],sigma)
  form1=as.formula(sprintf("~x1*%f",msize1)) #Deltamethod quirk
  varpars=msm::deltamethod(list(~x1,~x2,form1,~x2),c(k,sigma),vartemp,ses=F)
  gear.pars=cbind(estimate=pars,s.e.=sqrt(diag(varpars)))
  rownames(gear.pars)=c("k","sigma","mode(mesh1)","std_dev(all meshes)") },
  "norm.sca"={
  if(missing(rel.power))
   fit=glm(dat ~ -1 + var3 + var4 + as.factor(lens),family=poisson)
  else
   fit=glm(dat ~ -1 + var3 + var4 + as.factor(lens) + offset(os),family=poisson)
  x=coef(fit)[c("var3","var4")]
  varx=summary(fit)$cov.unscaled[1:2,1:2]
  k1=-x[2]/(2*x[1]); k2=-1/(2*x[1])
  vartemp=msm::deltamethod(list(~-x2/(2*x1),~-1/(2*x1)),x,varx,ses=F)
  pars=c(k1,k2,k1*msizes[1],sqrt(k2*msizes[1]^2))
  form1=as.formula(sprintf("~x1*%f",msize1)) #Deltamethod quirk
  form2=as.formula(sprintf("~sqrt(x2*%f^2)",msize1)) #Deltamethod quirk
  varpars=msm::deltamethod(list(~x1,~x2,form1,form2),c(k1,k2),vartemp,ses=F)
  gear.pars=cbind(estimate=pars,s.e.=sqrt(diag(varpars)))
  rownames(gear.pars)=c("k1","k2","mode(mesh1)","std_dev(mesh1)") },
  "gamma"={
  if(missing(rel.power))
   fit=glm(dat ~ -1 + var4 + var5 + as.factor(lens),family=poisson)
  else
   fit=glm(dat ~ -1 + var4 + var5 + as.factor(lens) + offset(os),family=poisson)
  x=coef(fit)[c("var4","var5")]
  varx=summary(fit)$cov.unscaled[1:2,1:2]
  alpha=x[2]+1; k=-1/x[1]
  vartemp=msm::deltamethod(list(~x2+1,~-1/x1),x,varx,ses=F)
  pars=c(alpha,k,(alpha-1)*k*msizes[1],sqrt(alpha*(k*msizes[1])^2))
  form1=as.formula(sprintf("~(x1-1)*x2*%f",msize1)) #Deltamethod quirk
  form2=as.formula(sprintf("~sqrt(x1*(x2*%f)^2)",msize1)) #Deltamethod quirk
  varpars=msm::deltamethod(list(~x1,~x2,form1,form2),c(alpha,k),vartemp,ses=F)
  gear.pars=cbind(estimate=pars,s.e.=sqrt(diag(varpars)))
  rownames(gear.pars)=c("alpha","k","mode(mesh1)","std_dev(mesh1)")  },
  "lognorm"={
  if(missing(rel.power))
   fit=glm(dat ~ -1 + var6 + var7 + as.factor(lens),family=poisson)
  else
   fit=glm(dat ~ -1 + var6 + var7 + as.factor(lens) + offset(os),family=poisson)
  x=coef(fit)[c("var6","var7")]
  varx=summary(fit)$cov.unscaled[1:2,1:2]
  mu1=-(x[1]-1)/x[2]; sigma=sqrt(1/x[2])
  vartemp=msm::deltamethod(list(~-(x1-1)/x2,~sqrt(1/x2)),x,varx,ses=F)
  pars=c(mu1,sigma,exp(mu1-sigma^2),sqrt(exp(2*mu1+sigma^2)*(exp(sigma^2)-1)))
  varpars=msm::deltamethod(list(~x1,~x2,~exp(x1-x2^2),
                      ~sqrt(exp(2*x1+x2^2)*(exp(x2^2)-1))),c(mu1,sigma),vartemp,ses=F)
  gear.pars=cbind(estimate=pars,s.e.=sqrt(diag(varpars)))
  rownames(gear.pars)=c("mu1(mode log-scale, mesh1)","sigma(std_dev log scale)",
                "mode(mesh1)","std_dev(mesh1)")  },
 stop(paste("\n",rtype, "not recognised, possible curve types are ",
        "\"norm.loc\", \"norm.sca\", \"gamma\", and \"lognorm\"")))
 rselect=rcurves_Millar(rtype,meshsizes,rel.power,pars,plotlens)
 devres=matrix(resid(fit,type="deviance"),nrow(data),ncol(data[,-1]))
 # if(plots[1]) plot.curves(type,plotlens,rselect)
 # if(plots[2]) plot.resids(devres,meshsizes,data[,1])
 g.o.f=c(deviance(fit),sum(resid(fit,type="pearson")^2),fit$df.res,fit$null)
 names(g.o.f)=c("model_dev","Pearson chi-sq","dof","null_dev")
 fit.type=paste(paste(rtype,ifelse(is.null(rel.power),"",": with unequal mesh efficiencies")))
 if(details==FALSE)
  return(list(fit.type=fit.type,gear.pars=gear.pars,fit.stats=g.o.f))
 else
  return(list(
   fit.type=fit.type,gear.pars=gear.pars,fit.stats=g.o.f,devres=devres,rselect=rselect))
}
