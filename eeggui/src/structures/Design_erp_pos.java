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
class Design_erp_pos extends JMatlabStructWrapper{
    
    public int min_duration;
    
    public String[][] which_extrema_curve;
    public String[][] deflection_polarity_list;
    
    
    public Design_erp_pos()
    {
    }
    
    
    public Design_erp_pos(MLStructure designerppos)
    { 
    } 
    
}
