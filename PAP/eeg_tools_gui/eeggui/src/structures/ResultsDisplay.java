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
public class ResultsDisplay extends JMatlabStructWrapper{
    
    public double[] time_smoothing;
    public double[] filter_freq;
    public double[] ylim_plot;
    public double[] masked_times_max;
    public double[] compact_display_xlim;
    public double[] compact_display_ylim;
    public double[] set_caxis_topo_tw;
    
    public Latency time_range;
    
    public String single_subjects;
    public String do_plots;
    public String show_text;
    public String compact_plots;
    public String compact_h0;
    public String compact_v0;
    public String compact_sem;
    public String compact_stats;
    public String display_only_significant_curve;
    public String compact_plots_topo;
    public String display_only_significant_topo;
    public String display_only_significant_topo_mode;
    public String display_compact_topo_mode;
    public String display_compact_show_head;
    public String z_transform;

    
    public ResultsDisplay()
    {
    }
    
    public void setJMatData(MLStructure struct)
    {
        time_smoothing          = getDoubleArray(struct, "time_smoothing");
        filter_freq             = getDoubleArray(struct, "filter_freq");
        ylim_plot               = getDoubleArray(struct, "ylim_plot");
        masked_times_max        = getDoubleArray(struct, "masked_times_max");
        compact_display_xlim    = getDoubleArray(struct, "compact_display_xlim");
        compact_display_ylim    = getDoubleArray(struct, "compact_display_ylim");
        set_caxis_topo_tw       = getDoubleArray(struct, "set_caxis_topo_tw");
        
        time_range              = readLatency(struct, "time_range");
        
        single_subjects                 = getString(struct, "single_subjects");
        do_plots                        = getString(struct, "do_plots");
        show_text                       = getString(struct, "show_text");
        compact_plots                   = getString(struct, "compact_plots");
        compact_h0                      = getString(struct, "compact_h0");
        compact_v0                      = getString(struct, "compact_v0");
        compact_sem                     = getString(struct, "compact_sem");
        compact_stats                   = getString(struct, "compact_stats");
        display_only_significant_curve  = getString(struct, "display_only_significant_curve");
        compact_plots_topo              = getString(struct, "compact_plots_topo");
        display_only_significant_topo   = getString(struct, "display_only_significant_topo");
        display_only_significant_topo_mode = getString(struct, "display_only_significant_topo_mode");
        display_compact_topo_mode       = getString(struct, "display_compact_topo_mode");
        display_compact_show_head       = getString(struct, "display_compact_show_head");
        z_transform                     = getString(struct, "z_transform");
    }
    
    private Latency readLatency(MLStructure lat, String field)
    {
        MLStructure slat = (MLStructure) lat.getField(field);
        Latency vec_lat = new Latency();
        vec_lat.setJMatDataS(slat);
        return vec_lat;
    }
  
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("time_smoothing",setDoubleColumnArray(time_smoothing));
        struct.setField("filter_freq",setDoubleColumnArray(filter_freq));
        struct.setField("ylim_plot",setDoubleColumnArray(ylim_plot)); 
        struct.setField("masked_times_max",setDoubleColumnArray(masked_times_max));
        struct.setField("compact_display_xlim",setDoubleColumnArray(compact_display_xlim));
        struct.setField("compact_display_ylim",setDoubleColumnArray(compact_display_ylim));
        struct.setField("set_caxis_topo_tw",setDoubleColumnArray(set_caxis_topo_tw));

        struct.setField("time_range",writeLatency(time_range));
        
        struct.setField("single_subjects",setString(single_subjects));
        struct.setField("do_plots",setString(do_plots));
        struct.setField("show_text",setString(show_text));
        struct.setField("compact_plots",setString(compact_plots));
        struct.setField("compact_h0",setString(compact_h0));
        struct.setField("compact_v0",setString(compact_v0));
        struct.setField("compact_sem",setString(compact_sem));
        struct.setField("compact_stats",setString(compact_stats));
        struct.setField("display_only_significant_curve",setString(display_only_significant_curve));
        struct.setField("compact_plots_topo",setString(compact_plots_topo));
        struct.setField("display_only_significant_topo",setString(display_only_significant_topo));
        struct.setField("display_only_significant_topo_mode",setString(display_only_significant_topo_mode));
        struct.setField("display_compact_topo_mode",setString(display_compact_topo_mode));
        struct.setField("display_compact_show_head",setString(display_compact_show_head));
        struct.setField("z_transform",setString(z_transform));
        
        return struct;
    }
    
    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
}
