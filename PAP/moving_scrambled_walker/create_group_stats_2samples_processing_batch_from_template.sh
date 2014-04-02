#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
create_start_batch()
{
	# requires these variables: CONTRAST_NAME, COND1, COND2, filetype, ANALYSIS_NAME, IMAGES_DOWNSAMPLING
	#								 arrays		: time_windows, subjects_list
	# 				       paths		: OUTPUT_BATCHES_ROOT_DIR, OUTPUT_STATS_ROOT_DIR, INPUT_IMAGE_DIR

	title1="$COND1 > $COND2"
	title2="$COND2 > $COND1"

	JOBS_LIST=""
	output_batch_start=$OUTPUT_BATCHES_ROOT_DIR/$filetype/$CONTRAST_NAME"_"$filetype"_start.m"   # svn_projects/proj_name/batches/Xmm/raw_ica/wmnefixedsurf/contrast1_wmnefixedsurf_start
	OUTPUT_STATS_PARENT_DIR=$OUTPUT_STATS_ROOT_DIR/$filetype/$CONTRAST_NAME

	for tw in ${time_windows[@]}
	do
		output_batch_job=$OUTPUT_BATCHES_ROOT_DIR/$filetype/$CONTRAST_NAME"_"$filetype"_"$tw"_2ttest_job.m"	
		OUTPUT_STATS_DIR_NAME=$tw
		OUTPUT_STATS_DIR=$OUTPUT_STATS_PARENT_DIR/$OUTPUT_STATS_DIR_NAME

		mkdir -p $OUTPUT_BATCHES_ROOT_DIR/$filetype
		mkdir -p $OUTPUT_STATS_DIR

		cond1_files=""
		cond2_files=""

		for subj in ${subjects_list[@]}
		do
			cond1_files=$cond1_files"\r\'$INPUT_IMAGE_DIR/$subj"_$ANALYSIS_NAME"_"$COND1"_"$filetype"_"$tw".nii,1\'"
			cond2_files=$cond2_files"\r\'$INPUT_IMAGE_DIR/$subj"_$ANALYSIS_NAME"_"$COND2"_"$filetype"_"$tw".nii,1\'"
		done

		PS_OUTPUT_REPLACEMENT="spm_"$CONTRAST_NAME"_"$filetype"_"$tw
		sed -e "s@<OUTPUT_STATS_PARENT_DIR>@$OUTPUT_STATS_PARENT_DIR@g" -e "s@<OUTPUT_STATS_DIR_NAME>@$OUTPUT_STATS_DIR_NAME@g" -e "s@<DEPENDENCY>@$PAIRED@g" -e "s@<COND1>@$cond1_files@g" -e "s@<COND2>@$cond2_files@g" -e "s@<TITLE_C1>@$title1@g" -e "s@<TITLE_C2>@$title2@g" -e "s@<PS_INPUTFILE>@$PS_INPUTFILE@g" -e "s@<PS_OUTPUT_DIR>@$PS_OUTPUT_DIR@g" -e "s@<PS_REPLACEMENT>@$PS_OUTPUT_REPLACEMENT@g" $template_batch_job > $output_batch_job

		JOBS_LIST="$JOBS_LIST \'$output_batch_job\'"
		sed -e "s@X@1@g" -e "s@JOB_LIST@$JOBS_LIST@g" -e "s@<SPM_PATH>@$SPM_PATH@g" $template_batch_start > $output_batch_start
		if [ $EXIT_AFTER_BATCH -eq 1 ]; then echo "exit" >> $output_batch_start; fi
	done

	if [ $DO_EXECUTE -eq 1 ]; then
		cd $OUTPUT_BATCHES_ROOT_DIR/$filetype

		filename=$(basename "$output_batch_start")
		filename="${filename%.*}"
		echo "starting spm with file: $filename"
		$MATLAB_BIN_PATH/matlab -r $filename

		# move ps file to $OUTPUT_STATS_PARENT_DIR
		for tw in ${time_windows[@]}
		do	
				cd $OUTPUT_STATS_PARENT_DIR/$tw
				a=(*.ps);
				newname=${a/spm_/"spm_"$ANALYSIS_NAME"_"$IMAGES_DOWNSAMPLING"_"$filetype"_"$CONTRAST_NAME"_"$tw"__"};
				echo "$a::$newname"
				cp $OUTPUT_STATS_PARENT_DIR/$tw/$a $OUTPUT_STATS_ROOT_DIR/$filetype/$newname
		done
	fi

}
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
#=======================================================================================================================================
WORK_IN_IIT=1

