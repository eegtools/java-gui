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
public class Brainstorm extends JMatlabStructWrapper{
    
    public String db_name;
    public String default_anatomy;
    public String channels_file_name;
    // public String channels_file_type;
    public String channels_file_path;
    //public String average_file_name;
    public String bem_file_name;
        
    // public ConductorVolume conductorvolume;
    public Path_bs paths;
    public Sources sources;
    // public Export_bs export;
    // public Stats_bs stats;
    
    public String[][] analysis_bands;
    public String[][] analysis_times;

    public int use_same_montage;
    // public double std_loose_value;

    
    public Brainstorm()
    {
        
    }
    
    public void setJMatData(MLStructure brains)
    {
        db_name             = getString(brains, "db_name");
        default_anatomy     = getString(brains, "default_anatomy");
        channels_file_name  = getString(brains, "channels_file_name");
        //channels_file_type  = getString(brains, "channels_file_type");
        channels_file_path  = getString(brains, "channels_file_path");
        //average_file_name   = getString(brains, "average_file_name");
        bem_file_name       = getString(brains, "bem_file_name");
        
        analysis_bands      = getStringCellMatrix(brains, "analysis_bands");
        analysis_times      = getStringCellMatrix(brains, "analysis_times");
        
        use_same_montage    = getInt(brains, "use_same_montage");
        //std_loose_value     = getDouble(brains, "std_loose_value");
        
        //conductorvolume     = readConductorVolume(brains,"conductorvolume");
        paths               = readPath_bs(brains,"paths");
        sources             = readSources(brains,"sources");
        //export              = getExport_bs(brains,"export");
        //stats               = getStats_bs(brains,"stats");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure brains = new MLStructure("brains",new int[] {1,1});
        
        brains.setField("db_name",setString(db_name));
        brains.setField("default_anatomy",setString(default_anatomy));
        brains.setField("channels_file_name",setString(channels_file_name));
        //brains.setField("channels_file_type",setString(channels_file_type));
        brains.setField("channels_file_path",setString(channels_file_path));
        //brains.setField("average_file_name",setString(average_file_name));

        //brains.setField("analysis_bands",setStringColLineCell(analysis_bands));
        //brains.setField("analysis_times",setStringColLineCell(analysis_times));

        brains.setField("use_same_montage",setInt(use_same_montage));
        //brains.setField("std_loose_value",setDouble(std_loose_value));
 
        return brains;
    }
    

    private ConductorVolume readConductorVolume(MLStructure condvol, String field)
    {
        MLStructure condvols = (MLStructure) condvol.getField(field);
        ConductorVolume vec = new ConductorVolume(condvols);
        return vec;
    }
    
    private Path_bs readPath_bs(MLStructure path_bs, String field)
    {
        MLStructure path_bss = (MLStructure) path_bs.getField(field);
        Path_bs vec = new Path_bs(path_bss);
        return vec;
    }
    
    private Sources readSources(MLStructure sour, String field)
    {
        MLStructure sours = (MLStructure) sour.getField(field);
        Sources vec = new Sources(sours);
        return vec;
    }
    
    private Export_bs readExport_bs(MLStructure exp_bs, String field)
    {
        MLStructure exp_bss = (MLStructure) exp_bs.getField(field);
        Export_bs vec = new Export_bs(exp_bss);
        return vec;
    }
    
    private Stats_bs readStats_bs(MLStructure stats_bs, String field)
    {
        MLStructure stats_bss = (MLStructure) stats_bs.getField(field);
        Stats_bs vec = new Stats_bs(stats_bss);
        return vec;
    }
    

    
}
