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
public class Clustering extends JMatlabStructWrapper{
    
    public String channels_file_name;
    public String channels_file_path;
    
    public Clustering()
    {
        
    }
    
    public void setJMatData(MLStructure clust)
    {
        channels_file_name  = getString(clust, "channels_file_name");
        channels_file_path  = getString(clust, "channels_file_path");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure clust = new MLStructure("clust",new int[] {1,1});
        
        clust.setField("channels_file_name",setString(channels_file_name));
        clust.setField("channels_file_path",setString(channels_file_path));
 
        return clust;
    }

    
}
