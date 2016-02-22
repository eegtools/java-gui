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
public class PathBrains extends JMatlabStructWrapper{
    
    public String db;
    public String data;
    public String channels_file;
    
    public PathBrains(){}
    
    
    public void setJMatData(MLStructure struct)
    {
        db  = getString(struct, "db");
        data  = getString(struct, "data");
        channels_file  = getString(struct, "channels_file");
    } 
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("db",setString(db));
        struct.setField("data",setString(data));
        struct.setField("channels_file",setString(channels_file)); 
        
        return struct;
    }
    
}
