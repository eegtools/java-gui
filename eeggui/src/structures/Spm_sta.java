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
public class Spm_sta extends JMatlabStructWrapper{
    
    public double pvalue;
    public String correction;
    
    public Spm_sta()
    {
    }
    
    public Spm_sta(MLStructure spmsta)
    {
        pvalue      = getDouble(spmsta, "pvalue");
        correction  = getString(spmsta, "correction");
    } 
    
    
    
}
    
