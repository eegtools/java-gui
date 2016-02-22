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
public class Data extends JMatlabStructWrapper{
    
    public String name;
    public String group;
    public String gender;
    public String handedness;
    
    public double[] age; //int
    
    public String[] bad_ch;
    public String[] baseline_file;
    public String[] baseline_file_interval_s;
    public String[] frequency_bands_list;
    
    public Data(){}
    
    public void setJMatData(MLStructure data)
    {
        name        = getString(data, "name");
        group       = getString(data, "group");
        gender      = getString(data, "gender");
        handedness  = getString(data, "handedness");
        
        age         = getDoubleArray(data, "age");
        
        bad_ch                      = getStringCellArray(data, "bad_ch");
        baseline_file               = getStringCellArray(data, "baseline_file");
        baseline_file_interval_s    = getStringCellArray(data, "baseline_file_interval_s");
        frequency_bands_list        = getStringCellArray(data, "frequency_bands_list");
    } 

    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX", new int[] {1,1});
        
        struct.setField("name", setString(name));
        struct.setField("group", setString(group));
        struct.setField("gender", setString(gender));
        struct.setField("handedness", setString(handedness));
        
        struct.setField("age", setDoubleColumnArray(age));
        
        struct.setField("bad_ch", setStringLineArray(bad_ch));
        struct.setField("baseline_file", setStringLineArray(baseline_file));
        struct.setField("baseline_file_interval_s", setStringLineArray(baseline_file_interval_s));
        struct.setField("frequency_bands_list", setStringLineArray(frequency_bands_list));
        
        return struct;
    } 

}
