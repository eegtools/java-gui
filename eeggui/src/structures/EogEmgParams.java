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
public class EogEmgParams extends JMatlabStructWrapper{
    
    public String[][] roi_list;
    public String[] roi_names;
    public double[] numroi;
    
    public DesignEmgEog[] design;
    
    public EogEmgParams(){}
    
    public void setJMatData(MLStructure eogemg)
    {
        roi_list    = getStringCellMatrix_DiffSizes(eogemg, "roi_list");
        roi_names   = getStringCellArray(eogemg, "roi_names");
        numroi     = getDoubleArray(eogemg, "numroi");
        
        design      = readDesign(eogemg, "design");
    }    
    
    private DesignEmgEog[] readDesign(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        DesignEmgEog[] arr = new DesignEmgEog[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new DesignEmgEog();
            
            arr[s].which_extrema_curve      = getStringCellMatrix(map, "which_extrema_curve");
            arr[s].deflection_polarity_list = getStringCellMatrix(map, "deflection_polarity_list");
            arr[s].min_duration             = getDoubleArray(map, "min_duration");
        }  
        return arr;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("roi_list",setStringColLineCell(roi_list));
        struct.setField("roi_names",setStringLineArray(roi_names));
        struct.setField("numroi",setDoubleColumnArray(numroi));
        
        struct.setField("design",writeDesignEmgEog(design));

        return struct;
    }
    
    private MLStructure writeDesignEmgEog(DesignEmgEog[] design)
    {
        int dim = design.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("which_extrema_curve", setStringColumnCell(design[s].which_extrema_curve), s);
            struct.setField("deflection_polarity_list", setStringColumnCell(design[s].deflection_polarity_list), s);
            struct.setField("min_duration", setDoubleColumnArray(design[s].min_duration), s);
        }
        return struct;
    }

}
