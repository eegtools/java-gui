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
public class DesignErsp extends JMatlabStructWrapper{
    
    public GroupTimeWindows_TF[] group_time_windows;
    public SubjectTimeWindows[] subject_time_windows;
    
    public String[][][] which_extrema_curve_continuous;
    public String[][] group_time_windows_continuous;
    public String[][][] which_extrema_curve_tw;
    public String[][][] deflection_polarity_list;
    
    public double[] min_duration;
    
    public DesignErsp(){}
    
    public void setJMatData(MLStructure struct)
    {
        which_extrema_curve_continuous  = getStringCellMatrix3D(struct, "which_extrema_curve_continuous");
        group_time_windows_continuous   = getStringCellMatrix(struct, "group_time_windows_continuous");
        which_extrema_curve_tw          = getStringCellMatrix3D(struct, "which_extrema_curve_tw");
        deflection_polarity_list        = getStringCellMatrix3D(struct, "deflection_polarity_list");
        
        min_duration                = getDoubleArray(struct, "min_duration");
        
        group_time_windows          = readGroupTimeWindows_TF(struct, "group_time_windows");
        subject_time_windows        = readSubjectTimeWindows(struct, "subject_time_windows");
    }    
    
    private GroupTimeWindows_TF[] readGroupTimeWindows_TF(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        GroupTimeWindows_TF[] arr = new GroupTimeWindows_TF[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new GroupTimeWindows_TF();
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
        
        struct.setField("which_extrema_curve_continuous", setStringTripleColumnCell(which_extrema_curve_continuous));
        struct.setField("group_time_windows_continuous", setStringColLineCell(group_time_windows_continuous));
        struct.setField("which_extrema_curve_tw", setStringTripleColumnCell(which_extrema_curve_tw));
        struct.setField("deflection_polarity_list", setStringTripleColumnCell(deflection_polarity_list));
        
        struct.setField("min_duration", setDoubleColumnArray(min_duration));
        
        struct.setField("group_time_windows", writeGroupTimeWindows_TF(group_time_windows));
        struct.setField("subject_time_windows", writeSubjectTimeWindows(subject_time_windows));

        return struct;
    }
    
     private MLStructure writeGroupTimeWindows_TF(GroupTimeWindows_TF[] groupe_tw)
    {
        int dim = groupe_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(groupe_tw[s].name), s);
            
            struct.setField("min", setDoubleColumnArray(groupe_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(groupe_tw[s].max), s);
            
            struct.setField("ref_roi", setStringLineCell(groupe_tw[s].ref_roi), s);
        }
        return struct;
    }
     
      private MLStructure writeSubjectTimeWindows(SubjectTimeWindows[] subject_tw)
    {
        int dim = subject_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("min", setDoubleColumnArray(subject_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(subject_tw[s].max), s);
        }
        return struct;
    }
    
}
