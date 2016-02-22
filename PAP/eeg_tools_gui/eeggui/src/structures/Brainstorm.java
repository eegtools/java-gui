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
    public String channels_file_type;
    public String channels_file_path;
    public String average_file_name;
        
    public ConductorVolume conductorvolume;
    public PathBrains paths;
    public Sources sources;
    public ExportBrains export;
    public StatsBrains stats;
    
    public String[][] analysis_bands;
    public String[][][] analysis_times; //matrix cell not vector

    public double[] use_same_montage;
    public double[] std_loose_value;

    
    public Brainstorm(){}
    
    public void setJMatData(MLStructure struct)
    {
        db_name             = getString(struct, "db_name");
        default_anatomy     = getString(struct, "default_anatomy");
        channels_file_name  = getString(struct, "channels_file_name");
        channels_file_type  = getString(struct, "channels_file_type");
        channels_file_path  = getString(struct, "channels_file_path");
        average_file_name   = getString(struct, "average_file_name");
        
        analysis_bands      = getStringCellMatrix(struct, "analysis_bands");
        analysis_times      = getStringCellMatrix_nxm(struct, "analysis_times");
        
        use_same_montage    = getDoubleArray(struct, "use_same_montage");
        std_loose_value     = getDoubleArray(struct, "std_loose_value");
        
        conductorvolume     = readConductorVolume(struct,"conductorvolume");
        paths               = readPathBrains(struct,"paths");
        sources             = readSources(struct,"sources");
        export              = readExportBrains(struct,"export");
        stats               = readStatsBrains(struct,"stats");
    }    
    
    private ConductorVolume readConductorVolume(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ConductorVolume vec = new ConductorVolume();
        vec.setJMatData(structs);
        return vec;
    }
    
    private PathBrains readPathBrains(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        PathBrains vec = new PathBrains();
        vec.setJMatData(structs);
        return vec;
    }
    
    private Sources readSources(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Sources vec = new Sources();
        vec.setJMatData(structs);
        return vec;
    }
    
    private ExportBrains readExportBrains(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ExportBrains vec = new ExportBrains();
        vec.setJMatData(structs);
        return vec;
    }
    
    private StatsBrains readStatsBrains(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        StatsBrains vec = new StatsBrains();
        vec.setJMatData(structs);
        return vec;
    }
    
    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("db_name",setString(db_name));
        struct.setField("default_anatomy",setString(default_anatomy));
        struct.setField("channels_file_name",setString(channels_file_name));
        struct.setField("channels_file_type",setString(channels_file_type));
        struct.setField("channels_file_path",setString(channels_file_path));
        struct.setField("average_file_name",setString(average_file_name));

        struct.setField("analysis_bands",setStringColLineCell(analysis_bands));
        struct.setField("analysis_times",setStringCellMatrix_nxm(analysis_times)); 

        struct.setField("use_same_montage",setDoubleColumnArray(use_same_montage));
        struct.setField("std_loose_value",setDoubleColumnArray(std_loose_value));
        
        struct.setField("conductorvolume",writeConductorVolume(conductorvolume));
        struct.setField("paths",writePathBrains(paths));
        struct.setField("sources",writeSources(sources));
        struct.setField("export",writeExportBrains(export));
        struct.setField("stats",writeStatsBrains(stats));
 
        return struct;
    }
    
    private MLStructure writeConductorVolume(ConductorVolume conductor)
    {
        MLStructure struct = conductor.getJMatData();
        return struct;
    }
    
    private MLStructure writePathBrains(PathBrains pathb)
    {
        MLStructure struct = pathb.getJMatData();
        return struct;
    }
    
    private MLStructure writeSources(Sources sources)
    {
        MLStructure struct = sources.getJMatData();
        return struct;
    }
    
    private MLStructure writeExportBrains(ExportBrains exportb)
    {
        MLStructure struct = exportb.getJMatData();
        return struct;
    }
    
    private MLStructure writeStatsBrains(StatsBrains statsb)
    {
        MLStructure struct = statsb.getJMatData();
        return struct;
    }


    
}
