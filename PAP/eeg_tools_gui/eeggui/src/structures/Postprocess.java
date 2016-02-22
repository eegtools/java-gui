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
public class Postprocess extends JMatlabStructWrapper{

    public String[][] roi_list; 
    public String[] roi_names;
    public double[] numroi;
    
    public ErpPostProc erp;
    public EogEmgParams eog;
    public EogEmgParams emg;
    public Mode mode;
    public DesignErp[] design;

    public Postprocess(){}
    
    public void setJMatData(MLStructure struct)
    {
        roi_list    = getStringCellMatrix_DiffSizes(struct, "roi_list");
        roi_names   = getStringCellArray(struct, "roi_names");
        numroi     = getDoubleArray(struct, "numroi"); 
        
        erp         = readErpPostProc(struct, "erp");
        eog         = readEogEmgParams(struct, "eog");
        emg         = readEogEmgParams(struct, "emg");
        mode        = readMode(struct, "mode");
        
        design      = readDesignErp(struct, "design");
    }  
    
    private Mode readMode(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Mode vec = new Mode();
        vec.setJMatData(structs);
        return vec;
    }
    
    private ErpPostProc readErpPostProc(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ErpPostProc vec = new ErpPostProc();
        vec.setJMatData(structs);
        return vec;
    }

    private EogEmgParams readEogEmgParams(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        EogEmgParams vec = new EogEmgParams();
        vec.setJMatData(structs);
        return vec;
    }
   
    private DesignErp[] readDesignErp(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        DesignErp[] arr = new DesignErp[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new DesignErp();
            
            arr[s].group_time_windows          = readGroupTimeWindows(map, "group_time_windows");
            arr[s].subject_time_windows        = readSubjectTimeWindows(map, "subject_time_windows");
            arr[s].which_extrema_curve         = getStringCellMatrix(map, "which_extrema_curve");
            arr[s].deflection_polarity_list    = getStringCellMatrix(map, "deflection_polarity_list");
            arr[s].min_duration                = getDoubleArray(map, "min_duration");
        }  
        return arr;
    }

    private GroupTimeWindows[] readGroupTimeWindows(Map map1, String field)
    {
        MLStructure a           = (MLStructure) map1.get(field);
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
    
    private SubjectTimeWindows[] readSubjectTimeWindows(Map map1, String field)
    {
        MLStructure a           = (MLStructure) map1.get(field);
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
        
        struct.setField("roi_list", setStringColLineCell(roi_list));
        struct.setField("roi_names", setStringLineArray(roi_names));
        
        struct.setField("numroi", setDoubleColumnArray(numroi));
        
        struct.setField("erp", writeErpPostProc(erp));
        struct.setField("eog", writeEogEmgParams(eog));
        struct.setField("emg", writeEogEmgParams(emg));
        struct.setField("mode", writeMode(mode));
        
        struct.setField("design", writeDesignErp(design));
 
        return struct;
    }
    
    private MLStructure writeErpPostProc(ErpPostProc erp)
    {
        MLStructure struct = erp.getJMatData();
        return struct;
    }
    
    private MLStructure writeEogEmgParams(EogEmgParams eogemg)
    {
        MLStructure struct = eogemg.getJMatData();
        return struct;
    }
    
    private MLStructure writeMode(Mode mode)
    {
        MLStructure struct = mode.getJMatData();
        return struct;
    }
    
    private MLStructure writeDesignErp(DesignErp[] design)
    {
        int dim = design.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("which_extrema_curve", setStringColumnCell(design[s].which_extrema_curve), s);
            struct.setField("deflection_polarity_list", setStringColumnCell(design[s].deflection_polarity_list), s);
            
            struct.setField("min_duration", setDoubleColumnArray(design[s].min_duration), s);
            
            struct.setField("group_time_windows", writeGroupTimeWindows(design[s].group_time_windows), s);
            struct.setField("subject_time_windows", writeSubjectTimeWindows(design[s].subject_time_windows), s);
        }
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
