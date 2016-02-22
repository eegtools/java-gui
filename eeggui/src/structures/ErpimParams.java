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
public class ErpimParams extends JMatlabStructWrapper{
        
    public double[] nlines;
    public double[] smoothing;
    
    public ErpimParams(){}
    
    public void setJMatData(MLCell cells)
    {
        nlines = ((MLDouble) cells.get(1)).getArray()[0];
        smoothing = ((MLDouble) cells.get(3)).getArray()[0];
    } 
    
    public MLCell getJMatData(ErpimParams erpimparams)
    {
        MLCell cell = new MLCell("XXX",new int[] {1,4});
        
        MLChar mlchar1 = new MLChar("XXX","nlines");
        cell.set(mlchar1,0,0);
        cell.set(setDoubleLineArray(erpimparams.nlines),0,1);
        
        MLChar mlchar2 = new MLChar("XXX","smoothing");
        cell.set(mlchar2,0,2);
        cell.set(setDoubleLineArray(erpimparams.smoothing),0,3);

        return cell;
    }
    
}
