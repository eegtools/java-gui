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
