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
public class Subjects extends JMatlabStructWrapper
{

    //public String baseline_file;
    //public String baseline_file_interval_s;
    public String[] list;
    public int numsubj;
    
    public String[] group_names;
    public String[][] groups;
    
    public Subject_su[] data;
    
    public Subjects(){}
    
    public void setJMatData(MLStructure subjs)
    {
        //baseline_file               = getString(subjs, "baseline_file");
        //baseline_file_interval_s    = getString(subjs, "baseline_file_interval_s");
        list                        = getStringCellArray(subjs, "list");
        numsubj                     = getInt(subjs, "numsubj");
        group_names                 = getStringCellArray(subjs, "group_names");
        groups                      = getStringCellMatrix(subjs, "groups");
        
        data                        = readData(subjs, "data");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure subjs = new MLStructure("subjs",new int[] {1,1});
        
        //subjs.setField("baseline_file",setString(baseline_file));
        //subjs.setField("baseline_file_interval_s",setString(baseline_file_interval_s));
        subjs.setField("list",setStringLineArray(list));
        subjs.setField("numsubj",setInt(numsubj));
        subjs.setField("group_names",setStringLineArray(group_names));
        subjs.setField("groups",setStringLineCell(groups));
        
        // data
 
        return subjs;
    }


    public Subject_su[] readData(MLStructure subjs , String field)
    {
        MLStructure a           = (MLStructure) subjs.getField(field);
        int[] dim               = a.getDimensions();
        
        Subject_su[] arr_subjs = new Subject_su[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  subj = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_subjs[s]            = new Subject_su();
            arr_subjs[s].name       = getString(subj, "name");
            arr_subjs[s].handedness = getString(subj, "handedness");
            arr_subjs[s].gender     = getString(subj, "gender");
            arr_subjs[s].group      = getString(subj, "group");
            arr_subjs[s].age        = getInt(subj, "age");

            MLArray ch              = (MLArray) subj.get("bad_ch");
            if(ch.isEmpty())        arr_subjs[s].bad_ch     = null;
            else                    arr_subjs[s].bad_ch     = getStringCellArray(subj, "bad_ch");
        }  
        return arr_subjs;
    }
    
}
