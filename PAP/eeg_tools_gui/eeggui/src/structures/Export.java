/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLStructure;

/**
 *
 * @author PHilt
 */
public class Export extends JMatlabStructWrapper{
    
    public R_Exp r;

    public Export()
    { 
    }
    
    public void setJMatData(MLStructure exp)
    {
        r = getR_Exp(exp, "r");
    }
  
    public MLStructure getJMatData()
    {
        MLStructure exp = new MLStructure("exp",new int[] {1,1});
        return exp;
    }

    
    private R_Exp getR_Exp(MLStructure rexp, String field)
    {
        MLStructure rexps = (MLStructure) rexp.getField(field);
        R_Exp vec = new R_Exp(rexps);
        return vec;
    }
    

}
