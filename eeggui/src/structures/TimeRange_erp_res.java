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
class TimeRange_erp_res extends JMatlabStructWrapper{
    
    public double[] s;
    public double[] ms;
    
    public TimeRange_erp_res(){}
    
    public TimeRange_erp_res(MLStructure timeerpres)
    {    
        s = getDoubleArray(timeerpres, "s");
        ms = getDoubleArray(timeerpres, "ms");
    }
    
}
