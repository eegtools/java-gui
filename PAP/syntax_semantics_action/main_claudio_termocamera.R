require(reshape)
require(ez)
require(multcomp)
require(gplots)

adjust_p_method="holm"

# to be edited according to calling PC local file system
local_projects_data_path='F:/EEG_LAURA';
svn_local_path='F:/EEG_tools/svn';
plugins_path='F:/EEG_tools/matlab_toolbox';
global_scripts_path='F:/EEG_tools/svn/global_scripts';

plot_path='F:/EEG_LAURA'

# sourceDirectory(global_scripts_path)


path_export_r=c('F:/EEG_LAURA/syntax_semantics_action/erp/OCICA_250')
analysis_name='OCICA_250';  
pre_epoching_suffix='_raw_ica_clean';
design_num=1;


#==================================================================================

stat_correction = 'fdr';
stat_threshold = 0.01;

s1=c(rep('Syntax_AC000',8),rep('Syntax_AC00',8));
s2=as.character(c(1,2,4,5,6,7,8,9,10,11,12,13,15,16,18,19));
subjects_list=paste(s1,s2,sep='');
#the number of subjects is that list 
totsub=length(subjects_list);


########################################################### insert names of conditions

# conditions_list=c('syntax_1fm','syntax_2fm','control_syntax_1fm','control_syntax_2fm','semantics_1fm','semantics_2fm','control_semantics_1fm','control_semantics_2fm','all_controls');
conditions_list=c('syntax_1fm','control_syntax_1fm','semantics_1fm','control_semantics_1fm');
totcond=length(conditions_list)
######################################################################################

#################### names of the channels used in the project (useful to define rois)
chan_names= c("Fp1","Fp2","F7","F3","Fz","F4","F8","FC5",
              "FC1","FC2","FC6","T7","C3","Cz","C4","T8",
              "TP9","CP5","CP1","CP2","CP6","TP10","P7","P3",
              "Pz","P4","P8","PO9","O1","Oz","O2","PO10")


#################################################### define regions of interest (ROIS)
roi_list=list(
  c("F7","F3","FC5","FC1"),  #LEFT ANTERIOR
  c("F8","F4","FC6","FC2"),  #RIGHT ANTERIOR  
  c("CP1","CP5","P7","P3"),  #LEFT POSTERIOR
  c("CP2","CP6","P4","P8")  #RIGHT POSTERIOR    
)
roi_names=c("LA","RA","LP","RP")
names(roi_list)=roi_names
        




# IMPORTANT: roi, anteroposteriority and laterality may be tested on THE SAME derivations 
# (using an interaction term in one whole anova) or for different subsets of derivations. 
# e.g.if also the midline (Xz derivations) are considered, they have not temporal areas 
# (therefore can be considered in the roi analysis but it's more difficult in the interactionanalysis) 
antero_posteriority_list=list(
  c("F7","F3","FC5","FC1","F8","F4","FC6","FC2"),  #ANTERIOR  
  c("CP1","CP5","P7","P3","CP2","CP6","P4","P8")  #POSTERIOR      
)
antero_posteriority_names=c("ANTE","POST")
names(antero_posteriority_list)=antero_posteriority_names  
  
  
laterality_list=list(
  c("F8","F4","FC6","FC2","CP2","CP6","P4","P8"),  # RIGHT  
  c("F7","F3","FC5","FC1","CP1","CP5","P7","P3")  #LEFT
)
laterality_names=c("LEFT","RIGHT")
names(laterality_list)=laterality_names  




################################################################ define time winows
# time_windows_list=list(rbind(c(150,200),c(150,300),c(200,400),c(350,600)   ), # semantics
#                        rbind(c(300,600),c(500,800),c(600,800),c(600,1000)   ) # syntax                  
#                   )

#time winows to compare 
time_windows_list=list(rbind(c(50,250),c(300,600),c(600,800)) # semantics and # syntax                  
                  )

# time_windows_names=c("Semantics","Syntax")
time_windows_names=c("Semantics and Syntax")

design_windows_names=list(rbind("50-250","300-600", "600-800"))


  

# names(time_windows_list)=time_windows_names

names(time_windows_list)=time_windows_names

# time_windows_list[[1]][2,]

######################################################################################

  
stat_correction = 'fdr';
stat_threshold = 0.01;
#==================================================================================

