# to be edited according to calling PC local file system
local_projects_data_path='/data/projects';
svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
plugins_path='/mnt/behaviour_lab/Projects/EEG_tools/matlab_toolbox';
#==================================================================================


stat_correction = 'fdr';
stat_threshold = 0.01;

#==================================================================================
  #==================================================================================
  # 2 x 2 design: cwalker, cscrambled, twalker, tscrambled
# two main effects:         m1) centered    vs translating
#                           m2) walker      vs scrambled
#                    
# four posthoc contrasts:   p1) cwalker     vs cscrambled
#                           p2) twalker     vs tscrambled
#                           p3) cwalker     vs twalker
#                           p4) cscrambled  vs tscrambled
#==================================================================================
  # data analysis:
  # visual inspection in brainvision, manually removing part of continous data affected by strong artifacts.
# continous data were filtered 0.1-45 Hz, downsampled @ 250 Hz, ocular artifact automatically were removed by an ICA approach and finally exported in binary format
# continous data were imported in EEGLAB, referenced to CAR, baseline corrected (common to all conditions) then epoched and saved as SET (one for each condition)
# epoched data were processed in EEGLAB for TIMEFREQUENCY analysis
#       ####.. TODO ########
#       claudio aggiungi dettagli sull'analisi fatta
#       ##############..
#       ##############..
# epoched data were processed in BRAINSTORM for source and connectivity analysis
#       a common MRI and electrode montage is used => a common BEM was created and copied to all subjects.
#       for each subject a noise estimation was computed over the first conditions and then copied (since baseline was computed with all conditions) to all other conditions
#       source analysis was performed in three different sources spaces:
#       a)  using the standard 15000 vertices
#       b)  downsampling the cortex to 3000 vertices
#       c)  downsampling the cortex to 500 vertices
#       Time-frequency analysis of specific scouts and in four frequency bands: teta, mu, beta1, beta2
#======================= PROJECT DATA start here ==================================
protocol_name='moving_scrambled_walker';                # must correspond to brainstorm db name
project_folder='moving_scrambled_walker';               # must correspond to 'local_projects_data_path' subfolder name
db_folder_name='bst_db';                                # must correspond to db folder name contained in 'project_folder'    
analysis_name='OCICA_250';                              # subfolder containing the current analysis type (refers to EEG device input data type)
subjects_list=c('alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3');

########################################################### insert names of conditions
conditions_list=c('cwalker', 'twalker', 'cscrambled', 'tscrambled');
######################################################################################

#################### names of the channels used in the project (useful to define rois)
chan_names= c("Fp1","Fp2","F7","F3","Fz","F4","F8","FC5",
              "FC1","FC2","FC6","T7","C3","Cz","C4","T8",
              "TP9","CP5","CP1","CP2","CP6","TP10","P7","P3",
              "Pz","P4","P8","PO9","O1","Oz","O2","PO10",
              "AF7","AF3","AF4","AF8","F5","F1","F2","F6",
              "FT9","FT7","FC3","FC4","FT8","FT10","C5","C1",
              "C2","C6","TP7","CP3","CPz","CP4","TP8","P5",
              "P1","P2","P6","PO7","PO3","POz","PO4","PO8")



#################################################### define regions of interest (ROIS)
roi_list=list(
  c("F6","F8", "AF4"),  #right IFG
  c("F5","F7", "AF3"),  #right IFG
  
  c("CP4"),  #right IPL
  c("CP3"),  #left IPL
  
  
  c("CP6"),  #right pSTS
  c("CP5"),  #left pSTS
  
  c("P6","P8","PO4","PO8","O2"),  #right body area & MT+ (picco circa 120)
  c("P5","P7","PO3","PO7","O1")   #left body area & MT+ (picco circa 120)
  
)
roi_names=c("R_IFG","L_IFG","R_IPL","L_IPL","R_pSTS","L_pSTS","R_bamt","L_bamt")
names(roi_list)=roi_names

# IMPORTANT: roi, anteroposteriority and laterality may be tested on THE SAME derivations 
# (using an interaction term in one whole anova) or for different subsets of derivations. 
# e.g.if also the midline (Xz derivations) are considered, they have not temporal areas 
# (therefore can be considered in the roi analysis but it's more difficult in the interactionanalysis) 
antero_posteriority_list=list(
  c("F6","F8", "AF4","F5","F7","AF3"),  #IFG
  
  c("CP4", "CP3"),  #IPL  
  
  c("CP6", "CP5"),  #pSTS
  
  c("P6","P8","PO4","PO8","O2", "P5","P7","PO3","PO7","O1")   #body area & MT+ (picco circa 120)
  
)
antero_posteriority_names=c("IFG","IPL","pSTS","BA-MT+" )
names(antero_posteriority_list)=antero_posteriority_names  
  
  
laterality_list=list(
  c("F6","F8", "AF4","CP4","CP6","P6","P8","PO4","PO8","O2"),  # RIGHT
  
# it's possible to consider also the MIDLINE, if a diffrent subset of derivations are considered
  
  c("F5","F7", "AF3","CP3","CP5","P5","P7","PO3","PO7","O1")  #LEFT
)
laterality_names=c("RIGHT","LEFT")
names(laterality_list)=laterality_names  




################################################################ define time winows
time_window_list=list(c(100,130),
                  c(140,190),
                  c(200,240),
                  c(250,350),
                  c(400,600)
                  )
time_window_names=c("100_130","140_190","200_240","250_350","400_600")
names(time_window_list)=time_window_names



######################################################################################

  
stat_correction = 'fdr';
stat_threshold = 0.01;
#==================================================================================