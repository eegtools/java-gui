/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;

/**
 *
 * @author PHilt
 */
public class EEGdata extends JMatlabStructWrapper{
    
    public double[] nch;         //int
    public double[] nch_eeg;     //int
    public double[] fs;          //int
    
    public String eeglab_channels_file_name;
    public String eeglab_channels_file_path;
    
    public double[] eeg_channels_list;
    public double[] emg_channels_list;
    public double[] eog_channels_list;
    public double[] no_eeg_channels_list;

    public String eog_channels_list_labels;
    public String emg_channels_list_labels;

    public EEGdata(){}
    
    public void setJMatData(MLStructure eegdata)
    {
        nch               = getDoubleArray(eegdata,"nch");
        nch_eeg           = getDoubleArray(eegdata,"nch_eeg");
        fs                = getDoubleArray(eegdata,"fs");
        
        eeglab_channels_file_name  = getString(eegdata, "eeglab_channels_file_name");
        eeglab_channels_file_path  = getString(eegdata, "eeglab_channels_file_path");

        eeg_channels_list = getDoubleArray(eegdata,"eeg_channels_list");
        emg_channels_list = getDoubleArray(eegdata,"emg_channels_list");
        eog_channels_list = getDoubleArray(eegdata,"eog_channels_list");
        no_eeg_channels_list = getDoubleArray(eegdata,"no_eeg_channels_list");
        
        eog_channels_list_labels = getString(eegdata,"eog_channels_list_labels");
        emg_channels_list_labels = getString(eegdata,"emg_channels_list_labels");
    }
  
    public MLStructure getJMatData()
    {
        MLStructure eegdata = new MLStructure("eegdata",new int[] {1,1});
        
        eegdata.setField("nch",setDoubleColumnArray(nch));
        eegdata.setField("nch_eeg",setDoubleColumnArray(nch_eeg));
        eegdata.setField("fs",setDoubleColumnArray(fs));
        
        eegdata.setField("eeglab_channels_file_name",setString(eeglab_channels_file_name));
        eegdata.setField("eeglab_channels_file_path",setString(eeglab_channels_file_path));
        
        eegdata.setField("eeg_channels_list",setDoubleLineArray(eeg_channels_list));
        eegdata.setField("emg_channels_list",setDoubleLineArray(emg_channels_list));
        eegdata.setField("eog_channels_list",setDoubleLineArray(eog_channels_list));
        eegdata.setField("no_eeg_channels_list",setDoubleLineArray(no_eeg_channels_list));
        
        eegdata.setField("eog_channels_list_labels",setString(eog_channels_list_labels));
        eegdata.setField("emg_channels_list_labels",setString(emg_channels_list_labels));
        
        return eegdata;
    }
    
}
