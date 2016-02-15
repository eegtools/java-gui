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
public class Path_bs extends JMatlabStructWrapper{
    
    public String db;
    public String data;
    public String channels_file;
    
    public Path_bs()
    {  
    }
    
    
    public Path_bs(MLStructure p_bs)
    {
        db  = getString(p_bs, "db");
        data  = getString(p_bs, "data");
        channels_file  = getString(p_bs, "channels_file");
    } 
    
}
