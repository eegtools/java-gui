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
public class Design extends JMatlabStructWrapper{
    
    public Designs_de[] design;
    
    public Design(){}

    public void setJMatData(MLStructure designd)
    {
        design = readDesign(designd, "design");
    }
  
    public MLStructure getJMatData()
    {
        MLStructure design = new MLStructure("design",new int[] {1,1});
        
        return design;
    }


    public Designs_de[] readDesign(MLStructure des , String field)
    {
        MLStructure a           = (MLStructure) des.getField(field);
        int[] dim               = a.getDimensions();
        
        Designs_de[] arr_des = new Designs_de[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  des1 = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_des[s]                  = new Designs_de();
            arr_des[s].name             = getString(des1, "name");
            arr_des[s].factor1_name     = getString(des1, "factor1_name");
            arr_des[s].factor2_name     = getString(des1, "factor2_name");
            arr_des[s].factor1_pairing  = getString(des1, "factor1_pairing");
            arr_des[s].factor2_pairing  = getString(des1, "factor2_pairing");
            arr_des[s].factor1_level    = getStringCellArray(des1, "factor1_level");
            arr_des[s].factor2_level    = getStringCellArray(des1, "factor2_level"); 

        }  
        return arr_des;
    }
    
}