data=c()

#for each condition 
for (ncond in 1:totcond){
  #for each subject
  for (nsub in 1:totsub){  
    fileload=paste(path_export_r, '/', subjects_list[nsub],'_', analysis_name , pre_epoching_suffix,'_'    ,  conditions_list[ncond],'.txt',sep='');
    #erp data of all channels for each subject and conditions
    data_sub_cond <- read.table(fileload, header=T, quote="");
     ntimes=dim(data_sub_cond)[1]
     time_ms=as.double(rownames(data_sub_cond));
     condition=rep(conditions_list[ncond],ntimes);
     subject=rep(subjects_list[nsub],ntimes);
     data_sub_cond=cbind(data_sub_cond,condition,subject,time_ms)
    data=rbind(data,data_sub_cond);
  }
}


merp=c()
for(nroi in 1:length(roi_list)){
  
  if (length(roi_list[[nroi]]) > 1){
    verp=rowMeans(data[,roi_list[[nroi]]],na.rm=T)
  }
  else{
    verp=data[,roi_list[[roi]]]
  }
  
  merp=cbind(merp,verp)
}

roi_data=data.frame(data[,c("subject","condition","time_ms")],merp)
roi_data=roi_data[,1:(dim(roi_data)[2])]

all_names=c(c("subject","condition","time_ms"),roi_names)
names(roi_data)=all_names

roi_data$time_window=rep("other",length(roi_data$time_ms))

for(nwin in 1:dim(time_windows_list[[design_num]])[1]){
  roi_data$time_window[roi_data$time_ms > time_windows_list[[design_num]][nwin,][1] &  
                       roi_data$time_ms < time_windows_list[[design_num]][nwin,][2] ] = design_windows_names[[design_num]][nwin]
  
}
  
roi_data=roi_data[roi_data$time_window!="other",]

data_melt=melt(roi_data,id=c("subject","condition","time_ms","time_window"));
names(data_melt)=c("subject","condition","time_ms","time_window","roi","erp")

data_anova=aggregate(data_melt$erp,by=list(data_melt$subject,data_melt$condition,data_melt$time_window,data_melt$roi),FUN=mean)
names(data_anova)=c("subject","condition","time_window","roi","erp")

data_anova$antpos=as.character(data_anova$roi)
data_anova$antpos[data_anova$antpos %in% roi_names[c(1,2)]]=antero_posteriority_names[1]
data_anova$antpos[data_anova$antpos %in% roi_names[c(3,4)]]=antero_posteriority_names[2]


data_anova$later=as.character(data_anova$roi)
data_anova$later[data_anova$later %in% roi_names[c(1,3)]]=laterality_names[1]
data_anova$later[data_anova$later %in% roi_names[c(2,4)]]=laterality_names[2]

data_anova$violation_control=as.character(data_anova$condition)
data_anova$violation_control[data_anova$violation_control %in% c( "control_semantics_1fm", "control_syntax_1fm") ]="control"
data_anova$violation_control[data_anova$violation_control %in% c( "semantics_1fm", "syntax_1fm")]="violation"


data_anova$violation_type=as.character(data_anova$condition)
data_anova$violation_type[data_anova$violation_type %in% c( "control_semantics_1fm","semantics_1fm")]="semantics"
data_anova$violation_type[data_anova$violation_type %in% c( "control_syntax_1fm","syntax_1fm")]="syntax"


#anova per confronto del controllo, tipo di violazione, lateralità, anteroposteriorità, a seconda della finestratura)

anova_1=ezANOVA(
  data = data_anova
  , dv = erp
  , wid = subject
  , within = .(violation_control,violation_type,antpos,later,time_window)
  
)





erp_anova=c(data_anova$erp[data_anova$condition=='syntax_1fm'] - data_anova$erp[data_anova$condition=='control_syntax_1fm'],
            data_anova$erp[data_anova$condition=='semantics_1fm'] - data_anova$erp[data_anova$condition=='control_semantics_1fm']
)






condition_anova=c(as.character(data_anova$condition[data_anova$condition=='syntax_1fm' ]),
                  as.character(data_anova$condition[data_anova$condition=='semantics_1fm' ])) 

subject_anova=c(as.character(data_anova$subject[data_anova$condition=='syntax_1fm' ]),
                as.character(data_anova$subject[data_anova$condition=='semantics_1fm' ])) 

