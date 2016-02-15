/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;

/**
 *
 * @author PHilt
 */
public class Stats_bs extends JMatlabStructWrapper{
    
    int ttest_abstype;
    
    public Stats_bs()
    {  
    }
    
    public Stats_bs(MLStructure stats_bs)
    {
        ttest_abstype    = getInt(stats_bs, "ttest_abstype");
    }
    
}
