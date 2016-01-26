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
public class Import extends JMatlabStructWrapper{
    
    public String acquisition_system;
    public String original_data_extension;
    public String original_data_folder;
    public String original_data_suffix;
    public String original_data_prefix;
    public String output_folder;
    public String output_suffix;
    
    // public String emg_output_postfix;
    // public String[] reference_channels;
    // public double[] ch2transform;
    
    public String[] valid_marker;
    
    public Import()
    {
    }

    public Import(MLStructure imp)
    {
        
        acquisition_system  = getString(imp, "acquisition_system");
        original_data_extension  = getString(imp, "original_data_extension");
        original_data_folder  = getString(imp, "original_data_folder");
        original_data_suffix  = getString(imp, "original_data_suffix");
        original_data_prefix  = getString(imp, "original_data_prefix");
        output_folder  = getString(imp, "output_folder");
        output_suffix  = getString(imp, "output_suffix");
        
        //emg_output_postfix = getString(imp,"emg_output_postfix");
        //reference_channels = getStringCellArray(imp,"reference_channels");
        //ch2transform = getDoubleArray(imp,"ch2transform");
        
        valid_marker        = getStringCellArray(imp, "valid_marker");
        
    }    
    
    

}
