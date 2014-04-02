# script to process data of  moving_scrambled_walker study

#subjects observed 4 kinds of video based on 2 factors:
# 1) translation with two levels: translating/centered
# 2) shape with 2 levels: human walker/scrambled points preserving only kinematics

#clean up
rm(list = ls())

#load required packages
require(XLConnect)
require(multcomp)
require(reshape)
require(ez)
require(gplots)

#define colors
#colonna 7, "verdastro"
cr70=c(155, 187, 89)
cr71=c(235, 241, 221) 
cr72=c(215, 227, 188)
cr73=c(195, 214, 155)
cr74=c(118, 146, 60)
cr75=c(79, 97, 40)

#colonna 8, "viola"
cr80=c(128, 100, 162)
cr81=c(229, 224, 236) 
cr82=c(204, 193, 217)
cr83=c(178, 162, 199)
cr84=c(95, 73, 122)
cr85=c(63, 49, 81)

#colonna 9, "azzurro"
cr90=c(75, 172, 198)
cr91=c(219, 238, 243) 
cr92=c(183, 221, 232)
cr93=c(146, 205, 220)
cr94=c(49, 133, 155)
cr95=c(32, 88, 103)

#colonna 10, "arancione"
cr100=c(247, 150, 70)
cr101=c(253, 234, 218) 
cr102=c(251, 213, 181)
cr103=c(250, 192, 143)
cr104=c(227, 108, 9)
cr105=c(151, 72, 6)

#function to use rgb vectors of colors in R
rgb2 <- function (bb)
{rgb(bb[1],bb[2],bb[3], maxColorValue=255)}


colvec=c(rgb2(cr70),rgb2(cr80),rgb2(cr90),rgb2(cr100))

#define the name of the excel file with the data
xls_file='C:/Users/Claudio/Desktop/moving_scrambled_walker_design1.xls'
#define the name of the file where results will be saved
res_file="moving_scrambled_walker_design1_results.txt"
#define the name of the file where significant ersp are saved
sig_ersp_file="sig_ersp_file.txt"

#load data form excel (important, data are already normalized to pre-stimulus)
raw_data=readWorksheet(loadWorkbook(xls_file),sheet=4)
 
# we need:
#    
# 1) group electrodes in (say) 10 rois
# 2) analysis on temporal patterns for each band in the rois
#    2.1) represent temporal pattern of ersp in the 4 conditions
#    2.2) find (and represent) times whan power is signicantly different from baseline (pre-stimulus) in the 4 conditions
# 3) anaysis on time windows 
#    3.1) considering time windows of interest, calculate average power in each band and roi
#    3.2  compare powers between rois and conditions (time windows?, bands? see how omnibus we want to be) 

#size of the entire data frame
dimtot=dim(raw_data)

chan_names=names(raw_data)[5:dimtot[2]]
cond_names=levels(factor(raw_data$cond))
band_names=levels(factor(raw_data$band))

# old coarse windows
# window_names=c("early","late")
# vt1=c(100,400)
# vt2=c(300,600)

# # new finer windows
window_names=c("100_130","140_190","200_240","250_350","400_600")
# start time of each time window
vt1=c(100,140,200,250,400)
# end time of each time window
vt2=c(130,190,240,350,600)


#define rois 
# Hars M, Hars M, Stam CJ, Calmels C (2011) Effects of Visual Context upon Functional Connectivity during Observation of Biological Motions. PLoS ONE 6(10): e25903

# roi names

roi_list=list(
  c("F4","F8"), # right frontal area
  c("F3","F7"), # left frontal area
  c("FC2","FC4","C2","C4","CP2","CP4","CP6"), # right central area
  c("FC1","FC3","C1","C3","CP1","CP3","CP5"), # right central area
  c("Fz","Cz"), # SMA area,  
  c("FT8","FT10","T8","TP8","TP10"), # right temporal area
  c("FT7","FT9" ,"T7","TP7","TP9"), # left temporal area
  c("P2","P4","P6","P8","PO4","PO8","O2"), # right occipito-parietal area
  c("P1","P3","P5","P7","PO3","PO7","O1") # left occipito-parietal area
)

