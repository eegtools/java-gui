/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import java.io.IOException;
import java.util.Collection;

/**
 *
 * @author alba
 */
public class Preproc {
    
    public String output_folder;
    public String filter_algorithm;
    
    public float ff1_global;
    public int ff2_global;
    
    public String do_notch;
    public int notch_fcenter;
    public int notch_fspan;
    public String notch_remove_armonics;
    
    public float ff1_eeg;
    public int ff2_eeg;
    
    public float ff1_eog;
    public int ff2_eog;
    
    public float ff1_emg;
    public int ff2_emg;
    
    public Rt rt;
      
    public Marker_type marker_type;
    
    public Insert_begin_trial insert_begin_trial;
    
    public Insert_end_trial insert_end_trial;
    
    public int insert_block_trials_per_block;
    public String[][] montage_list;
    
    

     
}
