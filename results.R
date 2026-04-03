se <- function(x){
  return(sd(x, na.rm=T)/sqrt(length(x)))
}
error.bar <- function(x, y, upper, lower=upper, length=0.05,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}
compute_eval_redux <- function(data){
  #plot(c(0,0),c(1,1),type='n', xlim=c(0,6), ylim=c(0,6), xlab="human consensus",ylab= 'ft-gpt')
  fids_list <- unique(data$fid)
  eval_mat<- matrix(nrow=length(fids_list), ncol=17)
  colnames(eval_mat) <- c("hh_spearman","hc_spearman_l3", "gpt_base_spearman_l3", "gpt_spearman_l3","gptc_spearman_l3","hh_pearson","hc_pearson_l3", "gpt_base_pearson_l3", "gpt_pearson_l3","gptc_pearson_l3", "n","hh_mae","hc_mae", "gpt_base_mae", "gpt_spearman_mae","gptc_spearman_mae","gptc_consensus_spearman_mae")
  rownames(eval_mat) <- fids_list
  cordat_gpt <- list()
  k <- 1
  fids <- c()
  for (fid_ in fids_list){
    fids <- c(fids, fid_)
    cors_hh <- c()
    l3_cors_hc <- c()
    l3_cors_gpt_base <- c()
    l3_cors_gpt <- c()
    l3_cors_gpt_calibration <- c()
    
    pcors_hh <- c()
    l3_pcors_hc <- c()
    l3_pcors_gpt_base <- c()
    l3_pcors_gpt <- c()
    l3_pcors_gpt_calibration <- c()
    
    hh_mae <- c()
    hc_mae <- c()
    gpt_base_mae <- c()
    gpt_mae <- c()
    gpt_calibration_mae <- c()
    gpt_calibration_consensus_mae<- c()
    
    l2_cors_hh <- c()
    l2_cors_hc <- c()
    l2_cors_gpt <- c()
    l2_cors_gpt_calibration <- c()
    
    post_data <- data %>% filter(fid==fid_)
    respondents <- post_data$PROLIFIC_PID
    
    for (i in 1:length(respondents)){
      rid1 <- respondents[i]
      
      rid1_dat <- post_data %>% filter(PROLIFIC_PID == rid1)
      l3_consensus <- round(colMeans(post_data %>% filter(PROLIFIC_PID != rid1) %>% dplyr::select(val3_face:val3_tolerance))) #iterate
      l2_consensus <- round(colMeans(post_data  %>% filter(PROLIFIC_PID != rid1)%>% dplyr::select(val2_selftran, val2_conservation, val2_selfenhance, val2_o2c))) #iterate
      
      l3_indo <- as.numeric(rid1_dat %>% dplyr::select(val3_face:val3_tolerance))
      l3_gpt_base <-  as.numeric(rid1_dat %>% dplyr::select(Rating_FACE_SCHWARTZ:Rating_TOLERANCE_SCHWARTZ))
      
      l3_gpt <-  as.numeric(rid1_dat %>% dplyr::select(val3_face.1:val3_tolerance.1))
      l3_gpt_calibration <-  as.numeric(rid1_dat %>% dplyr::select(paste(values,"_yhat",sep='')))
      
      l3_cors_hc <- c(l3_cors_hc, cor(unlist(l3_indo), unlist(l3_consensus), method="spearman"))
      l3_cors_gpt <- c(l3_cors_gpt, cor(unlist(l3_indo), unlist(l3_gpt), method="spearman"))
      l3_cors_gpt_base <- c(l3_cors_gpt_base, cor(unlist(l3_indo), unlist(l3_gpt_base), method="spearman"))
      l3_cors_gpt_calibration <- c(l3_cors_gpt_calibration, cor(unlist(l3_indo), unlist(l3_gpt_calibration), method="spearman"))
      
      l3_pcors_hc <- c(l3_pcors_hc, cor(unlist(l3_indo), unlist(l3_consensus)))
      l3_pcors_gpt <- c(l3_pcors_gpt, cor(unlist(l3_indo), unlist(l3_gpt)))
      l3_pcors_gpt_base <- c(l3_pcors_gpt_base, cor(unlist(l3_indo), unlist(l3_gpt_base)))
      l3_pcors_gpt_calibration <- c(l3_pcors_gpt_calibration, cor(unlist(l3_indo), unlist(l3_gpt_calibration)))
      
      #points(jitter(l3_consensus[1]),jitter(l3_gpt[1]))
      
      l2_indo <- as.numeric(rid1_dat %>% dplyr::select(val2_selftran, val2_conservation, val2_selfenhance, val2_o2c))
      l2_gpt <-  as.numeric(rid1_dat %>% dplyr::select(val2_selftran.1, val2_conservation.1, val2_selfenhance.1, val2_o2c.1))
      l2_cors_hc <- c(l3_cors_hc, cor(unlist(l2_indo), unlist(l2_consensus), method="spearman"))
      l2_cors_gpt <- c(l3_cors_gpt, cor(unlist(l2_indo), unlist(l2_gpt), method="spearman"))
      l2_gpt_calibration <-  as.numeric(rid1_dat %>% dplyr::select(val2_selftran_yhat, val2_conservation_yhat, val2_selfenhance_yhat, val2_o2c_yhat))
      l2_cors_gpt_calibration <- c(l3_cors_gpt_calibration, cor(unlist(l2_indo), unlist(l2_gpt_calibration), method="spearman"))
      
      
      hc_mae <- c(hc_mae,mean(abs(unlist(l3_indo)- unlist(l3_consensus))))
      gpt_base_mae <- c(gpt_base_mae,mean(abs(unlist(l3_consensus)- unlist(l3_gpt_base))))
      gpt_mae <- c(gpt_mae,mean(abs(unlist(l3_consensus)- unlist(l3_gpt))))
      gpt_calibration_consensus_mae <- c(gpt_calibration_consensus_mae,mean(abs(unlist(l3_consensus)- unlist(l3_gpt_calibration))))
      gpt_calibration_mae <- c(gpt_calibration_mae,mean(abs(unlist(l3_indo)- unlist(l3_gpt_calibration))))
      
      for (j in 1:length(respondents)){  
        if (i >j){
          rid2 <- respondents[j]
          rid2_dat <- post_data %>% filter(PROLIFIC_PID == rid2)
          paircor <- cor(unlist(rid1_dat %>% dplyr::select(`val3_face`:`val3_tolerance`)),unlist(rid2_dat %>% dplyr::select(`val3_face`:`val3_tolerance`)), method="spearman")
          pairpcor <- cor(unlist(rid1_dat %>% dplyr::select(`val3_face`:`val3_tolerance`)),unlist(rid2_dat %>% dplyr::select(`val3_face`:`val3_tolerance`)))
          pairmae <- mean(abs(unlist(rid1_dat %>% dplyr::select(`val3_face`:`val3_tolerance`))-unlist(rid2_dat %>% dplyr::select(`val3_face`:`val3_tolerance`))))
          cors_hh <- c(cors_hh, paircor)
          pcors_hh <- c(pcors_hh, pairpcor)
          hh_mae <- c(hh_mae, pairmae)
        }
      }
    }
    
    eval_mat[k,1] <-  mean(cors_hh, na.rm=T)
    eval_mat[k,2] <-  mean(l3_cors_hc, na.rm=T)
    eval_mat[k,3] <-  mean(l3_cors_gpt_base, na.rm=T)
    eval_mat[k,4] <-  mean(l3_cors_gpt, na.rm=T)
    eval_mat[k,5] <-  mean(l3_cors_gpt_calibration, na.rm=T)
    eval_mat[k,6] <-  mean(pcors_hh, na.rm=T)
    eval_mat[k,7] <-  mean(l3_pcors_hc, na.rm=T)
    eval_mat[k,8] <-  mean(l3_pcors_gpt_base, na.rm=T)
    eval_mat[k,9] <-  mean(l3_pcors_gpt, na.rm=T)
    eval_mat[k,10] <-  mean(l3_pcors_gpt_calibration, na.rm=T)
    eval_mat[k,11] <-  length(respondents)
    eval_mat[k,12] <-  mean(hh_mae, na.rm=T)
    eval_mat[k,13] <-  mean(hc_mae, na.rm=T)
    eval_mat[k,14] <-  mean(gpt_base_mae, na.rm=T)
    eval_mat[k,15] <-  mean(gpt_mae, na.rm=T)
    eval_mat[k,16] <-  mean(gpt_calibration_mae, na.rm=T)
    eval_mat[k,16] <-  mean(gpt_calibration_consensus_mae, na.rm=T)
    k <- k+1
    if(k%%100==0){
      print(paste(k, "/ ",length(fids_list) ))
    }
  }
  return(eval_mat)
}

test_dat <- read.csv("data/test_data.csv")
values <- str_replace(colnames(test_dat)[67:85],"_yhat","")

test_eval <- compute_eval_redux(test_dat)
colMeans(test_eval,na.rm=T)

mean_dat <- colMeans(test_eval[,c(1,3:5)],na.rm=T)
se_dat <- apply(test_eval[,c(1,3:5)], 2, se)

pdf("path/to/file/export.pdf", width = 5, height = 8)
b <- barplot(mean_dat,ylim=c(0,0.6),col=c("grey","#EDB5AE", "tomato", "tomato3"), names.arg = c("Human-Human","Human Base GPT","Human FTGPT","Calibrated"), ylab= "Average spearman rank correlation (across posts)")
abline(h=0)
error.bar(b,mean_dat,1.96*se_dat )
legend('topleft', legend=c("Human-Human", "Human-BaseGPT","Human-FTGPT", "Human-CalibratedGPT"),fill=c("grey","#EDB5AE", "tomato", "tomato3"), bty='n')
dev.off()