roi_names=c("RFA","LFA","RCA","LCA","SMA","RTA","LTA","ROP","LOP")
names(roi_list)=roi_names
tsig_all=c()
mpow=c()
for(roi in roi_names){
  vpow=rowMeans(raw_data[,roi_list[[roi]]],na.rm=T)
  mpow=cbind(mpow,vpow)
}

roi_data=data.frame(raw_data[,c("band","sub","cond","times")],mpow)

all_names=c("band","sub","cond","times",roi_names)
names(roi_data)=all_names

for (band_name in band_names){
  
  sel_band=roi_data$band==band_name
  band_data=roi_data[sel_band,]
    
  melt_data=melt(band_data,id=c("band","sub","cond","times"));
  names(melt_data)[5:6]=c("roi","ersp")
  
    
  
###################################################################################################################################
# EXTRACTING TEMPORAL PATTERN OF EACH BAND IN EACH CONDITION AND ROI (FOR EACH BAND, FOR EACH ROI, THE CONDITIONS WILL BE COMPARED) 
###################################################################################################################################  
  
  for(roi_name in roi_names){
      sel_roi=melt_data$roi==roi_name    
      pattern_data=melt_data[sel_roi,]
      p0=match("0",levels(factor(pattern_data$times)))
      
      ########################## PLOT PATTERNS
      file_plot=paste(band_name,"_", roi_name,"_pattern",".tif",sep="")   
      tiff(file_plot,bg='transparent',width=600,height=480)
      interaction.plot(pattern_data$times,pattern_data$cond,pattern_data$ersp, xlab="Times (ms)",ylab="ERSP (dB)",trace.label="Condition",lwd=4,cex=3,legend=F, col=colvec,ylim=c(-5,5),main=paste(roi_name, band_name) ,cex.mai=3,cex.axis=1.1,cex.lab=1.2,axes=F)  
      level_times=levels(factor(pattern_data$times))
      sel_lab=seq(1,length(level_times),by=10)
      axis(1,at=sel_lab,labels=level_times[sel_lab])
      axis(2)
      box()
      
      abline(h=0,lwd=2,lty=2,col="grey")
      abline(v=p0,lwd=2,lty=2)
      legend("topright",cond_names,col=colvec,lty=1:length(cond_names),lwd=4,cex=1.1)
      down=0
      tsig_cond=c()
      for (cond_num in 1:length(cond_names)){
          cond_name=cond_names[cond_num]
          sel_cond=pattern_data$cond==cond_name
          sig_data=pattern_data[sel_cond,]
          sig_data$times2=as.double(sig_data$times)
          sig_data$times2[sig_data$times2<=0] = 0
          tpos=levels(factor(sig_data$times2[sig_data$times2 !=0  ]))
          
          ersp=sig_data$ersp
          times2=factor(sig_data$times2)
          aov_baseline=aov(ersp~times2)
          
          contr=contrMat(table(times2),type="Dunnett",base=1)
          glht_baseline=glht(aov_baseline,linfct = contr)        
          sum_glht_baseline=summary(glht_baseline,test=adjusted("holm"))
          tall=as.double(levels(factor(pattern_data$times)))
          lt=length(tall)
          sig_var_all=rep(NA,lt)
          
          tposn=as.double(tpos)
          mtpos=min(tposn)
          
          selpos=tall>=mtpos
          
          sig_var=sum_glht_baseline$test$pvalues<0.01
          sig_var[sig_var==F]=NA
          sig_var=sig_var*-4.3-down
          
          sig_var_all[selpos]=sig_var
          
          tsig_cond=cbind(tsig_cond,sig_var_all)
          lines(1:lt,sig_var_all,lwd=4,col=colvec[cond_num])
          down=down+0.2
      }
     
      dev.off()
     rownames(tsig_cond)=tall
     colnames(tsig_cond)=cond_names  
    tsig_cond=data.frame(tsig_cond)
      tsig_cond$roi=rep(roi_name,length(tall))
      tsig_cond$band=rep(band_name,length(tall))
     tsig_all=rbind(tsig_all,tsig_cond)
  }


###################################################################################################################################
# EXTRACTING MEAN POWER INSELECTED TIME WINDOWS 
###################################################################################################################################  
 
  for(window_num in 1:length(window_names)){
    window_name=window_names[window_num]
    t1=vt1[window_num]
    t2=vt2[window_num]
    
    window_data=subset(melt_data,times > t1 & times < t2)
    window_data=aggregate(x=window_data$ersp,by=list(window_data$sub,window_data$cond,window_data$roi),FUN=mean)
    names(window_data)=c("sub","cond","roi","ersp")
  
    
    window_data$motion=window_data$cond
    window_data$motion[grep("t",window_data$motion)] = "translating"
    window_data$motion[grep("c",window_data$motion)] = "centered"
    
    window_data$shape=window_data$cond
    window_data$shape[grep("scrambled",window_data$shape)] = "scrambled"
    window_data$shape[grep("walker",window_data$shape)] = "walker"
    window_data$roi_cond=with(window_data, interaction(roi, cond, sep = "_"))
    window_data$roi_motion=with(window_data, interaction(roi, motion, sep = "_"))
    window_data$roi_shape=with(window_data, interaction(roi, shape, sep = "_"))
    
    ersp=window_data$ersp
    roi_cond=factor(window_data$roi_cond)
    roi_motion=factor(window_data$roi_motion)
    roi=factor(window_data$roi)
    motion=factor(window_data$motion)
    shape=factor(window_data$shape)
    cond=factor(window_data$cond)
    roi_shape=window_data$roi_shape    
    sub=window_data$sub
    
    ######################################### ANOVAs POST-HOC

    ############### omnibus anova 
    omnibus_anova=ezANOVA(
      data = window_data
      , dv = ersp
      , wid = sub
      , within = .(roi,motion,shape),
      #, between = group
      type=1
    )    
    str=paste(band_name,"_", window_name,"_" ,"omnibus_anova","= omnibus_anova",sep="")
    eval(parse(text=str))
    
   
    
    
    vp=omnibus_anova$ANOVA$p
    names(vp)=as.character(omnibus_anova$ANOVA$Effect)
    

    if(vp["roi"]<0.05){ 
      ############### aov roi 
      aov_roi=aov(ersp ~ roi)
      str=paste(band_name,"_", window_name,"_" ,"aov_roi","= summary(aov_roi)",sep="")
      eval(parse(text=str))
      glht_aov_roi=summary(glht(aov_roi,linfct=mcp(roi="Tukey")),test=adjusted("holm"))
      str=paste(band_name,"_", window_name,"_" ,"glht_aov_roi","= glht_aov_roi",sep="")
      eval(parse(text=str))
      
      ttest_aov_roi=pairwise.t.test(ersp,roi, p.adjust.method = "holm",paired=T)
      str=paste(band_name,"_", window_name,"_" ,"ttest_aov_roi","= ttest_aov_roi",sep="")
      eval(parse(text=str))
    }
    
    if(vp["motion"]<0.05){
    ############### aov motion 
    aov_motion=aov(ersp ~ motion)
    str=paste(band_name,"_", window_name,"_" ,"aov_motion","= summary(aov_motion)",sep="")
    eval(parse(text=str))
    glht_aov_motion=summary(glht(aov_motion,linfct=mcp(motion="Tukey")),test=adjusted("holm"))
    str=paste(band_name,"_", window_name,"_" ,"glht_aov_motion","= glht_aov_motion",sep="")
    eval(parse(text=str))
    ttest_aov_motion=pairwise.t.test(ersp,motion, p.adjust.method = "holm",paired=T)
    str=paste(band_name,"_", window_name,"_" ,"ttest_aov_motion","= ttest_aov_motion",sep="")
    eval(parse(text=str))
    
    
    }
    
    if(vp["shape"]<0.05){
    ############### aov shape 
    aov_shape=aov(ersp ~ shape)
    str=paste(band_name,"_", window_name,"_" ,"aov_shape","= summary(aov_shape)",sep="")
    eval(parse(text=str))
    glht_aov_shape=summary(glht(aov_shape,linfct=mcp(shape="Tukey")),test=adjusted("holm"))
    str=paste(band_name,"_", window_name,"_" ,"glht_aov_shape","= glht_aov_shape",sep="")
    eval(parse(text=str))
    ttest_aov_shape=pairwise.t.test(ersp,shape, p.adjust.method = "holm",paired=T)
    str=paste(band_name,"_", window_name,"_" ,"ttest_aov_shape","= ttest_aov_shape",sep="")
    eval(parse(text=str))
    }
    
    if(vp["roi:motion"]<0.05){
      ############### aov roi*motion 
      
      # IMPORTANT: roi*motion interaction is generally *weakly* signifincant. 
       
      names_motion=levels(motion)
      dmotion_ersp_motion=ersp[motion==names_motion[2]]-ersp[motion==names_motion[1]]
      
      
      #is the difference between conditions depending from rois?
      roi_motion=as.character(roi[motion==names_motion[2]])
      t=by(dmotion_ersp_motion,list(roi_motion),FUN=function(x) t.test(x)$statistic)
      df=by(dmotion_ersp_motion,list(roi_motion),FUN=function(x) t.test(x)$parameter)
      p=p.adjust(by(dmotion_ersp_motion,list(roi_motion),FUN=function(x) t.test(x)$p.value),method = "holm")      
      ttest_aov_roi_motion=rbind(t,df,p)
      str=paste(band_name,"_", window_name,"_ttest_aov_roi_motion","= ttest_aov_roi_motion",sep="")
      eval(parse(text=str))
      
      
      
      #is the difference between conditions depending from antero-posteior areas (without distinguishing between hemisperes)?
      antpos_motion=as.character(roi[motion==names_motion[2]])
      antpos_motion[grep("FA",antpos_motion)] = "FA"
      antpos_motion[grep("CA",antpos_motion)] = "CA"
      antpos_motion[grep("TA",antpos_motion)] = "TA"
      antpos_motion[grep("OP",antpos_motion)] = "OP"
      antpos_motion[grep("SMA",antpos_motion)] = "SMA"  
      antpos_motion=factor(antpos_motion)
      aov_antpos_motion=aov(dmotion_ersp_motion ~ antpos_motion)      
      contr= c("FA = 0","SMA = 0","CA = 0","TA = 0","OP = 0")
      glht_aov_antpos_motion=summary(glht(aov_antpos_motion,linfct=mcp(antpos_motion=contr)),test=adjusted("holm"))
      str=paste(band_name,"_", window_name,"_glht_aov_antpos_motion","= glht_aov_antpos_motion",sep="")
      eval(parse(text=str)) 
      t=by(dmotion_ersp_motion,list(antpos_motion),FUN=function(x) t.test(x)$statistic)
      df=by(dmotion_ersp_motion,list(antpos_motion),FUN=function(x) t.test(x)$parameter)
      p=p.adjust(by(dmotion_ersp_motion,list(antpos_motion),FUN=function(x) t.test(x)$p.value),method = "holm")      
      ttest_aov_antpos_motion=rbind(t,df,p)
      str=paste(band_name,"_", window_name,"_ttest_aov_antpos_motion","= ttest_aov_antpos_motion",sep="")
      eval(parse(text=str))
      
      
      #is the difference between conditions depending from laterality areas (without distinguishing between antero-posteriorities)?
      later_motion=as.character(roi[motion==names_motion[2]])
      later_motion[grep("L",later_motion)] = "LEFT"
      later_motion[grep("R",later_motion)] = "RIGHT"
      ttest_later_motion=t.test(dmotion_ersp_motion[later_motion=="LEFT"],dmotion_ersp_motion[later_motion=="RIGHT"],paired=T)
      str=paste(band_name,"_", window_name,"_ttest_later_motion","= ttest_later_motion",sep="")
      eval(parse(text=str))
      #is the difference between rois depending from condition?
      names_motion=levels(motion)  
      for (name_motion in names_motion){
        sel_motion=motion==name_motion
        ersp_sel_motion=ersp[sel_motion]
        roi_sel_motion=factor(roi[sel_motion])
        aov_roi_sel_motion=aov(ersp_sel_motion ~ roi_sel_motion)
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_aov_roi_sel_motion","=summary(aov_roi_sel_motion)",sep="")
        eval(parse(text=str))    
        glht_aov_roi_sel_motion=summary(glht(aov_roi_sel_motion,linfct=mcp(roi_sel_motion="Tukey")),test=adjusted("holm"))
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_glht_aov_roi_sel_motion","= glht_aov_roi_sel_motion",sep="")
        eval(parse(text=str))
        ttest_aov_roi_sel_motion=pairwise.t.test(ersp_sel_motion,roi_sel_motion, p.adjust.method = "holm",paired=T)
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_sel_motion","= ttest_aov_roi_sel_motion",sep="")
        eval(parse(text=str))
        
        sel_left=grep("L",roi_sel_motion)
        sel_right=grep("R",roi_sel_motion)        
        dhemi_ersp=ersp_sel_motion[sel_left]-ersp_sel_motion[sel_right]
        roi_dhemi=as.character(roi_sel_motion[sel_left])
        roi_dhemi[grep("FA",roi_dhemi)] = "FA"
        roi_dhemi[grep("CA",roi_dhemi)] = "CA"
        roi_dhemi[grep("TA",roi_dhemi)] = "TA"
        roi_dhemi[grep("OP",roi_dhemi)] = "OP"
        roi_dhemi=factor(roi_dhemi)
        aov_roi_dhemi=aov(dhemi_ersp ~ roi_dhemi)
        glht_aov_roi_dhemi=summary(glht(aov_roi_dhemi,linfct=mcp(roi_dhemi ="Tukey")),test=adjusted("holm"))
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_glht_aov_roi_dhemi","= glht_aov_roi_dhemi",sep="")
        eval(parse(text=str))
        
        ttest_aov_roi_dhemi=pairwise.t.test(dhemi_ersp,roi_dhemi, p.adjust.method = "holm",paired=T)
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_dhemi","= ttest_aov_roi_dhemi",sep="")
        eval(parse(text=str))
        
      
        t=by(dhemi_ersp,list(roi_dhemi),FUN=function(x) t.test(x)$statistic)
        df=by(dhemi_ersp,list(roi_dhemi),FUN=function(x) t.test(x)$parameter)
        p=p.adjust(by(dhemi_ersp,list(roi_dhemi),FUN=function(x) t.test(x)$p.value),method = "holm")      
        ttest_aov_roi_dhemi2=rbind(t,df,p)
        str=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_dhemi2","= ttest_aov_roi_dhemi2",sep="")
        eval(parse(text=str))
        
        
        
      }
    }
  
    
    
    
    ########################################## BARPLOTS     
    ver_lim=c(-5,5)
    
#     if(window_name=="early"){
#       ver_lim=c(-5,5)
#     }
#     if(window_name=="late"){
#       ver_lim=c(-5,1)
#     }
      
    ################## barplot motion and roi
    file_plot=paste(band_name,"_","motion_" ,window_name,"_barplot",".tif",sep="")   
    tiff(file_plot,bg='transparent',width=550,height=480)    
    m_roi_motion=by(ersp,list(motion,roi),FUN=mean)
    sd_roi_motion=by(ersp,list(motion,roi),FUN=sd)/sqrt(13)
    barplot2(m_roi_motion,plot.ci=T,ci.l=m_roi_motion-sd_roi_motion,ci.u=m_roi_motion+sd_roi_motion,beside=T,ylim=ver_lim,cex.names=1.3,cex.axis=1.3,ylab="ERSP (dB)",cex.lab=1.3,main=paste(window_name,band_name),cex.main=2) 
    box()
    abline(h=0)
    legend("bottomleft",rownames(m_roi_motion),pt.bg=c("red","yellow"),pch=22,cex=1.5)
    dev.off()
    
    ################## barplot shape and roi
    file_plot=paste(band_name,"_","shape_" ,window_name,"_barplot",".tif",sep="")   
    tiff(file_plot,bg='transparent',width=550,height=480)    
    m_roi_shape=by(ersp,list(shape,roi),FUN=mean)
    sd_roi_shape=by(ersp,list(shape,roi),FUN=sd)/sqrt(13)
    barplot2(m_roi_shape,plot.ci=T,ci.l=m_roi_shape-sd_roi_shape,ci.u=m_roi_shape+sd_roi_shape,beside=T,ylim=ver_lim,cex.names=1.3,cex.axis=1.3,ylab="ERSP (dB)",cex.lab=1.3,main=paste(window_name,band_name),cex.main=2,col=c("violet","cyan")) 
    box()
    abline(h=0)
    legend("bottomleft",rownames(m_roi_shape),pt.bg=c("violet","cyan"),pch=22,cex=1.5)
    dev.off()
    
    ################## barplot condition and roi
    file_plot=paste(band_name,"_","cond_" ,window_name,"_barplot",".tif",sep="")   
    tiff(file_plot,bg='transparent',width=550,height=480)    
    m_roi_cond=by(ersp,list(cond,roi),FUN=mean)
    sd_roi_cond=by(ersp,list(cond,roi),FUN=sd)/sqrt(13)
    barplot2(m_roi_cond,plot.ci=T,ci.l=m_roi_cond-sd_roi_cond,ci.u=m_roi_cond+sd_roi_cond,beside=T,ylim=ver_lim,cex.names=1.3,cex.axis=1.3,ylab="ERSP (dB)",cex.lab=1.3,col=colvec,main=paste(window_name,band_name),cex.main=2) 
    box()
    abline(h=0)
    legend("bottomleft",rownames(m_roi_cond),pt.bg=colvec,pch=22,cex=1.1)
    dev.off()
  }
}

