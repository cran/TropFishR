#' @title ELEFAN
#'
#' @description Electronic LEngth Frequency ANalysis for estimating growth parameter.
#'
#' @param lfq a list consisting of following parameters:
#' \itemize{
#'   \item \strong{midLengths} midpoints of the length classes,
#'   \item \strong{dates} dates of sampling times (class Date),
#'   \item \strong{catch} matrix with catches/counts per length class (row)
#'      and sampling date (column);
#' }
#' @param Linf_fix numeric; if used the K-Scan method is applied with a fixed
#'    Linf value (i.e. varying K only).
#' @param Linf_range numeric vector with potential Linf values. Default is the
#'    last length class plus/minus 5 cm
#' @param K_range K values for which the score of growth functions should be
#'    calculated
#'    (by default: exp(seq(log(0.1),log(10),length.out = 100)))
#' @param C growth oscillation amplitude (default: 0)
#' @param ts onset of the first oscillation relative to t0 (summer point, default: 0)
#' @param MA number indicating over how many length classes the moving average
#'    should be performed (default: 5, for
#'    more information see \link{lfqRestructure}).
#' @param addl.sqrt Passed to \link{lfqRestructure}. Applied an additional square-root transformation of positive values according to Brey et al. (1988).
#'    (default: FALSE, for more information see \link{lfqRestructure}).
#' @param agemax maximum age of species; default NULL, then estimated from Linf
#' @param flagging.out logical; should positive peaks be flagged out? (Default : TRUE)
#' @param method Choose between the old FiSAT option to force VBGF crossing of a pre-defined
#'    bin (method = "cross"), or the more sophisticated (but computationally expensive) option
#'    to solve for t_anchor via a maximisation of reconstructed score
#'    (default: method = "optimise").
#' @param cross.date Date. For use with \code{method = "cross"}. In combination
#'    with \code{cross.midLength}, defines the date of the crossed bin.
#' @param cross.midLength Numeric. For use with \code{method = "cross"}. In combination
#'    with \code{cross.date}, defines the mid-length of the crossed bin.
#' @param cross.max logical. For use with \code{method = "cross"}. Forces growth function
#'    to cross the bin with maximum positive score.
#' @param hide.progressbar logical; should the progress bar be hidden? (default: FALSE)
#' @param plot logical; indicating if plot with restructured frequencies and growth curves should
#'    be displayed
#' @param contour if used in combination with response surface analysis, contour lines
#'    are displayed rather than the score as text in each field of the score plot. Usage
#'    can be logical (e.g. TRUE) or by providing a numeric which indicates the
#'    number of levels (\code{nlevels} in \code{\link{contour}}). By default FALSE.
#' @param add.values logical. Add values to Response Surface Analysis plot (default: TRUE).
#'    Overridden when \code{contour = TRUE}.
#' @param rsa.colors vector of colors to be used with the Response Surface Analysis plot.
#'    (default: terrain.colors(20))
#' @param plot_title logical; indicating whether title to score plots should be displayed
#'
#' @examples
#' \donttest{
#' data(alba)
#'
#' ### Response Surface Analysis (varies Linf and K) ###
#'
#' # 'cross' method (used in FiSAT)
#' fit1 <- ELEFAN(
#'    lfq = alba, method = "cross",
#'    Linf_range = seq(from = 10, to = 20, length.out = 10),
#'    K_range = exp(seq(from = log(0.1), to = log(2), length.out = 20)),
#'    cross.date = alba$dates[3], cross.midLength = alba$midLengths[4],
#'    contour = TRUE
#' )
#' fit1$Rn_max; unlist(fit1$par)
#' plot(fit1); points(alba$dates[3], alba$midLengths[4], col=2, cex=2, lwd=2)
#'
#' # 'cross' method (bin with maximum score crossed)
#' fit2 <- ELEFAN(
#'    lfq = alba, method = "cross",
#'    Linf_range = seq(from = 10, to = 20, length.out = 20),
#'    K_range = exp(seq(from = log(0.1), to = log(2), length.out = 20)),
#'    cross.max = TRUE,
#'    contour = TRUE
#' )
#' fit2$Rn_max; unlist(fit2$par)
#' plot(fit2); points(alba$dates[7], alba$midLengths[9], col=2, cex=2, lwd=2)
#'
#'
#' # 'optimise' method (default)
#' fit3 <- ELEFAN(
#'    lfq = alba, method = "optimise",
#'    Linf_range = seq(from = 10, to = 20, length.out = 10),
#'    K_range = exp(seq(from = log(0.1), to = log(2), length.out = 20)),
#'    contour = TRUE
#' )
#' fit3$Rn_max; unlist(fit3$par)
#' plot(fit3)
#'
#'
#' ### K-Scan (varies K, Linf is fixed) ###
#'
#' # 'cross' method
#' fit4 <- ELEFAN(
#'    lfq = alba, method = "cross",
#'    Linf_fix = 10,
#'    K_range = round(exp(seq(from = log(0.1), to = log(2), length.out = 50)),2),
#'    cross.date = alba$dates[3], cross.midLength = alba$midLengths[4],
#'    plot = FALSE
#' )
#' fit4$Rn_max; unlist(fit4$par)
#' plot(fit4); points(alba$dates[3], alba$midLengths[4], col=2, cex=2, lwd=2)
#'
#' }
#'
#' @details This functions allows to perform the K-Scan and Response surface
#'    analysis to estimate growth parameters.
#'    It combines the step of restructuring length-frequency data
#'    (\link{lfqRestructure}) followed by the fitting of VBGF
#'    curves through the restructured data (\link{lfqFitCurves}). K-Scan is a
#'    method used to search for the K
#'    parameter with the best fit while keeping the Linf fixed. In contrast,
#'    with response surface analysis
#'    both parameters are estimated and the fits are displayed in a heatmap.
#'    Both methods use \code{\link[stats]{optimise}} to find the best \code{t_anchor} value
#'    for each combination of \code{K} and \code{Linf}. To find out more about
#'    \code{t_anchor}, please refer to the Details description of
#'    \code{\link{lfqFitCurves}}. The score value \code{Rn_max} is comparable with
#'    the score values of the other ELEFAN functions (\code{\link{ELEFAN_SA}} or
#'    \code{\link{ELEFAN_GA}}) when other settings are consistent
#'    (e.g. `MA`, `addl.sqrt`, `agemax`, `flagging.out`).
#'
#' @return A list with the input parameters and following list objects:
#' \itemize{
#'   \item \strong{rcounts}: restructured frequencies,
#'   \item \strong{peaks_mat}: matrix with positive peaks with distinct values,
#'   \item \strong{ASP}: available sum of peaks, sum of posititve peaks which
#'      could be potential be hit by
#'      growth curves,
#'   \item \strong{score_mat}: matrix with scores for each Linf (only Linf_fix)
#'    and K combination,
#'   \item \strong{t_anchor_mat}: maximum age of species,
#'   \item \strong{ncohort}: number of cohorts used for estimation,
#'   \item \strong{agemax}: maximum age of species,
#'   \item \strong{par}: a list with the parameters of the von Bertalanffy growth
#'      function:
#'      \itemize{
#'        \item \strong{Linf}: length infinity in cm,
#'        \item \strong{K}: curving coefficient;
#'        \item \strong{t_anchor}: time point anchoring growth curves in year-length
#'          coordinate system, corrsponds to peak spawning month,
#'        \item \strong{C}: amplitude of growth oscillation
#'          (if \code{seasonalised} = TRUE),
#'        \item \strong{ts}: summer point of oscillation (ts = WP - 0.5)
#'          (if \code{seasonalised} = TRUE),
#'        \item \strong{phiL}: growth performance index defined as
#'          phiL = log10(K) + 2 * log10(Linf);
#'      }
#'   \item \strong{Rn_max}: highest score value
#' }
#'
#' @importFrom grDevices terrain.colors
#' @importFrom graphics abline axis grid image mtext par plot text title
#' @importFrom utils setTxtProgressBar txtProgressBar flush.console
#' @importFrom stats optimise
#'
#' @references
#' Brey, T., Soriano, M., and Pauly, D. 1988. Electronic length frequency analysis: a revised and expanded
#' user's guide to ELEFAN 0, 1 and 2.
#'
#' Pauly, D. 1981. The relationship between gill surface area and growth performance in fish:
#' a generalization of von Bertalanffy's theory of growth. \emph{Meeresforsch}. 28:205-211
#'
#' Pauly, D. and N. David, 1981. ELEFAN I, a BASIC program for the objective extraction of
#' growth parameters from length-frequency data. \emph{Meeresforschung}, 28(4):205-211
#'
#' Pauly, D., 1985. On improving operation and use of ELEFAN programs. Part I: Avoiding
#' "drift" of K towards low values. \emph{ICLARM Conf. Proc.}, 13-14
#'
#' Pauly, D., 1987. A review of the ELEFAN system for analysis of length-frequency data in
#' fish and aquatic invertebrates. \emph{ICLARM Conf. Proc.}, (13):7-34
#'
#' Pauly, D. and G. R. Morgan (Eds.), 1987. Length-based methods in fisheries research.
#' (No. 13). WorldFish
#'
#' Pauly, D. and G. Gaschuetz. 1979. A simple method for fitting oscillating length growth data, with a
#' program for pocket calculators. I.C.E.S. CM 1979/6:24. Demersal Fish Cttee, 26 p.
#'
#' Pauly, D. 1984. Fish population dynamics in tropical waters: a manual for use with programmable
#' calculators (Vol. 8). WorldFish.
#'
#' Quenouille, M. H., 1956. Notes on bias in estimation. \emph{Biometrika}, 43:353-360
#'
#' Somers, I. F., 1988. On a seasonally oscillating growth function. ICLARM Fishbyte 6(1): 8-11.
#'
#' Sparre, P., Venema, S.C., 1998. Introduction to tropical fish stock assessment.
#' Part 1. Manual. \emph{FAO Fisheries Technical Paper}, (306.1, Rev. 2): 407 p.
#'
#' Tukey, J., 1958. Bias and confidence in not quite large samples.
#' \emph{Annals of Mathematical Statistics}, 29: 614
#'
#' Tukey, J., 1986. The future of processes of data analysis. In L. V. Jones (Eds.),
#' The Collected Works of John W. Tukey-philosophy and principles of data analysis:
#' 1965-1986 (Vol. 4, pp. 517-549). Monterey, CA, USA: Wadsworth & Brooks/Cole
#'
#' @export

