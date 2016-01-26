/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLCell;
import com.jmatio.types.MLChar;
import com.jmatio.types.MLStructure;

/**
 *
 * @author PHilt
 */
public class EEGdata extends JMatlabStructWrapper{
    
    public int nch;
    public int nch_eeg;
    public int fs;
    public String eeglab_channels_file_name;
    public String eeglab_channels_file_path;
    public double[] eeg_channels_list;
    public double[] emg_channels_list;
    public double[] emg_channels_list_labels;
    public double[] eog_channels_list;
    public double[] eog_channels_list_labels;
    public double[] no_eeg_channels_list;
    
    public EEGdata()
    {
        
    }
    
    
    public EEGdata(MLStructure eegdata)
    {
                
        nch               = getInt(eegdata,"nch");
        nch_eeg           = getInt(eegdata,"nch_eeg");
        fs                = getInt(eegdata,"fs");
        
        eeglab_channels_file_name  = getString(eegdata, "eeglab_channels_file_name");
        eeglab_channels_file_path  = getString(eegdata, "eeglab_channels_file_path");
        
        
        
        eeg_channels_list = getDoubleArray(eegdata,"eeg_channels_list");
        emg_channels_list = getDoubleArray(eegdata,"emg_channels_list");
        eog_channels_list = getDoubleArray(eegdata,"eog_channels_list");
        
        eeg_channels_list = getDoubleArray(eegdata,"eeg_channels_list");
        eeg_channels_list = getDoubleArray(eegdata,"eeg_channels_list");
        
           
    }    
    
    
}
