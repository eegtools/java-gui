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
public class Subjects extends JMatlabStructWrapper{

    public String narrowband_file;
    public String baseline_file;
    public String baseline_file_interval_s;
    
    public Data[] data;
    
    public String[] list;
    public String[] group_names;
    public String[][] groups;
    
    public double[] numsubj; //int

    
    public Subjects(){}
    
    public void setJMatData(MLStructure struct)
    {
        narrowband_file             = getString(struct, "narrowband_file");
        baseline_file               = getString(struct, "baseline_file");
        baseline_file_interval_s    = getString(struct, "baseline_file_interval_s");
                
        data                        = readData(struct, "data");
        
        numsubj                     = getDoubleArray(struct, "numsubj");
        
        list                        = getStringCellArray(struct, "list");
        group_names                 = getStringCellArray(struct, "group_names");
        groups                      = getStringCellMatrix(struct, "groups");
    }    
    
    public Data[] readData(MLStructure struct , String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        Data[] arr = new Data[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  dataa = a.getFields(s);

            arr[s]            = new Data();
            arr[s].name       = getString(dataa, "name");
            arr[s].handedness = getString(dataa, "handedness");
            arr[s].gender     = getString(dataa, "gender");
            arr[s].group      = getString(dataa, "group");
            
            arr[s].age        = getDoubleArray(dataa, "age");
            
            arr[s].bad_ch                      = getStringCellArray(dataa, "bad_ch");
            arr[s].baseline_file               = getStringCellArray(dataa, "baseline_file");
            arr[s].baseline_file_interval_s    = getStringCellArray(dataa, "baseline_file_interval_s");
            arr[s].frequency_bands_list        = getStringCellArray(dataa, "frequency_bands_list");

        }  
        return arr;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("narrowband_file",setString(narrowband_file));
        struct.setField("baseline_file",setString(baseline_file));
        struct.setField("baseline_file_interval_s",setString(baseline_file_interval_s));
        
        struct.setField("list",setStringLineArray(list));
        struct.setField("group_names",setStringLineArray(group_names));
        struct.setField("groups",setStringColLineCell(groups));

        struct.setField("numsubj",setDoubleColumnArray(numsubj));
        
        struct.setField("data",writeData(data));
 
        return struct;
    }
    
    private MLStructure writeData(Data[] data)
    {
        int dim = data.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(data[s].name), s);
            struct.setField("group", setString(data[s].group), s);
            struct.setField("gender", setString(data[s].gender), s);
            struct.setField("handedness", setString(data[s].handedness), s);
            
            struct.setField("age", setDoubleColumnArray(data[s].age), s);
            
            struct.setField("bad_ch", setStringLineArray(data[s].bad_ch), s);
            struct.setField("baseline_file", setStringLineArray(data[s].baseline_file), s);
            struct.setField("baseline_file_interval_s", setStringLineArray(data[s].baseline_file_interval_s), s);
            struct.setField("frequency_bands_list", setStringLineArray(data[s].frequency_bands_list), s);
        }
        return struct;
    }
    
}
