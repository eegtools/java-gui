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
public class R_Exp extends JMatlabStructWrapper{
    
    Freq_R_Exp[] bands;

    
    public R_Exp()
    {
        
    }
    
    
    public R_Exp(MLStructure rexp)
    {
      // bands = readFreq_R_Exp(rexp, "bands");
    } 
    
    
    /*
    public Freq_R_Exp[] readFreq_R_Exp(MLStructure frexp , String field)
    {
        MLStructure a           = (MLStructure) frexp.getField(field);
        int[] dim               = a.getDimensions();
        
        Freq_R_Exp[] arr_exp = new Freq_R_Exp[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray> frexps = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_exp[s]            = new Freq_R_Exp();
            arr_exp[s].name       = getString(frexps, "handedness");
            arr_exp[s].freq       = getDoubleArray(frexps, "name");
        }  
        return arr_exp;
    }
    */
    
}
