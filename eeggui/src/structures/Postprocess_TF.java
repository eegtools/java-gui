/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLStructure;
import java.util.Map;

/**
 *
 * @author PHilt
 */
public class Postprocess_TF extends JMatlabStructWrapper{
    
    public String sel_extrema;
    
    public double[] nbands;
    public double[] numroi;
    public double[] nroi;
    
    public double[][] frequency_bands_list;
    public String[] frequency_bands_names;
    public String[][] roi_list;
    public String[] roi_names;
    public String[][][] design_factors_ordered_levels; 

    public Mode mode;
    public FrequencyBands[] frequency_bands;
    public EogParams_TF eog;
    public EmgParams_TF emg;
    public DesignErsp[] design;

    
    public Postprocess_TF(){}
     
    public void setJMatData(MLStructure struct)
    {
        sel_extrema     = getString(struct, "sel_extrema"); 
        
        nbands          = getDoubleArray(struct, "nbands");
        numroi          = getDoubleArray(struct, "numroi");
        nroi            = getDoubleArray(struct, "nroi");
        
        frequency_bands_list            = getDoubleCell(struct, "frequency_bands_list");
        frequency_bands_names           = getStringCellArray(struct, "frequency_bands_names");
        roi_list                        = getStringCellMatrix_DiffSizes(struct, "roi_list");
        roi_names                       = getStringCellArray(struct, "roi_names");
        
        design_factors_ordered_levels   = getStringCellMatrix3D_DiffSizes(struct,"design_factors_ordered_levels");
        
        mode            = readMode(struct, "mode");
        eog             = readEogParams_TF(struct, "eog");
        emg             = readEmgParams_TF(struct, "emg");
        
        frequency_bands = readFrequencyBands(struct, "frequency_bands");
        design          = readDesignErsp(struct, "design");
    }   
    
    private Mode readMode(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Mode vec = new Mode();
        vec.setJMatData(structs);
        return vec;
    }
    
    private EogParams_TF readEogParams_TF(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        EogParams_TF vec = new EogParams_TF();
        vec.setJMatData(structs);
        return vec;
    }
    
    private EmgParams_TF readEmgParams_TF(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        EmgParams_TF vec = new EmgParams_TF();
        vec.setJMatData(structs);
        return vec;
    }
    
    private FrequencyBands[] readFrequencyBands(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        FrequencyBands[] arr = new FrequencyBands[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new FrequencyBands();
            
            arr[s].name = getString(map,"name");
            
            arr[s].min = getDoubleArray(map,"min");
            arr[s].max = getDoubleArray(map,"max");
            arr[s].dfmin = getDoubleArray(map,"dfmin");
            arr[s].dfmax = getDoubleArray(map,"dfmax");
            
            arr[s].ref_roi_list = getString(map,"ref_roi_list");
            arr[s].ref_roi_name = getString(map,"ref_roi_name");
            arr[s].ref_cond = getString(map,"ref_cond");
            
            arr[s].ref_tw_list = getDoubleArray(map,"ref_tw_list");
            
            arr[s].ref_tw_name = getString(map,"ref_tw_name");
            arr[s].which_realign_measure = getString(map,"which_realign_measure");
        }  
        return arr;
    }
    
    private DesignErsp[] readDesignErsp(MLStructure struct, String field)
    {
        MLStructure a           = (MLStructure) struct.getField(field);
        int[] dim               = a.getDimensions();
        
        DesignErsp[] arr = new DesignErsp[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map = a.getFields(s);
            arr[s] = new DesignErsp();
            
            arr[s].which_extrema_curve_continuous   = getStringCellMatrix3D(map, "which_extrema_curve_continuous");
            arr[s].group_time_windows_continuous    = getStringCellMatrix(map, "group_time_windows_continuous");
            arr[s].which_extrema_curve_tw           = getStringCellMatrix3D(map, "which_extrema_curve_tw");
            arr[s].deflection_polarity_list         = getStringCellMatrix3D(map, "deflection_polarity_list");
        
            arr[s].min_duration                     = getDoubleArray(map, "min_duration");
        
            arr[s].group_time_windows               = readGroupTimeWindows_TF(map, "group_time_windows");
            arr[s].subject_time_windows             = readSubjectTimeWindows(map, "subject_time_windows");
        }  
        return arr;
    }
    
    private GroupTimeWindows_TF[] readGroupTimeWindows_TF(Map map, String field)
    {
        MLStructure a           = (MLStructure) map.get(field);
        int[] dim               = a.getDimensions();
        
        GroupTimeWindows_TF[] arr = new GroupTimeWindows_TF[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map2 = a.getFields(s);
            arr[s] = new GroupTimeWindows_TF();
            
            arr[s].name    = getString(map2, "name");
            arr[s].min     = getDoubleArray(map2, "min");
            arr[s].max     = getDoubleArray(map2, "max");
            arr[s].ref_roi = getStringCellMatrix(map2, "ref_roi");
        }  
        return arr;
    }
    