####################################################################################
#PRINT RESULTS ON A TEXT FILE
####################################################################################
sink(res_file)
for(window_name in window_names){  
  print("##########################################")
  print(paste("#",window_name,"time window"))  
  print("##########################################")
  
  for(band_name in band_names){
    print("########################")
    print(band_name)
    print("########################")
    
    print("############## OMNIBUS ANOVA")
    var_test=paste( band_name,"_", window_name,"_", "omnibus_anova",sep="")
    print(var_test)
    print(eval(parse(text=var_test)))    
    
    
    var_test=paste(band_name,"_", window_name,"_aov_roi",sep="")
    if (exists(var_test)){
      print("############## ROI")    
      print("ANOVA")
      print(var_test)
      print(eval(parse(text=var_test)))
      
      var_glht_aov=paste(band_name,"_", window_name,"_glht_aov_roi",sep="")
      print("CONTRAST POST-HOC")
      print(var_glht_aov)
      print(eval(parse(text=var_glht_aov)))
      
      var_ttest_aov=paste(band_name,"_", window_name,"_ttest_aov_roi",sep="")
      print("PAIRED T-TEST POST-HOC")
      print(var_ttest_aov)
      print(eval(parse(text=var_ttest_aov)))
      
      
    }
    
    var_test=paste(band_name,"_", window_name,"_aov_shape",sep="")
    if (exists(var_test)){      
      print("############## SHAPE")    
      print("ANOVA")
      print(var_test)
      print(eval(parse(text=var_test)))
      
      var_glht_aov=paste(band_name,"_", window_name,"_glht_aov_shape",sep="")
      print("CONTRAST POST-HOC")
      print(var_glht_aov)
      print(eval(parse(text=var_glht_aov)))
      
      var_ttest_aov=paste(band_name,"_", window_name,"_ttest_aov_shape",sep="")
      print("PAIRED T-TEST POST-HOC")
      print(var_ttest_aov)
      print(eval(parse(text=var_ttest_aov))) 
    }  
    
    var_test=paste(band_name,"_", window_name,"_aov_motion",sep="")
    if (exists(var_test)){      
      print("############## MOTION")    
      print("ANOVA")
      print(var_test)
      print(eval(parse(text=var_test)))
      
      var_glht_aov=paste(band_name,"_", window_name,"_glht_aov_motion",sep="")
      print("CONTRAST POST-HOC")
      print(var_glht_aov)
      print(eval(parse(text=var_glht_aov)))
      
      var_ttest_aov=paste(band_name,"_", window_name,"_ttest_aov_motion",sep="")
      print("PAIRED T-TEST POST-HOC")
      print(var_ttest_aov)
      print(eval(parse(text=var_ttest_aov)))
      
    }  
    
    var_test=paste(band_name,"_", window_name,"_ttest_aov_roi_motion",sep="")
    if (exists(var_test)){      
      print("############## ROI * MOTION")    
      
      print("##### COMPARING ROIs BETWEEN MOTIONS")
      
      var_ttest_aov=paste(band_name,"_", window_name,"_ttest_aov_roi_motion",sep="")
      print("DIFFERENCE POST-HOC (PAIRED T-TEST)")
      print(paste ("HP0:", names_motion[2], "-", names_motion[1],"= 0"))
      print(var_ttest_aov)
      print(eval(parse(text=var_ttest_aov)))
      print("P value adjustment method: holm ")
      
      
      
      
      print("##### COMPARING ANTERO-POSTERIORIY BETWEEN MOTIONS (EXCLUDING HEMISPHERES)")
      
      var_ttest_aov=paste(band_name,"_", window_name,"_ttest_aov_antpos_motion",sep="")
      print("DIFFERENCE POST-HOC (PAIRED T-TEST)")
      print(paste ("HP0:", names_motion[2], "-", names_motion[1],"= 0"))
      print(var_ttest_aov)
      print(eval(parse(text=var_ttest_aov)))
      print("P value adjustment method: holm ")
      
      print("##### COMPARING HEMISPERES BETWEEN MOTIONS (EXCLUDING ANTERO-POSTERIORIES)")
      var_ttest=paste(band_name,"_", window_name,"_ttest_later_motion",sep="")
      print("DIFFERENCE POST-HOC (PAIRED T-TEST)")
      print(var_ttest)
      print(eval(parse(text=var_ttest)))
      print("P value adjustment method: holm ")
      
      
#       print("##### RAW ANTERO-POSTERIORIY (POs vs OTHERS)")
#       print("DIFFERENCE POST-HOC (CONTRAST)")
#       print(var_test)
#       print(eval(parse(text=var_test)))
      
      
      
      
      
      
      print("TOPOGRAPHICAL INTRA-CONDITION  POST-HOC")
      for (name_motion in names_motion){
        print(name_motion)
      
        var_aov=paste(band_name,"_", window_name,"_" ,name_motion,"_aov_roi_sel_motion",sep="")  
      
        print("ANOVA")
        print(var_aov)
        print(eval(parse(text=var_aov)))
        
        var_glht_aov=paste(band_name,"_", window_name,"_" ,name_motion,"_glht_aov_roi_sel_motion",sep="")
        print("CONTRAST POST-HOC")
        print(var_glht_aov)
        print(eval(parse(text=var_glht_aov)))
        
        var_ttest_aov=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_sel_motion",sep="")
        print("PAIRWISE T-TEST POST-HOC")
        print(var_ttest_aov)
        print(eval(parse(text=var_ttest_aov)))
        
        var_ttest_aov=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_dhemi",sep="")
        print("PAIRWISE T-TEST POST-HOC")
        print(var_ttest_aov)
        print(eval(parse(text=var_ttest_aov)))
        
        var_ttest_aov=paste(band_name,"_", window_name,"_" ,name_motion,"_ttest_aov_roi_dhemi2",sep="")
        print("PAIRWISE T-TEST POST-HOC")
        print(var_ttest_aov)
        print(eval(parse(text=var_ttest_aov)))
        

        
        
        
      }
    }
  } 
}

sink()
write.table(tsig_all,file=sig_ersp_file,quote=F,sep="\t")