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
public class SpecParams extends JMatlabStructWrapper{
    
    public String specmode;
    public double[] freqs;
    
    public SpecParams(){}
    
    public void setJMatData(MLCell cells)
    {
        specmode = ((MLChar) cells.get(1)).getString(0);
        freqs = ((MLDouble) cells.get(3)).getArray()[0];
    } 
    
    public MLCell getJMatData(SpecParams spec_param)
    {
        MLCell cell = new MLCell("XXX",new int[] {1,4});
        
        MLChar mlchar1 = new MLChar("XXX","specmode");
        cell.set(mlchar1,0,0);
        cell.set(setString(spec_param.specmode),0,1);
        
        MLChar mlchar2 = new MLChar("XXX","freqs");
        cell.set(mlchar2,0,2);
        cell.set(setDoubleLineArray(spec_param.freqs),0,3);

        return cell;
    }

}
        
