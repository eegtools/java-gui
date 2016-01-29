/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLStructure;


/**
 *
 * @author alba
 */
public class Preproc extends JMatlabStructWrapper{
    
    public String output_folder;
    
    public double ff1_global;
    public double ff1_eeg;
    public double ff1_eog;

    public int do_notch;
    public int ff2_global;
    public int ff2_eeg;
    public int ff2_eog;
    public int ff1_emg;
    public int ff2_emg;
    
    
    public Preproc()
    {
        
    }
    
    
    public Preproc(MLStructure prep)
    {
           
        output_folder  = getString(prep, "output_folder");
        
        ff1_global  = getDouble(prep, "ff1_global");
        ff1_eeg  = getDouble(prep, "ff1_eeg");
        ff1_eog  = getDouble(prep, "ff1_eog");
        
        do_notch = getInt(prep, "do_notch");
        ff2_global = getInt(prep, "ff2_global");
        ff2_eeg = getInt(prep, "ff2_eeg");
        ff2_eog = getInt(prep, "ff2_eog");
        ff1_emg = getInt(prep, "ff1_emg");
        ff2_emg = getInt(prep, "ff2_emg");

    }   
     
}
