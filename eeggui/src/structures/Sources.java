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
public class Sources extends JMatlabStructWrapper{
    
    
    public String sources_norm;
    public String source_orient;
    public String depth_weighting;
    public String downsample_atlasname;
    
    public double[] loose_value;
    public double[] window_samples_halfwidth;
    
    
    public Sources(){}
    
    
    public void setJMatData(MLStructure struct)
    {
        sources_norm            = getString(struct, "sources_norm");
        source_orient           = getString(struct, "source_orient");
        depth_weighting         = getString(struct, "depth_weighting");
        downsample_atlasname    = getString(struct, "downsample_atlasname");
        
        loose_value                 = getDoubleArray(struct, "loose_value"); 
        window_samples_halfwidth    = getDoubleArray(struct, "window_samples_halfwidth"); 
    } 
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("sources_norm",setString(sources_norm));
        struct.setField("source_orient",setString(source_orient));
        struct.setField("depth_weighting",setString(depth_weighting));
        struct.setField("downsample_atlasname",setString(downsample_atlasname));
        
        struct.setField("loose_value",setDoubleColumnArray(loose_value));
        struct.setField("window_samples_halfwidth",setDoubleColumnArray(window_samples_halfwidth));
        
        return struct;
    }

    
}
