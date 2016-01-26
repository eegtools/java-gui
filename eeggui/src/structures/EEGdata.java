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
        
        /*
        // Test pour extract String[][][] 
        MLCell a     = (MLCell) eegdata.getField("test_3Dmtx");
        int[] dim1   = a.getDimensions();
        int rows1    = dim1[0];      
        int cols1    = dim1[1];
        
        MLCell aa; 
        aa           = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2   = aa.getDimensions();
        int rows2    = dim2[0];      
        int cols2    = dim2[1];
        
        MLCell aaa; 
        aaa           = (MLCell) aa.get(rows2-1,cols2-1);
        int[] dim3   = aaa.getDimensions();
        int rows3    = dim3[0];      
        int cols3    = dim3[1];
        

        MLCell b; 
        String[][][] cellarray = new String[rows1][rows2][rows3];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);
                
                MLCell c; String test;
                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        c = (MLCell) b.get(r2,cols2-1);
                        
                        if (cols3==1)
                        {
                            for (int r3 = 0; r3 < rows3; r3++) 
                            {
                                //test = ((MLChar) c.get(r3,cols3-1)).getString(0);
                                cellarray[r][r2][r3] = ((MLChar) c.get(r3,cols3-1)).getString(0);
                                int rhdjrh = 1;
                            }
                        }
                        
                    }
                }
  
            }
        }
        */
                
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