if [ $WORK_IN_IIT -eq 1 ]; then
	local_projects_data_path=/data/projects;
	eegtools_svn_local_path=/data/behavior_lab_svn/behaviourPlatform/EEG_Tools;
	MATLAB_BIN_PATH=/usr/local/MATLAB/R2012b/bin
	SPM_PATH=/data/matlab_toolbox/spm8
else
	local_projects_data_path=/media/data/EEG;
	eegtools_svn_local_path=/media/data/EEG/EEG_Tools;
	MATLAB_BIN_PATH=/usr/local/MATLAB/R2010b/bin
	#### SPM_PATH=/media/data/matlab/..../spm8 ####  completare
fi

#=======================================================
#=======================================================
#=======================================================
# FILE & PATHS
PROJ_NAME=moving_scrambled_walker
PROJ_SCRIPT_DIR=$eegtools_svn_local_path/$PROJ_NAME
PROJ_DATA_DIR=$local_projects_data_path/$PROJ_NAME

ANALYSIS_NAME=OCICA_250_cleanica
IMAGES_DOWNSAMPLING=2mm

INPUT_IMAGE_DIR=$PROJ_DATA_DIR/spm_sources/$IMAGES_DOWNSAMPLING/$ANALYSIS_NAME				# data_projects/proj_name/spm_sources/Xmm/raw_ica
OUTPUT_BATCHES_ROOT_DIR=$PROJ_SCRIPT_DIR/batches/$IMAGES_DOWNSAMPLING/$ANALYSIS_NAME	# svn_projects/proj_name/batches/Xmm/raw_ica
OUTPUT_STATS_ROOT_DIR=$INPUT_IMAGE_DIR/stats																					# data_projects/proj_name/spm_sources/Xmm/raw_ica/stats

# global templates
SPM_TEMPL_DIR=$eegtools_svn_local_path/global_scripts/spm/templates
template_batch_job=$SPM_TEMPL_DIR/stats_2ttest_job.m
template_batch_start=$SPM_TEMPL_DIR/start_template.m

#=======================================================
# PS 
PS_OUTPUT_DIR=$OUTPUT_STATS_ROOT_DIR
PS_INPUTFILE="*.ps"
#=======================================================
# COMMANDS
DO_EXECUTE=1;
EXIT_AFTER_BATCH=1;
PAIRED="1"

# LISTS
declare -a input_postfix_filename=(sloreta_free_vol sloreta_loose_02_surf) # wmne_fixed_surf wmne_free_vol wmne_loose_02_surf sloreta_fixed_surf 
declare -a subjects_list=('alessandra_finisguerra'  'alessia'  'amedeo_schipani'  'antonio2'  'augusta2'  'claudio2'  'denis_giambarrasi'  'eleonora_bartoli'  'giada_fix2'  'jorhabib'  'martina2'  'stefano'  'yannis3');
declare -a time_windows=('P100' 'N200' 'P330' 'N400' 'P500' 'N600');


declare -a contrasts=('SHAPE' 'MOTION' 'SHAPEwithinCentered' 'SHAPEwithinTranslating' 'MOTIONwithinWalker' 'MOTIONwithinScrambled')
declare -a contrasts_cond1=('walker' 'centered' 'cwalker' 'twalker' 'cwalker' 'cscrambled')
declare -a contrasts_cond2=('scrambled' 'translating' 'cscrambled' 'tscrambled' 'twalker' 'tscrambled')
#=======================================================
#=======================================================
#  S T A R T
#=======================================================
#=======================================================

num_constr=${#contrasts[@]};
for filetype in ${input_postfix_filename[@]}
do
	for ((contr=0; contr<$num_constr; contr++))
	do
		CONTRAST_NAME=${contrasts[contr]};
		COND1=${contrasts_cond1[contr]};
		COND2=${contrasts_cond2[contr]};
		create_start_batch
	done
done


