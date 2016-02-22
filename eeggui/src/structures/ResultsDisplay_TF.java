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
public class ResultsDisplay_TF extends JMatlabStructWrapper{
    
    public Latency time_range;
    
    public double[] frequency_range;
    public double[] masked_times_max;
    public double[] compact_display_xlim;
    public double[] compact_display_ylim;
    public double[] stat_time_windows_list;
    public double[] set_caxis_tf;
    public double[] set_caxis_topo_tw_fb;
    
    public String do_plots;
    public String show_text;
    public String z_transform;
    public String which_error_measure;
    public String freq_scale;
    public String display_pmode;
    public String compact_plots;
    public String compact_h0;
    public String compact_v0;
    public String compact_sem;
    public String compact_stats;
    public String display_only_significant_curve;
    public String display_only_significant_tf;
    public String display_only_significant_tf_mode;
    public String compact_plots_topo;
    public String display_only_significant_topo;
    public String display_only_significant_topo_mode;
    public String display_compact_topo_mode;
    public String display_compact_show_head;
    
    public ResultsDisplay_TF(){}


    public void setJMatData(MLStructure struct)
    {
        time_range = readLatency(struct, "time_range");
        
        frequency_range             = getDoubleArray(struct,"frequency_range");
        masked_times_max            = getDoubleArray(struct,"masked_times_max");
        compact_display_xlim        = getDoubleArray(struct,"compact_display_xlim");
        compact_display_ylim        = getDoubleArray(struct,"compact_display_ylim");
        stat_time_windows_list      = getDoubleArray(struct,"stat_time_windows_list");
        set_caxis_tf                = getDoubleArray(struct,"set_caxis_tf");
        set_caxis_topo_tw_fb        = getDoubleArray(struct,"set_caxis_topo_tw_fb");
        
        do_plots                            = getString(struct,"do_plots");
        show_text                           = getString(struct,"show_text");
        z_transform                         = getString(struct,"z_transform");
        which_error_measure                 = getString(struct,"which_error_measure");
        freq_scale                          = getString(struct,"freq_scale");
        display_pmode                       = getString(struct,"display_pmode");
        compact_plots                       = getString(struct,"compact_plots");
        compact_h0                          = getString(struct,"compact_h0");
        compact_v0                          = getString(struct,"compact_v0");
        compact_sem                         = getString(struct,"compact_sem");
        compact_stats                       = getString(struct,"compact_stats");
        display_only_significant_curve      = getString(struct,"display_only_significant_curve");
        display_only_significant_tf         = getString(struct,"display_only_significant_tf");
        display_only_significant_tf_mode    = getString(struct,"display_only_significant_tf_mode");
        compact_plots_topo                  = getString(struct,"compact_plots_topo");
        display_only_significant_topo       = getString(struct,"display_only_significant_topo");
        display_only_significant_topo_mode  = getString(struct,"display_only_significant_topo_mode");
        display_compact_topo_mode           = getString(struct,"display_compact_topo_mode");
        display_compact_show_head           = getString(struct,"display_compact_show_head");
    }
    
    private Latency readLatency(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Latency vec = new Latency();
        vec.setJMatDataS(structs);
        return vec;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("time_range",writeLatency(time_range));
        
        struct.setField("frequency_range",setDoubleColumnArray(frequency_range));
        struct.setField("masked_times_max",setDoubleColumnArray(masked_times_max));
        struct.setField("compact_display_xlim",setDoubleColumnArray(compact_display_xlim)); 
        struct.setField("compact_display_ylim",setDoubleColumnArray(compact_display_ylim)); 
        struct.setField("stat_time_windows_list",setDoubleColumnArray(stat_time_windows_list)); 
        struct.setField("set_caxis_tf",setDoubleColumnArray(set_caxis_tf)); 
        struct.setField("set_caxis_topo_tw_fb",setDoubleColumnArray(set_caxis_topo_tw_fb));

        struct.setField("do_plots",setString(do_plots));
        struct.setField("show_text",setString(show_text));
        struct.setField("z_transform",setString(z_transform));
        struct.setField("which_error_measure",setString(which_error_measure));
        struct.setField("freq_scale",setString(freq_scale));
        struct.setField("display_pmode",setString(display_pmode));
        struct.setField("compact_plots",setString(compact_plots));
        struct.setField("compact_h0",setString(compact_h0));
        struct.setField("compact_v0",setString(compact_v0));
        struct.setField("compact_sem",setString(compact_sem));
        struct.setField("compact_stats",setString(compact_stats));
        struct.setField("display_only_significant_curve",setString(display_only_significant_curve));
        struct.setField("display_only_significant_tf",setString(display_only_significant_tf));
        struct.setField("display_only_significant_tf_mode",setString(display_only_significant_tf_mode));
        struct.setField("compact_plots_topo",setString(compact_plots_topo));
        struct.setField("display_only_significant_topo",setString(display_only_significant_topo));
        struct.setField("display_only_significant_topo_mode",setString(display_only_significant_topo_mode));
        struct.setField("display_compact_topo_mode",setString(display_compact_topo_mode));
        struct.setField("display_compact_show_head",setString(display_compact_show_head));

        return struct;
    }

    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
    
}
