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
public class EogParams_TF extends JMatlabStructWrapper{
    
    // public String[][] roi_list; // Create the func in Wrapper: different size of cell
    public String[] roi_names;
    public double[] numroi;
    public double[] nroi;
    
    public DesignEog_TF[] design;
    
    public EogParams_TF(){}
    
    public void setJMatData(MLStructure eogemg)
    {
        //roi_list    = getStringCellMatrix(eogemg, "roi_list");
        roi_names  = getStringCellArray(eogemg, "roi_names");
        numroi     = getDoubleArray(eogemg, "numroi");
        numroi     = getDoubleArray(eogemg, "nroi");
        
        design     = readDesignEog_TF(eogemg, "design");
    }   
    
     private DesignEog_TF[] readDesignEog_TF(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        DesignEog_TF[] arr = new DesignEog_TF[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new DesignEog_TF();
            
            arr[s].which_extrema_curve      = getStringCellMatrix3D(map, "which_extrema_curve");
            arr[s].deflection_polarity_list = getStringCellMatrix(map, "deflection_polarity_list");
            arr[s].min_duration             = getDoubleArray(map, "min_duration");
        }  
        return arr;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        //struct.setField("roi_list",setStringColLineCell(roi_list));
        struct.setField("roi_names",setStringLineArray(roi_names));
        struct.setField("numroi",setDoubleColumnArray(numroi));
        //struct.setField("nroi",setDoubleColumnArray(nroi));
        
        //struct.setField("design",writeDesign(design));

        return struct;
    }
    
}