antpos_anova=c(as.character(data_anova$antpos[data_anova$condition=='syntax_1fm' ]),
               as.character(data_anova$antpos[data_anova$condition=='semantics_1fm' ])) 

later_anova=c(as.character(data_anova$later[data_anova$condition=='syntax_1fm' ]),
              as.character(data_anova$later[data_anova$condition=='semantics_1fm' ])) 

time_window_anova=c(as.character(data_anova$time_window[data_anova$condition=='syntax_1fm' ]),
              as.character(data_anova$time_window[data_anova$condition=='semantics_1fm' ])) 
time_window_anova=factor(time_window_anova)
time_window_anova=ordered(time_window_anova,levels(time_window_anova)[c(2,1,3)])


roi_anova=c(as.character(data_anova$roi[data_anova$condition=='syntax_1fm' ]),
                    as.character(data_anova$roi[data_anova$condition=='semantics_1fm' ])) 
roi_anova=factor(roi_anova)
roi_anova=ordered(roi_anova,levels(roi_anova)[c(1,3,2,4)])

data_anova2=data.frame(erp_anova,subject_anova,antpos_anova,later_anova,condition_anova,time_window_anova)




# analisi anova sulle differenze tra violazione e il proprio controllo, e corrisponde al bar plot#
anova_2=ezANOVA(
  data = data_anova2
  , dv = erp_anova
  , wid = subject_anova
  , within = .(condition_anova,antpos_anova,later_anova,time_window_anova)
  
)



mm=by(erp_anova,list(time_window_anova,condition_anova,roi_anova),FUN=mean)
mm=mm[]
ss=by(erp_anova,list(time_window_anova,condition_anova,roi_anova),FUN=sd)/sqrt(totsub)
ss=ss[]
file_barplot=paste(path_export_r , "/","barplot.tif",sep='')
tiff(file_barplot,bg='transparent',width=1000,height=1000)

par(mfrow=c(2,2),mar=c(6,6,6,6),xpd=NA)

yseg=0.7
dyseg=0.05


