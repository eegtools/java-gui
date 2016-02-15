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
    
    public double loose_value;
    
    public String depth_weighting;
    public String downsample_atlasname;
    
    public Sources()
    {  
    }
    
    
    public Sources(MLStructure sour)
    {
        sources_norm  = getString(sour, "sources_norm");
        source_orient  = getString(sour, "source_orient");
        depth_weighting  = getString(sour, "depth_weighting");
        downsample_atlasname  = getString(sour, "downsample_atlasname");
        
        loose_value  = getDouble(sour, "loose_value"); 
    } 

    
}
