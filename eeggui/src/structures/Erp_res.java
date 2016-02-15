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
class Erp_res extends JMatlabStructWrapper{
    
    public int time_smoothing;
    
    public TimeRange_erp_res time_range;
    
    public String single_subjects;
    public String do_plots;
    public String show_text;
    public String z_transform;
    public String compact_plots;
    public String compact_h0;
    public String compact_v0;
    public String compact_sem;
    public String compact_stats;
    public String display_only_significant_curve;
    public String compact_plots_topo;
    public String display_only_significant_topo_mode;
    public String display_compact_topo_mode;
    public String display_compact_show_head;
    public String display_only_significant_topo;
    
    public double[] masked_times_max;
    public double[] set_caxis_topo_tw;
    public double[] compact_display_xlim;
    public double[] compact_display_ylim;
    
    public Erp_res(){}
    
    public Erp_res(MLStructure erpres)
    {    
        time_range                          = getTimeRange_erp_res(erpres,"time_range");
        
        single_subjects                     = getString(erpres, "single_subjects");
        do_plots                            = getString(erpres, "do_plots");
        show_text                           = getString(erpres, "show_text");
        z_transform                         = getString(erpres, "z_transform");
        compact_plots                       = getString(erpres, "compact_plots");
        compact_h0                          = getString(erpres, "compact_h0");
        compact_v0                          = getString(erpres, "compact_v0");
        compact_sem                         = getString(erpres, "compact_sem");
        compact_stats                       = getString(erpres, "compact_stats");
        display_only_significant_curve      = getString(erpres, "display_only_significant_curve");
        compact_plots_topo                  = getString(erpres, "compact_plots_topo");
        display_only_significant_topo_mode  = getString(erpres, "display_only_significant_topo_mode");
        display_compact_topo_mode           = getString(erpres, "display_compact_topo_mode");
        display_compact_show_head           = getString(erpres, "display_compact_show_head");
        display_only_significant_topo       = getString(erpres, "display_only_significant_topo");
        
        masked_times_max                    = getDoubleArray(erpres, "masked_times_max");
        set_caxis_topo_tw                   = getDoubleArray(erpres, "set_caxis_topo_tw");
        compact_display_xlim                = getDoubleArray(erpres, "compact_display_xlim");
        compact_display_ylim                = getDoubleArray(erpres, "compact_display_ylim");
    }  

    public TimeRange_erp_res getTimeRange_erp_res(MLStructure timeerp, String field)
    {
        MLStructure timeerps = (MLStructure) timeerp.getField(field);
        TimeRange_erp_res vec = new TimeRange_erp_res(timeerps);
        return vec;
    }
    
    
}