for (nroi in 1:length(roi_names)){
  xbars=barplot2(t(mm[,,nroi]),plot.ci=T,ci.l=t(mm[,,nroi])-t(ss[,,nroi]),ci.u=t(mm[,,nroi])+t(ss[,,nroi]),beside=T,ylim=c(-1,1),cex.names=2,cex.axis=2,ylab="uV",cex.lab=1,col=c("green","brown"),cex.lab=2) 
  xx=seq(1,9,by=0.1)
  yy=rep(0,length(xx))  
  lines(xx,yy)
  
   if(nroi==1){
      xstars=xbars[c(2,4,6)]
      ystars=rep(-0.8,length(xstars))
      points(xstars,ystars,pch="*",cex=4)
     
      segments(xbars[1], yseg ,xbars[2],yseg, col="blue",lwd=3)
      segments(xbars[5], yseg ,xbars[6],yseg, col="blue",lwd=3)
      
      segments(xbars[2], yseg+dyseg ,xbars[4],yseg+dyseg, col="brown",lwd=3)
      segments(xbars[2], yseg+2*dyseg ,xbars[6],yseg+2*dyseg, col="brown",lwd=3)
      
      
   
   
   }
  
  if(nroi==2){
    segments(xbars[2], yseg+dyseg ,xbars[4],yseg+dyseg, col="brown",lwd=3)
  }
  
  if(nroi==3){
    segments(xbars[2], yseg+dyseg ,xbars[4],yseg+dyseg, col="brown",lwd=3)
  }
  
  if(nroi==4){
    segments(xbars[2], yseg+dyseg ,xbars[4],yseg+dyseg, col="brown",lwd=3)
  }

  
  box()
  mtext(dimnames(mm)[[3]][nroi],3,cex=2)
  if (nroi==1){
    legend(x=10,y=-1.2,c("Sem","Syn"),col=1,pt.bg=c("green","brown"),pch=22,cex=2)
  }

  for (ncond in 1:length(unique(condition_anova))){
    sel_erp=roi_anova==roi_names[nroi] & condition_anova==unique(condition_anova)[ncond]
    t=by(erp_anova[sel_erp],list(time_window_anova[sel_erp],condition_anova[sel_erp]),FUN=function(x) t.test(x)$statistic)
    df=by(erp_anova[sel_erp],list(time_window_anova[sel_erp],condition_anova[sel_erp]),FUN=function(x) t.test(x)$parameter)
    p=p.adjust(by(erp_anova[sel_erp],list(time_window_anova[sel_erp],condition_anova[sel_erp]),FUN=function(x) t.test(x)$p.value),method = adjust_p_method)      
    ttest=cbind(t,df,p)    
    str=paste("ttest_" , roi_names[nroi], "_" , unique(condition_anova)[ncond]  ,"= ttest",sep="")
    eval(parse(text=str))  
  }
  
  
 #CONFRONTO INTRA-FINESTRA
  sel_erp_syn=roi_anova==roi_names[nroi] & condition_anova=="syntax_1fm"
  sel_erp_sem=roi_anova==roi_names[nroi] & condition_anova=="semantics_1fm"
  erp_paired=erp_anova[sel_erp_syn]-erp_anova[sel_erp_sem]
  time_window_paired=as.character(time_window_anova)[sel_erp_syn]  
  t=by(erp_paired,list(time_window_paired),FUN=function(x) t.test(x)$statistic)
  df=by(erp_paired,list(time_window_paired),FUN=function(x) t.test(x)$parameter)
  p=p.adjust(by(erp_paired,list(time_window_paired),FUN=function(x) t.test(x)$p.value),method = adjust_p_method)      
  ttest=cbind(t,df,p)    
  str=paste("ttest_" , roi_names[nroi] ,"_paired"   ,"= ttest",sep="")
  eval(parse(text=str))  

  
  #CONFORNTO INTRA CONDIZIONE
  
  for (ncond in 1:length(unique(condition_anova))){
    sel_erp=roi_anova==roi_names[nroi] & condition_anova==unique(condition_anova)[ncond]
    erp_pairwise=erp_anova[sel_erp]
    time_window_pairwise=time_window_anova[sel_erp]    
    ttest=pairwise.t.test(erp_pairwise,time_window_pairwise, p.adjust.method = adjust_p_method,paired=T)
    str=paste("ttest_" , roi_names[nroi],"_" , unique(condition_anova)[ncond], "_pairwise"   ,"= ttest",sep="")
    eval(parse(text=str))  
    
  }
  
  
    
    
  
}
dev.off()
#####################Post-hoc###############



#######################



sink(paste(path_export_r , "/","preliminary_results.txt",sep=''))

print("#######################################################################")
print("#######################################################################")

print("anova per confronto del controllo, tipo di violazione, lateralità, anteroposteriorità, a seconda della finestratura")
print(anova_1)

print("#######################################################################")
print("#######################################################################")



print("analisi anova sulle differenze tra violazione e il proprio controllo, e corrisponde al bar plot")
print(anova_2)

print("#######################################################################")
print("#######################################################################")


print("confronto con il controllo (cioè le barre sono ==0?)")
for (nroi in 1:length(roi_names)){
  for (ncond in 1:length(unique(condition_anova))){
    
    print(paste("Roi:", roi_names[nroi] ,"Violation:", unique(condition_anova)[ncond]))
    
    str=paste("ttest_" , roi_names[nroi], "_" , unique(condition_anova)[ncond],sep="")
      print(eval(parse(text=str)))
    print("#######################################################################")
  }
}
print("#######################################################################")
print("#######################################################################")

print("confronto intra finestra")
for (nroi in 1:length(roi_names)){
 
    
    print(paste("Roi:", roi_names[nroi] ))
    
    str=paste("ttest_" , roi_names[nroi], "_paired"   ,sep="")
    print(eval(parse(text=str)))
    print("#######################################################################")
}
print("#######################################################################")
print("#######################################################################")
print("confronto intra condizione")
for (nroi in 1:length(roi_names)){
  for (ncond in 1:length(unique(condition_anova))){
    print(paste("Roi:", roi_names[nroi] ,"Violation:", unique(condition_anova)[ncond]))  
    str=paste("ttest_" , roi_names[nroi],"_" , unique(condition_anova)[ncond], "_pairwise"    ,sep="")
    print(eval(parse(text=str)))
    print("#######################################################################")
  }  
}





print("#######################################################################")
print("#######################################################################")







sink()





