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
public class Rt extends JMatlabStructWrapper{

    public String eve1_type;
    public String eve2_type;
    public double[] output_folder;
    public AllowedTwMs allowed_tw_ms;
    
    public Rt(){}
    
    public void setJMatData(MLStructure srt)
    {
        eve1_type       = getString(srt, "eve1_type");
        eve2_type       = getString(srt, "eve2_type");
        output_folder   = getDoubleArray(srt, "output_folder");
        allowed_tw_ms   = readAllowedTwMs(srt, "allowed_tw_ms");
    } 
    
    private AllowedTwMs readAllowedTwMs(MLStructure altms, String field)
    {
        MLStructure saltms = (MLStructure) altms.getField(field);
        AllowedTwMs vec_altms = new AllowedTwMs();
        vec_altms.setJMatData(saltms);
        return vec_altms;
    }
    
    
    public MLStructure getJMatData()
    {
        MLStructure srt = new MLStructure("XXX", new int[] {1,1});
        srt.setField("eve1_type", setString(eve1_type));
        srt.setField("eve2_type", setString(eve2_type));
        srt.setField("output_folder", setDoubleColumnArray(output_folder));
        srt.setField("allowed_tw_ms",writeAllowedTwMs(allowed_tw_ms));
        return srt;
    } 
    
     private MLStructure writeAllowedTwMs(AllowedTwMs allowed_tms)
    {
        MLStructure struct = allowed_tms.getJMatData();
        return struct;
    }
  
    
}
