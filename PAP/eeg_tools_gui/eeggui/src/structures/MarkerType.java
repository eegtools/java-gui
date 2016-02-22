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
public class MarkerType extends JMatlabStructWrapper{
    
    public String begin_trial;
    public String end_trial;
    public String begin_baseline;
    public String end_baseline;
    
    public MarkerType(){}
    
    public void setJMatData(MLStructure marker)
    {
        begin_trial     = getString(marker, "begin_trial");
        end_trial       = getString(marker, "end_trial");
        begin_baseline  = getString(marker, "begin_baseline");
        end_baseline    = getString(marker, "end_baseline");
    } 

    public MLStructure getJMatData()
    {
        MLStructure marker = new MLStructure("XXX", new int[] {1,1});
        marker.setField("begin_trial", setString(begin_trial));
        marker.setField("end_trial", setString(end_trial));
        marker.setField("begin_baseline", setString(begin_baseline));
        marker.setField("end_baseline", setString(end_baseline));
        return marker;
    } 
    
}