    private SubjectTimeWindows[] readSubjectTimeWindows(Map map, String field)
    {
        MLStructure a           = (MLStructure) map.get(field);
        int[] dim               = a.getDimensions();
        
        SubjectTimeWindows[] arr = new SubjectTimeWindows[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  map2 = a.getFields(s);
            arr[s] = new SubjectTimeWindows();
            
            arr[s].min     = getDoubleArray(map2, "min");
            arr[s].max     = getDoubleArray(map2, "max");
        }  
        return arr;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("sel_extrema",setString(sel_extrema));
        
        struct.setField("nbands",setDoubleColumnArray(nbands));
        struct.setField("numroi",setDoubleColumnArray(numroi));
        struct.setField("nroi",setDoubleColumnArray(nroi));
        
        struct.setField("frequency_bands_list",setDoubleColLineArray(frequency_bands_list));
        struct.setField("frequency_bands_names",setStringLineArray(frequency_bands_names));
        struct.setField("roi_list",setStringColLineCell(roi_list));
        struct.setField("roi_names",setStringLineArray(roi_names));
        struct.setField("design_factors_ordered_levels",setStringColDbleLineCell(design_factors_ordered_levels));
        
        struct.setField("mode",writeMode(mode));
        struct.setField("eog",writeEogParams_TF(eog));
        struct.setField("emg",writeEmgParams_TF(emg));
        
        struct.setField("frequency_bands",writeFrequencyBands(frequency_bands));
        struct.setField("design",writeDesignErsp(design));
 
        return struct;
    }
    
    private MLStructure writeMode(Mode mode)
    {
        MLStructure struct = mode.getJMatData();
        return struct;
    }
    
    private MLStructure writeEogParams_TF(EogParams_TF eogparams)
    {
        MLStructure struct = eogparams.getJMatData();
        return struct;
    }
    
    private MLStructure writeEmgParams_TF(EmgParams_TF emgparams)
    {
        MLStructure struct = emgparams.getJMatData();
        return struct;
    }
    
    private MLStructure writeFrequencyBands(FrequencyBands[] freqsb)
    {
        int dim = freqsb.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(freqsb[s].name), s);
            struct.setField("ref_roi_list", setString(freqsb[s].ref_roi_list), s);
            struct.setField("ref_roi_name", setString(freqsb[s].ref_roi_name), s);
            struct.setField("ref_cond", setString(freqsb[s].ref_cond), s);
            struct.setField("ref_tw_name", setString(freqsb[s].ref_tw_name), s);
            struct.setField("which_realign_measure", setString(freqsb[s].which_realign_measure), s);
            
            struct.setField("min", setDoubleColumnArray(freqsb[s].min), s);
            struct.setField("max", setDoubleColumnArray(freqsb[s].max), s);
            struct.setField("dfmin", setDoubleColumnArray(freqsb[s].dfmin), s);
            struct.setField("dfmax", setDoubleColumnArray(freqsb[s].dfmax), s);
            struct.setField("ref_tw_list", setDoubleColumnArray(freqsb[s].ref_tw_list), s);
        }
        return struct;
    }
    
    private MLStructure writeDesignErsp(DesignErsp[] design_ersp)
    {
        int dim = design_ersp.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("which_extrema_curve_continuous", setStringTripleColumnCell(design_ersp[s].which_extrema_curve_continuous), s);
            struct.setField("group_time_windows_continuous", setStringColLineCell(design_ersp[s].group_time_windows_continuous), s);
            struct.setField("which_extrema_curve_tw", setStringTripleColumnCell(design_ersp[s].which_extrema_curve_tw), s);
            struct.setField("deflection_polarity_list", setStringTripleColumnCell(design_ersp[s].deflection_polarity_list), s);
            
            struct.setField("min_duration", setDoubleColumnArray(design_ersp[s].min_duration), s);
            
            struct.setField("group_time_windows", writeGroupTimeWindows_TF(design_ersp[s].group_time_windows), s);
            struct.setField("subject_time_windows", writeSubjectTimeWindows(design_ersp[s].subject_time_windows), s);
        }
        return struct;
    }
    
     private MLStructure writeGroupTimeWindows_TF(GroupTimeWindows_TF[] groupe_tw)
    {
        int dim = groupe_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(groupe_tw[s].name), s);
            
            struct.setField("min", setDoubleColumnArray(groupe_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(groupe_tw[s].max), s);
            
            struct.setField("ref_roi", setStringLineCell(groupe_tw[s].ref_roi), s);
        }
        return struct;
    }
     
      private MLStructure writeSubjectTimeWindows(SubjectTimeWindows[] subject_tw)
    {
        int dim = subject_tw.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("min", setDoubleColumnArray(subject_tw[s].min), s);
            struct.setField("max", setDoubleColumnArray(subject_tw[s].max), s);
        }
        return struct;
    }
    
}
