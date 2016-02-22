/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLCell;
import com.jmatio.types.MLChar;
import com.jmatio.types.MLDouble;

/**
 *
 * @author PHilt
 */
public class ErspParams extends JMatlabStructWrapper{
    
    public double[] cycles;
    public double[] freqs; // line
    public double[] timesout; // line
    public String freqscale;
    public double[] padratio;
    public double[] baseline; // line
    
    public ErspParams(){}
    
    public void setJMatData(MLCell cells)
    {
        MLArray tmp_cycles = cells.get(1);
        cycles = ((MLDouble) tmp_cycles).getArray()[0];
        
        MLArray tmp_freqs = cells.get(3);
        freqs = ((MLDouble) tmp_freqs).getArray()[0];
        
        MLArray tmp_timesout = cells.get(5);
        timesout = ((MLDouble) tmp_timesout).getArray()[0];
        
        freqscale = ((MLChar) cells.get(7)).getString(0);
        
        MLArray tmp_padratio = cells.get(9);
        padratio = ((MLDouble) tmp_padratio).getArray()[0];
        
        MLArray tmp_baseline = cells.get(11);
        baseline = ((MLDouble) tmp_baseline).getArray()[0];
    } 
    
    public MLCell getJMatData(ErspParams ersp_params)
    {
        MLCell cell = new MLCell("XXX",new int[] {1,12});

        MLChar mlchar_cycles = new MLChar("XXX","cycles");
        cell.set(mlchar_cycles,0,0);
        cell.set(setDoubleLineArray(ersp_params.cycles),0,1);
        
        MLChar mlchar_freqs = new MLChar("XXX","freqs");
        cell.set(mlchar_freqs,0,2);
        cell.set(setDoubleLineArray(ersp_params.freqs),0,3);
        
        MLChar mlchar_timesout = new MLChar("XXX","timesout");
        cell.set(mlchar_timesout,0,4);
        cell.set(setDoubleLineArray(ersp_params.timesout),0,5);
        
        MLChar mlchar_freqscale = new MLChar("XXX","freqscale");
        cell.set(mlchar_freqscale,0,6);
        cell.set(setString(ersp_params.freqscale),0,7);
        
        MLChar mlchar_padratio = new MLChar("XXX","padratio");
        cell.set(mlchar_padratio,0,8);
        cell.set(setDoubleLineArray(ersp_params.padratio),0,9);
        
        MLChar mlchar_baseline = new MLChar("XXX","baseline");
        cell.set(mlchar_baseline,0,10);
        cell.set(setDoubleLineArray(ersp_params.baseline),0,11);

        return cell;
    }
    
}
