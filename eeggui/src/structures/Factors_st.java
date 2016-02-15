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
class Factors_st extends JMatlabStructWrapper{
    
    public String factor;
    public String level;
    public String[] file_match;
    
    public Factors_st(){}
    
    public Factors_st(MLStructure fac)
    {    
        factor      = getString(fac, "factor");
        level       = getString(fac, "level");
        file_match  = getStringCellArray(fac, "file_match");
    }
    
}
