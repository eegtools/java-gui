/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;
import java.util.Map;
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
    public String emg_output_postfix;
    
    public String[] reference_channels;
    public String[] valid_marker;
    
    public Ch2transform[] ch2transform;
    
    public double[] nch;         //int
    public double[] nch_eeg;     //int
    public double[] fs;          //int
    
    public String eeglab_channels_file_name;
    public String eeglab_channels_file_path;
    
    public double[] eeg_channels_list;
    public double[] emg_channels_list;
    public double[] eog_channels_list;
    public double[] no_eeg_channels_list;

    public String[] eog_channels_list_labels;
    public String[] emg_channels_list_labels;
    
    public Import(){}
    
    public void setJMatData(MLStructure struct)
    {
        acquisition_system          = getString(struct, "acquisition_system");
        original_data_extension     = getString(struct, "original_data_extension");
        original_data_folder        = getString(struct, "original_data_folder");
        original_data_suffix        = getString(struct, "original_data_suffix");
        original_data_prefix        = getString(struct, "original_data_prefix");
        output_folder               = getString(struct, "output_folder");
        output_suffix               = getString(struct, "output_suffix");
        emg_output_postfix          = getString(struct, "emg_output_postfix");
        
        reference_channels          = getStringCellArray(struct, "reference_channels");
        valid_marker                = getStringCellArray(struct, "valid_marker");
        
        ch2transform                = readCh2transform(struct, "ch2transform");
        
        nch               = getDoubleArray(struct,"nch");
        nch_eeg           = getDoubleArray(struct,"nch_eeg");
        fs                = getDoubleArray(struct,"fs");
        
        eeglab_channels_file_name  = getString(struct, "eeglab_channels_file_name");
        eeglab_channels_file_path  = getString(struct, "eeglab_channels_file_path");

        eeg_channels_list = getDoubleArray(struct,"eeg_channels_list");
        emg_channels_list = getDoubleArray(struct,"emg_channels_list");
        eog_channels_list = getDoubleArray(struct,"eog_channels_list");
        no_eeg_channels_list = getDoubleArray(struct,"no_eeg_channels_list");
        
        eog_channels_list_labels = getStringCellArray(struct,"eog_channels_list_labels");
        emg_channels_list_labels = getStringCellArray(struct,"emg_channels_list_labels");        
    }
    
    private Ch2transform[] readCh2transform(MLStructure ch2transf , String field)
    {
        MLStructure a           = (MLStructure) ch2transf.getField(field);
        int[] dim               = a.getDimensions();
        
        Ch2transform[] arr_ch2 = new Ch2transform[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  fac = a.getFields(s);

            arr_ch2[s]              = new Ch2transform();
            arr_ch2[s].type         = getString(fac, "type");
            arr_ch2[s].new_label    = getString(fac, "new_label");
            arr_ch2[s].ch1          = getDoubleArray(fac, "ch1");
            arr_ch2[s].ch2          = getDoubleArray(fac, "ch2");
        }  
        return arr_ch2;
    }

  
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("acquisition_system",setString(acquisition_system));
        struct.setField("original_data_extension",setString(original_data_extension));
        struct.setField("original_data_folder",setString(original_data_folder));
        struct.setField("original_data_suffix",setString(original_data_suffix));
        struct.setField("original_data_prefix",setString(original_data_prefix));
        struct.setField("output_folder",setString(output_folder));
        struct.setField("output_suffix",setString(output_suffix));
        struct.setField("emg_output_postfix",setString(emg_output_postfix));

        struct.setField("reference_channels",setStringLineArray(reference_channels));
        struct.setField("valid_marker",setStringLineArray(valid_marker));

        struct.setField("ch2transform",writeCh2transform(ch2transform));
        
        struct.setField("nch",setDoubleColumnArray(nch));
        struct.setField("nch_eeg",setDoubleColumnArray(nch_eeg));
        struct.setField("fs",setDoubleColumnArray(fs));
        
        struct.setField("eeglab_channels_file_name",setString(eeglab_channels_file_name));
        struct.setField("eeglab_channels_file_path",setString(eeglab_channels_file_path));
        
        struct.setField("eeg_channels_list",setDoubleLineArray(eeg_channels_list));
        struct.setField("emg_channels_list",setDoubleLineArray(emg_channels_list));
        struct.setField("eog_channels_list",setDoubleLineArray(eog_channels_list));
        struct.setField("no_eeg_channels_list",setDoubleLineArray(no_eeg_channels_list));
        
        struct.setField("eog_channels_list_labels",setStringLineArray(eog_channels_list_labels));
        struct.setField("emg_channels_list_labels",setStringLineArray(emg_channels_list_labels));        

        return struct;
    }
    
   
    private MLStructure writeCh2transform(Ch2transform[] ch2transform)
    {
        int dim = ch2transform.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("type", setString(ch2transform[s].type), s);
            struct.setField("new_label", setString(ch2transform[s].new_label), s);
            struct.setField("ch1", setDoubleColumnArray(ch2transform[s].ch1), s);
            struct.setField("ch2", setDoubleColumnArray(ch2transform[s].ch2), s);
        }
        return struct;
    }
    
}
