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
public class Erp_sta extends JMatlabStructWrapper{
    
    public double pvalue;
    public int num_permutations;
    public int num_tails;
    
    public Erp_sta()
    {
        
    }
    
    
    public Erp_sta(MLStructure erpsta)
    {
        num_permutations    = getInt(erpsta, "num_permutations");
        num_tails           = getInt(erpsta, "num_tails");
        pvalue              = getDouble(erpsta, "pvalue");
    } 
    
}
