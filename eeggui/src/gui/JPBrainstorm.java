/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import javax.swing.table.DefaultTableModel;
import structures.Brainstorm;
import structures.Erp;
import structures.Project;

/**
 *
 * @author PHilt
 */
public class JPBrainstorm extends javax.swing.JPanel {

    private JTPMain controller;
    public Brainstorm brains;
    public Project project;
    ModelTable_analysis_bands jTableDM_analysis_bands;
    
    public JPBrainstorm(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI(Project proj)
    {
        initTable_analysis_times(1);
        initComboSourcesOrient();
        initComboSourcesNorm();
        initTable_analysis_bands(1);
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        brains = project.brainstorm;
        
        initGUI(project);
        
        jTextField_average_file_name.setText(project.brainstorm.average_file_name);
        jTextField_channels_file_name.setText(project.brainstorm.channels_file_name);
        jTextField_channels_file_path.setText(project.brainstorm.channels_file_path);
        jTextField_channels_file_type.setText(project.brainstorm.channels_file_type);
        jTextField_db_name.setText(project.brainstorm.db_name);
        jTextField_default_anatomy.setText(project.brainstorm.default_anatomy);
        jTextField_std_loose_value.setText(String.valueOf(project.brainstorm.std_loose_value[0]));
        
        jTextField_conductorvolume_surf_bem_file_name.setText(project.brainstorm.conductorvolume.surf_bem_file_name);
        jTextField_conductorvolume_type.setText(String.valueOf(project.brainstorm.conductorvolume.type[0]));
        jTextField_conductorvolume_vol_bem_file_name.setText(project.brainstorm.conductorvolume.vol_bem_file_name);
        
        jTextField_export_spm_time_downsampling.setText(String.valueOf(project.brainstorm.export.spm_time_downsampling[0]));
        jTextField_export_spm_vol_downsampling.setText(String.valueOf(project.brainstorm.export.spm_vol_downsampling[0]));
        
        jTextField_paths_channels_file.setText(project.brainstorm.paths.channels_file);
        jTextField_paths_data.setText(project.brainstorm.paths.data);
        jTextField_paths_db.setText(project.brainstorm.paths.db);
        
        jTextField_sources_downsample_atlasname.setText(project.brainstorm.sources.downsample_atlasname);
        jTextField_sources_depth_weighting.setText(project.brainstorm.sources.depth_weighting);
        jComboBox_sources_orient.setSelectedItem(project.brainstorm.sources.source_orient);
        jComboBox_sources_norm.setSelectedItem(project.brainstorm.sources.sources_norm);
        jTextField_sources_loose_value.setText(String.valueOf(project.brainstorm.sources.loose_value[0]));
        jTextField_sources_window_samples_halfwidth.setText(String.valueOf(project.brainstorm.sources.window_samples_halfwidth[0]));
        
        jTextField_stats_correction.setText(project.brainstorm.stats.correction);
        jTextField_stats_pvalue.setText(String.valueOf(project.brainstorm.stats.pvalue[0]));
        jTextField_stats_ttest_abstype.setText(String.valueOf(project.brainstorm.stats.ttest_abstype[0]));
        
        jTextField_std_loose_value.setText(String.valueOf(project.brainstorm.std_loose_value[0]));
        
        boolean use_same_montage = (project.brainstorm.use_same_montage[0]==1);
        jCheckBox_use_same_montage.setSelected(use_same_montage);
        
        setTable_analysis_bands();
        setTable_analysis_times();
    }
    
    public Brainstorm getGUI()
    {
        
        return brains;
    }
    
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    
    private void initTable_analysis_times(int nb_rows)
    {
        String[] columnNames = {"number","time interv.","type"};
        Object[][] data = new Object[nb_rows][columnNames.length];         
        jTableDM_analysis_times = new ModelTable_analysis_times(data,columnNames);  
        jTable_analysis_times.setModel(jTableDM_analysis_times);  
    }
    
    class ModelTable_analysis_times extends DefaultTableModel {
 
    public ModelTable_analysis_times(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
        return String.class;  //all columns are String values
    }
      
    }
    
    private void initTable_analysis_bands(int nb_rows)
    {
        String[] columnNames = {"band","freq. min","req. max","type"};
        Object[][] data = new Object[nb_rows][columnNames.length];         
        jTableDM_analysis_bands = new ModelTable_analysis_bands(data,columnNames);  
        jTable_analysis_bands.setModel(jTableDM_analysis_bands); 
    }
   
    
    class ModelTable_analysis_bands extends DefaultTableModel {
 
    public ModelTable_analysis_bands(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
          return String.class;
    }

      @Override
      public boolean isCellEditable(int row, int col) {
        if ((col == 0) || (col == 1) || (col == 2))
            return false;
        else return true;
      }
      
    }
      
    
    private void initComboSourcesNorm()
    {
        jComboBox_sources_norm.addItem("wmne");
        jComboBox_sources_norm.addItem("dspm");
        jComboBox_sources_norm.addItem("sloreta");
    }
    
    private void initComboSourcesOrient()
    {
        jComboBox_sources_orient.addItem("fixed");
        jComboBox_sources_orient.addItem("loose");
    }
    
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_analysis_bands()
    { 
        int l_rows = project.brainstorm.analysis_bands[0].length;
        initTable_analysis_bands(l_rows);
        
        for (int i = 0; i < l_rows; i++) 
        {
            jTable_analysis_bands.setValueAt(project.brainstorm.analysis_bands[0][i][0], i, 0);
            jTable_analysis_bands.setValueAt(project.brainstorm.analysis_bands[0][i][2], i, 3);
            
            String str_Freq = project.brainstorm.analysis_bands[0][i][1];
            String[] str_Freq_cut = str_Freq.split(",");
            
            jTable_analysis_bands.setValueAt(str_Freq_cut[0], i, 1);
            jTable_analysis_bands.setValueAt(str_Freq_cut[1], i, 2);
        }
    }
    
    private void setTable_analysis_times()
    { 
        int l_rows = project.brainstorm.analysis_times[0].length;
        initTable_analysis_times(l_rows);
        
        for (int i = 0; i < l_rows; i++) 
        {
            jTable_analysis_times.setValueAt(project.brainstorm.analysis_times[0][i][0], i, 0);
            jTable_analysis_times.setValueAt(project.brainstorm.analysis_times[0][i][1], i, 1);
            jTable_analysis_times.setValueAt(project.brainstorm.analysis_times[0][i][2], i, 2);
        }
    }
    
    
    // ---------------------------------------------------------------------------
    // GET GUI

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel_db_name = new javax.swing.JLabel();
        jTextField_db_name = new javax.swing.JTextField();
        jLabel_paths_db = new javax.swing.JLabel();
        jTextField_paths_db = new javax.swing.JTextField();
        jLabel_paths_data = new javax.swing.JLabel();
        jTextField_paths_data = new javax.swing.JTextField();
        jTextField_paths_channels_file = new javax.swing.JTextField();
        jLabel_paths_channels_file = new javax.swing.JLabel();
        jLabel_Sources = new javax.swing.JLabel();
        jLabel_brainstorm = new javax.swing.JLabel();
        jLabel_sources_norm = new javax.swing.JLabel();
        jLabel_sources_orient = new javax.swing.JLabel();
        jComboBox_sources_norm = new javax.swing.JComboBox();
        jComboBox_sources_orient = new javax.swing.JComboBox();
        jLabel_sources_loose_value = new javax.swing.JLabel();
        jTextField_sources_loose_value = new javax.swing.JTextField();
        jLabel_sources_depth_weighting = new javax.swing.JLabel();
        jTextField_sources_depth_weighting = new javax.swing.JTextField();
        jLabel_sources_downsample_atlasname = new javax.swing.JLabel();
        jTextField_sources_downsample_atlasname = new javax.swing.JTextField();
        jLabel_sources_window_samples_halfwidth = new javax.swing.JLabel();
        jTextField_sources_window_samples_halfwidth = new javax.swing.JTextField();
        jLabel_analysis_bands = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable_analysis_times = new javax.swing.JTable();
        jLabel_analysis_times = new javax.swing.JLabel();
        jButton_analysis_times_remove = new javax.swing.JButton();
        jButton_analysis_times_new = new javax.swing.JButton();
        jLabel_ConductorVolume = new javax.swing.JLabel();
        jLabel_conductorvolume_type = new javax.swing.JLabel();
        jTextField_conductorvolume_type = new javax.swing.JTextField();
        jLabel_conductorvolume_surf_bem_file_name = new javax.swing.JLabel();
        jTextField_conductorvolume_surf_bem_file_name = new javax.swing.JTextField();
        jLabel_conductorvolume_vol_bem_file_name = new javax.swing.JLabel();
        jTextField_conductorvolume_vol_bem_file_name = new javax.swing.JTextField();
        jLabel_Brainstorm = new javax.swing.JLabel();
        jCheckBox_use_same_montage = new javax.swing.JCheckBox();
        jLabel_default_anatomy = new javax.swing.JLabel();
        jTextField_default_anatomy = new javax.swing.JTextField();
        jLabel_channels_file_name = new javax.swing.JLabel();
        jTextField_channels_file_name = new javax.swing.JTextField();
        jLabel_channels_file_type = new javax.swing.JLabel();
        jTextField_channels_file_type = new javax.swing.JTextField();
        jLabel_channels_file_path = new javax.swing.JLabel();
        jTextField_channels_file_path = new javax.swing.JTextField();
        jLabel_Export = new javax.swing.JLabel();
        jLabel_Stats = new javax.swing.JLabel();
        jLabel_export_spm_vol_downsampling = new javax.swing.JLabel();
        jLabel_export_spm_time_downsampling = new javax.swing.JLabel();
        jLabel_std_loose_value = new javax.swing.JLabel();
        jLabel_average_file_name = new javax.swing.JLabel();
        jLabel_stats_ttest_abstype = new javax.swing.JLabel();
        jLabel_stats_pvalue = new javax.swing.JLabel();
        jLabel_stats_correction = new javax.swing.JLabel();
        jTextField_export_spm_vol_downsampling = new javax.swing.JTextField();
        jTextField_export_spm_time_downsampling = new javax.swing.JTextField();
        jTextField_std_loose_value = new javax.swing.JTextField();
        jTextField_average_file_name = new javax.swing.JTextField();
        jTextField_stats_ttest_abstype = new javax.swing.JTextField();
        jTextField_stats_pvalue = new javax.swing.JTextField();
        jTextField_stats_correction = new javax.swing.JTextField();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable_analysis_bands = new javax.swing.JTable();

        jLabel_db_name.setText("brainstorm name");

        jLabel_paths_db.setText("brainstorm path");

        jLabel_paths_data.setText("Data path");

        jLabel_paths_channels_file.setText("Channels path");

        jLabel_Sources.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_Sources.setText("Sources");

        jLabel_brainstorm.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_brainstorm.setText("Brainstorm");

        jLabel_sources_norm.setText("norm");

        jLabel_sources_orient.setText("orient");

        jLabel_sources_loose_value.setText("loose value");

        jLabel_sources_depth_weighting.setText("depth weighting");

        jTextField_sources_depth_weighting.setEnabled(false);

        jLabel_sources_downsample_atlasname.setText("down sample name");

        jLabel_sources_window_samples_halfwidth.setText("window sample halfw");

        jLabel_analysis_bands.setText("analysis bands");

        jTable_analysis_times.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "number", "time interv.", "type"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane1.setViewportView(jTable_analysis_times);

        jLabel_analysis_times.setText("analysis times");

        jButton_analysis_times_remove.setText("Remove");

        jButton_analysis_times_new.setText("New");

        jLabel_ConductorVolume.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_ConductorVolume.setText("Conductor Volume");

        jLabel_conductorvolume_type.setText("type");

        jLabel_conductorvolume_surf_bem_file_name.setText("surf file name");

        jLabel_conductorvolume_vol_bem_file_name.setText("vol file name");

        jLabel_Brainstorm.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_Brainstorm.setText("Brainstorm");

        jCheckBox_use_same_montage.setText("same montage");

        jLabel_default_anatomy.setText("default anatomy");

        jLabel_channels_file_name.setText("channels filename");

        jLabel_channels_file_type.setText("channels file type");

        jLabel_channels_file_path.setText("channels file path");

        jLabel_Export.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_Export.setText("Export");

        jLabel_Stats.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_Stats.setText("Stats");

        jLabel_export_spm_vol_downsampling.setText("spm downsampling vol");

        jLabel_export_spm_time_downsampling.setText("spm downsampling time");

        jLabel_std_loose_value.setText("std loose value");

        jLabel_average_file_name.setText("average filename");

        jLabel_stats_ttest_abstype.setText("ttest abs type");

        jLabel_stats_pvalue.setText("p value");

        jLabel_stats_correction.setText("correction");

        jTable_analysis_bands.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "band", "freq min", "freq max", "type"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.Double.class, java.lang.Double.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane3.setViewportView(jTable_analysis_bands);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(43, 43, 43)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel_db_name)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField_db_name, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel_sources_norm)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jComboBox_sources_norm, javax.swing.GroupLayout.PREFERRED_SIZE, 72, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(21, 21, 21)
                                .addComponent(jLabel_sources_orient)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jComboBox_sources_orient, javax.swing.GroupLayout.PREFERRED_SIZE, 72, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(41, 41, 41)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel_sources_loose_value)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_sources_loose_value, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(41, 41, 41)
                                .addComponent(jLabel_sources_depth_weighting))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel_paths_db)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_paths_db)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jTextField_sources_depth_weighting, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(47, 47, 47)
                                .addComponent(jLabel_sources_downsample_atlasname)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_sources_downsample_atlasname, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jLabel_paths_data)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField_paths_data, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(44, 44, 44)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jLabel_sources_window_samples_halfwidth)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_sources_window_samples_halfwidth, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jLabel_paths_channels_file)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField_paths_channels_file, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(93, 93, 93))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 682, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(70, 70, 70)
                                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 327, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel_analysis_times)
                                .addGap(460, 460, 460)
                                .addComponent(jButton_analysis_times_new, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_analysis_times_remove, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(74, 74, 74)
                                .addComponent(jLabel_analysis_bands)))
                        .addContainerGap())))
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_Sources)
                            .addComponent(jLabel_brainstorm)
                            .addComponent(jLabel_ConductorVolume)))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGap(42, 42, 42)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jCheckBox_use_same_montage)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel_conductorvolume_type)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField_conductorvolume_type, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(59, 59, 59)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel_conductorvolume_surf_bem_file_name)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField_conductorvolume_surf_bem_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel_default_anatomy)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField_default_anatomy, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(18, 18, 18)
                                        .addComponent(jLabel_channels_file_name))))
                            .addGroup(layout.createSequentialGroup()
                                .addContainerGap()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_Export)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(31, 31, 31)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabel_export_spm_vol_downsampling)
                                                .addGap(18, 18, 18)
                                                .addComponent(jTextField_export_spm_vol_downsampling, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabel_export_spm_time_downsampling)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                .addComponent(jTextField_export_spm_time_downsampling, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)))))))
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGap(33, 33, 33)
                                .addComponent(jLabel_conductorvolume_vol_bem_file_name)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_conductorvolume_vol_bem_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(43, 43, 43)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_average_file_name)
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabel_std_loose_value)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                                    .addComponent(jTextField_std_loose_value, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addComponent(jTextField_average_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(10, 10, 10)
                                        .addComponent(jTextField_channels_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(28, 28, 28)
                                .addComponent(jLabel_channels_file_type)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_channels_file_type, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(30, 30, 30)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_Stats)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(30, 30, 30)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_stats_ttest_abstype)
                                            .addComponent(jLabel_stats_pvalue)
                                            .addComponent(jLabel_stats_correction))
                                        .addGap(18, 18, 18)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField_stats_correction, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField_stats_pvalue, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField_stats_ttest_abstype, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel_channels_file_path)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField_channels_file_path, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))))))
                .addGap(190, 190, 190))
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel_Brainstorm)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jLabel_brainstorm)
                .addGap(19, 19, 19)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_db_name)
                    .addComponent(jTextField_db_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_paths_db)
                    .addComponent(jTextField_paths_db, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_paths_data)
                    .addComponent(jTextField_paths_data, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_paths_channels_file)
                    .addComponent(jTextField_paths_channels_file, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(30, 30, 30)
                .addComponent(jLabel_Sources)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_sources_norm)
                    .addComponent(jLabel_sources_orient)
                    .addComponent(jComboBox_sources_norm, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBox_sources_orient, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_sources_loose_value)
                    .addComponent(jTextField_sources_loose_value, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_sources_depth_weighting)
                    .addComponent(jTextField_sources_depth_weighting, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_sources_downsample_atlasname)
                    .addComponent(jTextField_sources_downsample_atlasname, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_sources_window_samples_halfwidth)
                    .addComponent(jTextField_sources_window_samples_halfwidth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(30, 30, 30)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel_analysis_bands, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel_analysis_times)
                        .addComponent(jButton_analysis_times_remove)
                        .addComponent(jButton_analysis_times_new)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 169, Short.MAX_VALUE)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addGap(21, 21, 21)
                .addComponent(jLabel_ConductorVolume)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 24, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_conductorvolume_type)
                    .addComponent(jTextField_conductorvolume_type, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_conductorvolume_surf_bem_file_name)
                    .addComponent(jTextField_conductorvolume_surf_bem_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_conductorvolume_vol_bem_file_name)
                    .addComponent(jTextField_conductorvolume_vol_bem_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(30, 30, 30)
                .addComponent(jLabel_Brainstorm)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox_use_same_montage)
                    .addComponent(jLabel_default_anatomy)
                    .addComponent(jTextField_default_anatomy, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_channels_file_name)
                    .addComponent(jTextField_channels_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_channels_file_type)
                    .addComponent(jTextField_channels_file_type, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_channels_file_path)
                    .addComponent(jTextField_channels_file_path, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(30, 30, 30)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel_Export)
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_export_spm_vol_downsampling)
                                    .addComponent(jTextField_export_spm_vol_downsampling, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_export_spm_time_downsampling)
                                    .addComponent(jTextField_export_spm_time_downsampling, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_std_loose_value)
                                    .addComponent(jTextField_std_loose_value, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_average_file_name)
                                    .addComponent(jTextField_average_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel_Stats)
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_stats_ttest_abstype)
                            .addComponent(jTextField_stats_ttest_abstype, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_stats_pvalue)
                            .addComponent(jTextField_stats_pvalue, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_stats_correction)
                            .addComponent(jTextField_stats_correction, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(54, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    ModelTable_analysis_times jTableDM_analysis_times;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton_analysis_times_new;
    private javax.swing.JButton jButton_analysis_times_remove;
    private javax.swing.JCheckBox jCheckBox_use_same_montage;
    private javax.swing.JComboBox jComboBox_sources_norm;
    private javax.swing.JComboBox jComboBox_sources_orient;
    private javax.swing.JLabel jLabel_Brainstorm;
    private javax.swing.JLabel jLabel_ConductorVolume;
    private javax.swing.JLabel jLabel_Export;
    private javax.swing.JLabel jLabel_Sources;
    private javax.swing.JLabel jLabel_Stats;
    private javax.swing.JLabel jLabel_analysis_bands;
    private javax.swing.JLabel jLabel_analysis_times;
    private javax.swing.JLabel jLabel_average_file_name;
    private javax.swing.JLabel jLabel_brainstorm;
    private javax.swing.JLabel jLabel_channels_file_name;
    private javax.swing.JLabel jLabel_channels_file_path;
    private javax.swing.JLabel jLabel_channels_file_type;
    private javax.swing.JLabel jLabel_conductorvolume_surf_bem_file_name;
    private javax.swing.JLabel jLabel_conductorvolume_type;
    private javax.swing.JLabel jLabel_conductorvolume_vol_bem_file_name;
    private javax.swing.JLabel jLabel_db_name;
    private javax.swing.JLabel jLabel_default_anatomy;
    private javax.swing.JLabel jLabel_export_spm_time_downsampling;
    private javax.swing.JLabel jLabel_export_spm_vol_downsampling;
    private javax.swing.JLabel jLabel_paths_channels_file;
    private javax.swing.JLabel jLabel_paths_data;
    private javax.swing.JLabel jLabel_paths_db;
    private javax.swing.JLabel jLabel_sources_depth_weighting;
    private javax.swing.JLabel jLabel_sources_downsample_atlasname;
    private javax.swing.JLabel jLabel_sources_loose_value;
    private javax.swing.JLabel jLabel_sources_norm;
    private javax.swing.JLabel jLabel_sources_orient;
    private javax.swing.JLabel jLabel_sources_window_samples_halfwidth;
    private javax.swing.JLabel jLabel_stats_correction;
    private javax.swing.JLabel jLabel_stats_pvalue;
    private javax.swing.JLabel jLabel_stats_ttest_abstype;
    private javax.swing.JLabel jLabel_std_loose_value;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTable jTable_analysis_bands;
    private javax.swing.JTable jTable_analysis_times;
    private javax.swing.JTextField jTextField_average_file_name;
    private javax.swing.JTextField jTextField_channels_file_name;
    private javax.swing.JTextField jTextField_channels_file_path;
    private javax.swing.JTextField jTextField_channels_file_type;
    private javax.swing.JTextField jTextField_conductorvolume_surf_bem_file_name;
    private javax.swing.JTextField jTextField_conductorvolume_type;
    private javax.swing.JTextField jTextField_conductorvolume_vol_bem_file_name;
    private javax.swing.JTextField jTextField_db_name;
    private javax.swing.JTextField jTextField_default_anatomy;
    private javax.swing.JTextField jTextField_export_spm_time_downsampling;
    private javax.swing.JTextField jTextField_export_spm_vol_downsampling;
    private javax.swing.JTextField jTextField_paths_channels_file;
    private javax.swing.JTextField jTextField_paths_data;
    private javax.swing.JTextField jTextField_paths_db;
    private javax.swing.JTextField jTextField_sources_depth_weighting;
    private javax.swing.JTextField jTextField_sources_downsample_atlasname;
    private javax.swing.JTextField jTextField_sources_loose_value;
    private javax.swing.JTextField jTextField_sources_window_samples_halfwidth;
    private javax.swing.JTextField jTextField_stats_correction;
    private javax.swing.JTextField jTextField_stats_pvalue;
    private javax.swing.JTextField jTextField_stats_ttest_abstype;
    private javax.swing.JTextField jTextField_std_loose_value;
    // End of variables declaration//GEN-END:variables
}
