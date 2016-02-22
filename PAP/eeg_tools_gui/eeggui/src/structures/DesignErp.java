/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLStructure;
import java.util.Map;

/**
 *
 * @author PHilt
 */
public class DesignErp extends JMatlabStructWrapper{
    
    public GroupTimeWindows[] group_time_windows;
    public SubjectTimeWindows[] subject_time_windows;
    
    public String[][] which_extrema_curve;
    public String[][] deflection_polarity_list;
    public double[] min_duration;
    
    public DesignErp(){}
    
    public void setJMatData(MLStructure struct)
    {
        which_extrema_curve         = getStringCellMatrix(struct, "which_extrema_curve");
        deflection_polarity_list    = getStringCellMatrix(struct, "deflection_polarity_list");
        min_duration                = getDoubleArray(struct, "min_duration");
        
        group_time_windows          = readGroupTimeWindows(struct, "group_time_windows");
        subject_time_windows        = readSubjectTimeWindows(struct, "subject_time_windows");
    }    
    
    private GroupTimeWindows[] readGroupTimeWindows(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        GroupTimeWindows[] arr = new GroupTimeWindows[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new GroupTimeWindows();
            
            arr[s].name    = getString(map, "name");
            arr[s].min     = getDoubleArray(map, "min");
            arr[s].max     = getDoubleArray(map, "max");
        }  
        return arr;
    }
    
    private SubjectTimeWindows[] readSubjectTimeWindows(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        SubjectTimeWindows[] arr = new SubjectTimeWindows[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new SubjectTimeWindows();
            
            arr[s].min     = getDoubleArray(map, "min");
            arr[s].max     = getDoubleArray(map, "max");
        }  
        return arr;
    }
    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("which_extrema_curve",setStringColumnCell(which_extrema_curve));
        struct.setField("deflection_polarity_list",setStringColumnCell(deflection_polarity_list));
        struct.setField("min_duration",setDoubleColumnArray(min_duration));
        
        struct.setField("group_time_windows",writeGroupTimeWindows(group_time_windows));
        struct.setField("subject_time_windows",writeSubjectTimeWindows(subject_time_windows));

        return struct;
    }
    
    private MLStructure writeGroupTimeWindows(GroupTimeWindows[] group_tw)
    {
        int dim = group_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(group_tw[s].name), s);
            struct.setField("min", setDoubleColumnArray(group_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(group_tw[s].max), s);
        }
        return struct;
    }
    
    private MLStructure writeSubjectTimeWindows(SubjectTimeWindows[] subj_tw)
    {
        int dim = subj_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("min", setDoubleColumnArray(subj_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(subj_tw[s].max), s);
        }
        return struct;
    }
    
}