ELEFAN <- function(lfq, Linf_fix = NA, Linf_range = NA,
                   K_range = exp(seq(log(0.1), log(10), length.out=100)),
                   C = 0, ts = 0,
                   MA = 5, addl.sqrt = FALSE,
                   agemax = NULL, flagging.out = TRUE, method = "optimise",
                   cross.date = NULL, cross.midLength = NULL, cross.max = FALSE,
                   hide.progressbar = FALSE,
                   plot = FALSE, contour = FALSE,
                   add.values = TRUE, rsa.colors = terrain.colors(20),
                   plot_title = TRUE){

  res <- lfq
  classes <- res$midLengths
  catch <- res$catch
  dates <- res$dates
  interval <- (classes[2]-classes[1])/2

  n_samples <- dim(catch)[2]
  n_classes <- length(classes)

  #ts <- WP - 0.5
  if(is.na(Linf_fix) & is.na(Linf_range[1])) Linf_range <- seq(classes[n_classes]-5,classes[n_classes]+5,1) ### OLD: c(classes[n_classes]-5,classes[n_classes]+5)

  # ELEFAN 0
  res <- lfqRestructure(res, MA = MA, addl.sqrt = addl.sqrt)
  catch_aAF_F <- res$rcounts
  peaks_mat <- res$peaks_mat
  ASP <- res$ASP

  if(!is.na(Linf_fix)){
    Linfs <- Linf_fix
  }else Linfs <-  Linf_range
  Ks <- K_range




  # optimisation function
  sofun <- function(tanch, lfq, par, agemax, flagging.out){
    Lt <- lfqFitCurves(lfq,
                       par=list(Linf=par[1], K=par[2], t_anchor=tanch,
                                C=par[4], ts=par[5]),
                       flagging.out = flagging.out, agemax = agemax)
    return(Lt$ESP)
  }

  ESP_tanch_L <- matrix(NA,nrow=length(Ks),ncol=length(Linfs))
  ESP_list_L <- matrix(NA,nrow=length(Ks),ncol=length(Linfs))
  writeLines(paste("Optimisation procuedure of ELEFAN is running. \nThis will take some time. \nThe process bar will inform you about the process of the calculations.",sep=" "))
  flush.console()


  # check that both cross.date and cross.midLength are identified
  if(method == "cross"){
    if(cross.max){ # overrides 'cross.date' and 'cross.midLength'
      max.rcount <- which.max(res$rcounts)
      COMB <- expand.grid(midLengths = rev(rev(res$midLengths)), dates = res$dates)
      cross.date <- COMB$dates[max.rcount]
      cross.midLength <- COMB$midLengths[max.rcount]
    } else {
      if(is.null(cross.date) | is.null(cross.midLength)){
        stop("Must define both 'cross.date' and 'cross.midLength' when 'cross.max' equals FALSE")
      }
    }
  }


  if(!hide.progressbar && interactive()){
    nlk <- prod(dim(ESP_list_L))
    pb <- txtProgressBar(min=1, max=nlk, style=3)
    counter <- 1
  }
  for(li in 1:length(Linfs)){

    ESP_tanch_K <- rep(NA,length(Ks))
    ESP_list_K <- rep(NA,length(Ks))
    for(ki in 1:length(Ks)){

      # determine agemax for Linf and K combination if not already defined
      if(is.null(agemax)){
        agemax.i <- ceiling((1/-Ks[ki])*log(1-((Linfs[li]*0.95)/Linfs[li])))
      } else {
        agemax.i <- agemax
      }


      if(method == "cross"){ # Method for crossing center of a prescribed bin

        t0s <- seq(floor(min(date2yeardec(res$dates)) - agemax.i), ceiling(max(date2yeardec(res$dates))), by = 0.01)

        Ltlut <- Linfs[li] * (1-exp(-(
          Ks[ki]*(date2yeardec(cross.date)-t0s)
          + (((C*Ks[ki])/(2*pi))*sin(2*pi*(date2yeardec(cross.date)-ts)))
          - (((C*Ks[ki])/(2*pi))*sin(2*pi*(t0s-ts)))
        )))

        t_anchor <- t0s[which.min((Ltlut - cross.midLength)^2)] %% 1

        resis <- sofun(tanch = t_anchor, lfq = res, par = c(Linfs[li], Ks[ki], NA, C, ts), agemax = agemax.i, flagging.out = flagging.out)
        ESP_list_K[ki] <- resis
        ESP_tanch_K[ki] <- t_anchor

      }

      # Optimised method for searching best scoring t_anchor
      if(method == "optimise"){
        resis <- optimise(
          f = sofun,
          lower = 0,
          upper = 1,
          lfq = res,
          par = c(Linfs[li], Ks[ki], NA, C, ts),
          agemax = agemax.i,
          flagging.out = flagging.out,
          tol = 0.001,
          maximum = TRUE
        )
        ESP_list_K[ki] <- resis$objective
        ESP_tanch_K[ki] <- resis$maximum
      }

      # update counter and progress bar
      if(!hide.progressbar && interactive()){
        setTxtProgressBar(pb, counter)
        counter <- counter + 1
      }
    }
    ESP_list_L[,li] <- ESP_list_K
    ESP_tanch_L[,li] <- ESP_tanch_K
  }

  dimnames(ESP_list_L) <- list(Ks,Linfs)
  score_mat <- round((10^(ESP_list_L/ASP)) /10,digits = 3)
  rownames(score_mat) <- round(as.numeric(rownames(score_mat)), digits = 2)
  dimnames(ESP_tanch_L) <- list(Ks,Linfs)


  # Graphs
  if(plot && is.na(Linf_fix)){
    plot_dat <- reshape2::melt(score_mat)

    image(
      x = Linfs,
      y = Ks,
      z = t(score_mat), col=rsa.colors,
      ylab = 'K', xlab='Linf'
    )

    if(plot_title)  title('Response surface analysis', line = 1)

    if(contour){
      contour(x = Linfs, y = Ks, z = t(score_mat), add = TRUE)
    } else {
      if(is.numeric(contour)){
        contour(x = Linfs, y = Ks, z = t(score_mat), add = TRUE, nlevels = contour)
      } else {
        if(add.values){
          text(x=plot_dat$Var2,y=plot_dat$Var1,round(as.numeric(plot_dat$value),digits = 2),cex = 0.6)
        }
      }
    }
  } else if(plot){
    if(all(Ks %in% exp(seq(log(0.1),log(10),length.out=100)))){
      K_labels <- c(seq(0.1,1,0.1),2:10)
      K_plot <- log10(Ks)
      K_ats <- log10(K_labels)
    } else {
      K_labels <- Ks
      K_plot <- Ks
      K_ats <- Ks
    }
    phis <- round(log10(K_labels) + 2 * log10(Linfs), digits = 2)

    op <- par(mar = c(12,5,4,2))
    plot(K_plot,score_mat,type = 'l', ylim=c(0,max(score_mat, na.rm = TRUE)*1.4),
         ylab = "Score function", xlab = "Growth constant K (/year)", col = "red", lwd=2,xaxt='n')
    axis(1,at = K_ats,labels = K_labels)
    axis(1,at = K_ats,labels = phis,
         line = 5.5)
    mtext(text = expression(paste("Growth performance index (",phi,"')")),side = 1,line = 8.5)
    grid(nx = 0, NULL, lty = 6, col = "gray40")
    abline(v = K_ats, lty = 6, col = "gray40")
    if(plot_title) title("K-Scan", line = 1)
    par(op)
  }

  Rn_max <- max(score_mat, na.rm = TRUE)[1]
  idxs <- which(score_mat == Rn_max, arr.ind = TRUE)[1,]
  Linfest <- as.numeric(as.character(colnames(score_mat)[idxs[2]]))
  Kest <- as.numeric(as.character(rownames(score_mat)[idxs[1]]))
  tanchest <- as.numeric(as.character(ESP_tanch_L[idxs[1],idxs[2]]))

  # growth performance index
  phiL <- log10(Kest) + 2 * log10(Linfest)

  pars <- list(Linf = Linfest,
               K = Kest,
               t_anchor = tanchest,
               C = C,
               ts = ts,
               phiL = phiL)

  final_res <- lfqFitCurves(lfq = res, par=pars,
                            flagging.out = flagging.out,
                            agemax = agemax)

    ## Results
    res$score_mat <- score_mat
    res$ncohort = final_res$ncohort
    res$agemax = final_res$agemax
    res$par <- pars
    res$fESP <- Rn_max
    res$Rn_max <- Rn_max


  class(res) <- "lfq"
  if(plot){
    plot(res, Fname = "rcounts")
    Lt <- lfqFitCurves(res, par = pars, draw=TRUE)
  }
  return(res)
}
