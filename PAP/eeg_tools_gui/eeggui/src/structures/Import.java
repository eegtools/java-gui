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
    
    public Ch2transform_imp[] ch2transform;
    
    
    public Import()
    {
    }
    
    public void setJMatData(MLStructure imp)
    {
        acquisition_system          = getString(imp, "acquisition_system");
        original_data_extension     = getString(imp, "original_data_extension");
        original_data_folder        = getString(imp, "original_data_folder");
        original_data_suffix        = getString(imp, "original_data_suffix");
        original_data_prefix        = getString(imp, "original_data_prefix");
        output_folder               = getString(imp, "output_folder");
        output_suffix               = getString(imp, "output_suffix");
        emg_output_postfix          = getString(imp, "emg_output_postfix");
        
        reference_channels          = getStringCellArray(imp, "reference_channels");
        valid_marker                = getStringCellArray(imp, "valid_marker");
        
        ch2transform                = readCh2transform_imp(imp, "ch2transform");
    }
    
    private Ch2transform_imp[] readCh2transform_imp(MLStructure ch2transf , String field)
    {
        MLStructure a           = (MLStructure) ch2transf.getField(field);
        int[] dim               = a.getDimensions();
        
        Ch2transform_imp[] arr_ch2 = new Ch2transform_imp[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  fac = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_ch2[s]              = new Ch2transform_imp();
            arr_ch2[s].type         = getString(fac, "type");
            arr_ch2[s].new_label    = getString(fac, "new_label");
            arr_ch2[s].ch1          = getInt(fac, "ch1");
            arr_ch2[s].ch2          = getInt(fac, "ch2");
        }  
        return arr_ch2;
    }

  
    public MLStructure getJMatData()
    {
        MLStructure impo = new MLStructure("import",new int[] {1,1});
        
        impo.setField("acquisition_system",setString(acquisition_system));
        impo.setField("original_data_extension",setString(original_data_extension));
        impo.setField("original_data_folder",setString(original_data_folder));
        impo.setField("original_data_suffix",setString(original_data_suffix));
        impo.setField("original_data_prefix",setString(original_data_prefix));
        impo.setField("output_folder",setString(output_folder));
        impo.setField("output_suffix",setString(output_suffix));
        impo.setField("emg_output_postfix",setString(emg_output_postfix));

        impo.setField("reference_channels",setStringLineArray(reference_channels));
        impo.setField("valid_marker",setStringLineArray(valid_marker));

        impo.setField("ch2transform",writeCh2transform_imp(ch2transform));

        return impo;
    }
    
    private MLStructure writeCh2transform_imp(Ch2transform_imp[] ch2transform)
    {
        MLStructure struct_ch2= new MLStructure("ch2transf",new int[] {1,1});
        
        return struct_ch2;
    }
    
}
