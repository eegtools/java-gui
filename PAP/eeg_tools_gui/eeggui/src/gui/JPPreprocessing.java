/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;


import structures.Project;
import structures.Preproc;
/**
 *
 * @author alba
 */
public class JPPreprocessing extends javax.swing.JPanel {

    /**
     * Creates new form JPreProcessing
     */
    public JPPreprocessing(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI()
    {
        initComboBox_notch_remove_armonics();
        initComboBox_filter_algorithm();
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        preproc = project.preproc;
        
        initGUI();
        
        setTextArea_montage_list1();
        setTextArea_montage_list2();
        
        jTextField_output_folder.setText(preproc.output_folder);
        JComboBox_filter_algorithm.setSelectedItem(preproc.filter_algorithm);
        
        boolean do_notch = (preproc.do_notch[0] != 0);
        jCheckBox_do_notch.setSelected(do_notch);
        
        jComboBox_notch_remove_armonics.setSelectedItem(preproc.notch_remove_armonics);
        
        jTextField_notch_fcenter.setText(String.valueOf(preproc.notch_fcenter[0]));
        jTextField_notch_fspan.setText(String.valueOf(preproc.notch_fspan[0]));
        
        jTextField_ff1_global.setText(String.valueOf(preproc.ff1_global[0]));
        jTextField_ff2_global.setText(String.valueOf(preproc.ff2_global[0]));
        jTextField_ff1_eeg.setText(String.valueOf(preproc.ff1_eeg[0]));
        jTextField_ff2_eeg.setText(String.valueOf(preproc.ff2_eeg[0]));
        jTextField_ff1_eog.setText(String.valueOf(preproc.ff1_eog[0]));
        jTextField_ff2_eog.setText(String.valueOf(preproc.ff2_eog[0]));
        jTextField_ff1_emg.setText(String.valueOf(preproc.ff1_emg[0]));
        jTextField_ff2_emg.setText(String.valueOf(preproc.ff2_emg[0]));
        
        jTextField_rt_eve1_type.setText(preproc.rt.eve1_type);
        jTextField_rt_eve2_type.setText(preproc.rt.eve2_type);
        
        if (preproc.rt.allowed_tw_ms.min!=null)
        {jTextField_rt_allowed_tw_ms_min.setText(String.valueOf(preproc.rt.allowed_tw_ms.min[0]));}
        else {jTextField_rt_allowed_tw_ms_min.setText("");}
        if (preproc.rt.allowed_tw_ms.max!=null)
        {jTextField_rt_allowed_tw_ms_max.setText(String.valueOf(preproc.rt.allowed_tw_ms.max[0]));}
        else {jTextField_rt_allowed_tw_ms_max.setText("");}
        
        jTextField_rt_output_folder.setText(preproc.rt.output_folder);
        
        jTextField_marker_type_begin_trial.setText(preproc.marker_type.begin_trial);
        jTextField_marker_type_end_trial.setText(preproc.marker_type.end_trial);
        jTextField_marker_type_begin_baseline.setText(preproc.marker_type.begin_baseline);
        jTextField_marker_type_end_baseline.setText(preproc.marker_type.end_baseline);
        
        jTextField_insert_begin_trial_target_event_types.setText(preproc.insert_begin_trial.target_event_types[0]);
        jTextField_insert_end_trial_target_event_types.setText(preproc.insert_end_trial.target_event_types[0]);
        jTextField_insert_begin_baseline_target_event_types.setText(preproc.insert_begin_baseline.target_event_types[0]);
        jTextField_insert_end_baseline_target_event_types.setText(preproc.insert_end_baseline.target_event_types[0]);
        
        jTextField_insert_begin_trial_delay.setText(String.valueOf(preproc.insert_begin_trial.delay.s[0]));
        jTextField_insert_end_trial_delay.setText(String.valueOf(preproc.insert_end_trial.delay.s[0]));
        jTextField_insert_begin_baseline_delay.setText(String.valueOf(preproc.insert_begin_baseline.delay.s[0]));
        jTextField_insert_end_baseline_delay.setText(String.valueOf(preproc.insert_end_baseline.delay.s[0]));
        
        jTextField_insert_block_trials_per_block.setText(String.valueOf(preproc.insert_block.trials_per_block[0]));
        
    }
    
    public Preproc getGUI()
    {   
        preproc.output_folder               = jTextField_output_folder.getText();
        preproc.filter_algorithm            =  (String) JComboBox_filter_algorithm.getSelectedItem();
        
        boolean do_notch = jCheckBox_do_notch.isSelected();
        preproc.do_notch[0] = do_notch? 1 : 0;
        preproc.notch_remove_armonics       = (String) jComboBox_notch_remove_armonics.getSelectedItem();
        
        preproc.notch_fcenter = new double[1];
        if (!jTextField_notch_fcenter.getText().isEmpty())
        {preproc.notch_fcenter[0]           = Double.parseDouble(jTextField_notch_fcenter.getText());}
        preproc.notch_fspan = new double[1];
        if (!jTextField_notch_fspan.getText().isEmpty())
        {preproc.notch_fspan[0]             = Double.parseDouble(jTextField_notch_fspan.getText());}
        
        preproc.ff1_global = new double[1];
        if (!jTextField_ff1_global.getText().isEmpty())
        {preproc.ff1_global[0]              = Double.parseDouble(jTextField_ff1_global.getText());}
        preproc.ff2_global = new double[1];
        if (!jTextField_ff2_global.getText().isEmpty())
        {preproc.ff2_global[0]              = Double.parseDouble(jTextField_ff2_global.getText());}
        
        preproc.ff1_eeg = new double[1];
        if (!jTextField_ff1_eeg.getText().isEmpty())
        {preproc.ff1_eeg[0]                 = Double.parseDouble(jTextField_ff1_eeg.getText());}
        preproc.ff2_eeg = new double[1];
        if (!jTextField_ff2_eeg.getText().isEmpty())
        {preproc.ff2_eeg[0]                 = Double.parseDouble(jTextField_ff2_eeg.getText());}
        
        preproc.ff1_eog = new double[1];
        if (!jTextField_ff1_eog.getText().isEmpty())
        {preproc.ff1_eog[0]                 = Double.parseDouble(jTextField_ff1_eog.getText());}
        preproc.ff2_eog = new double[1];
        if (!jTextField_ff2_eog.getText().isEmpty())
        {preproc.ff2_eog[0]                 = Double.parseDouble(jTextField_ff2_eog.getText());}
        
        preproc.ff1_emg = new double[1];
        if (!jTextField_ff1_emg.getText().isEmpty())
        {preproc.ff1_emg[0]                 = Double.parseDouble(jTextField_ff1_emg.getText());}
        preproc.ff2_emg = new double[1];
        if (!jTextField_ff2_emg.getText().isEmpty())
        {preproc.ff2_emg[0]                 = Double.parseDouble(jTextField_ff2_emg.getText());}
        
        preproc.rt.eve1_type                = jTextField_rt_eve1_type.getText();
        preproc.rt.eve2_type                = jTextField_rt_eve2_type.getText();

        preproc.rt.allowed_tw_ms.min = new double[1];
        if (!jTextField_rt_allowed_tw_ms_min.getText().isEmpty())
        {preproc.rt.allowed_tw_ms.min[0]    = Double.parseDouble(jTextField_rt_allowed_tw_ms_min.getText());}
        preproc.rt.allowed_tw_ms.max = new double[1];
        if (!jTextField_rt_allowed_tw_ms_max.getText().isEmpty())
        {preproc.rt.allowed_tw_ms.max[0]    = Double.parseDouble(jTextField_rt_allowed_tw_ms_max.getText());}

        preproc.rt.output_folder            = jTextField_rt_output_folder.getText();
        
        preproc.marker_type.begin_trial     = jTextField_marker_type_begin_trial.getText(); 
        preproc.marker_type.end_trial       = jTextField_marker_type_end_trial.getText(); 
        preproc.marker_type.begin_baseline  = jTextField_marker_type_begin_baseline.getText(); 
        preproc.marker_type.end_baseline    = jTextField_marker_type_end_baseline.getText(); 

        preproc.insert_begin_trial.delay.s= new double[1];
        if (!jTextField_insert_begin_trial_delay.getText().isEmpty())
        {preproc.insert_begin_trial.delay.s[0]                  = Double.parseDouble(jTextField_insert_begin_trial_delay.getText());}
        preproc.insert_end_trial.delay.s= new double[1];
        if (!jTextField_insert_end_trial_delay.getText().isEmpty())
        {preproc.insert_end_trial.delay.s[0]                    = Double.parseDouble(jTextField_insert_end_trial_delay.getText());}
        preproc.insert_begin_baseline.delay.s= new double[1];
        if (!jTextField_insert_begin_baseline_delay.getText().isEmpty())
        {preproc.insert_begin_baseline.delay.s[0]               = Double.parseDouble(jTextField_insert_begin_baseline_delay.getText());}
        preproc.insert_end_baseline.delay.s= new double[1];
        if (!jTextField_insert_end_baseline_delay.getText().isEmpty())
        {preproc.insert_end_baseline.delay.s[0]                 = Double.parseDouble(jTextField_insert_end_baseline_delay.getText());}
        
        preproc.insert_end_trial.target_event_types[0]          = jTextField_insert_end_trial_target_event_types.getText(); 
        preproc.insert_begin_baseline.target_event_types[0]     = jTextField_insert_begin_baseline_target_event_types.getText(); 
        preproc.insert_end_baseline.target_event_types[0]       = jTextField_insert_end_baseline_target_event_types.getText(); 
        
        preproc.insert_block.trials_per_block[0]                = Double.parseDouble(jTextField_insert_block_trials_per_block.getText()); 
        
        String[] split_list1 = jTextArea_montage_list1.getText().split(",");
        String[] split_list2 = jTextArea_montage_list2.getText().split(",");
        int max_size_list = Math.max(split_list1.length,split_list2.length);
        preproc.montage_list = new String[2][max_size_list];
        for (int i = 0; i < max_size_list; i++)
        {
            if (i<split_list1.length)
            {preproc.montage_list[0][i] = split_list1[i];}
            else {preproc.montage_list[0][i] = "";}
            if (i<split_list2.length)
            {preproc.montage_list[1][i] = split_list2[i];}
            else {preproc.montage_list[1][i] = "";}
        }

        return preproc;
    }
    
    // ---------------------------------------------------------------------------
    // INIT GUI
        
    private void initComboBox_notch_remove_armonics()
    {
        jComboBox_notch_remove_armonics.addItem("all");
        jComboBox_notch_remove_armonics.addItem("first");
    }
    
    private void initComboBox_filter_algorithm()
    {
        JComboBox_filter_algorithm.addItem("pop_eegfiltnew_12");
        JComboBox_filter_algorithm.addItem("pop_basicfilter");
        JComboBox_filter_algorithm.addItem("causal_pop_iirfilt_12");
        JComboBox_filter_algorithm.addItem("noncausal_pop_iirfilt_12");
        JComboBox_filter_algorithm.addItem("causal_pop_eegfilt_12");
        JComboBox_filter_algorithm.addItem("noncausal_pop_eegfilt_12");
        JComboBox_filter_algorithm.addItem("causal_pop_eegfiltnew_13");
        JComboBox_filter_algorithm.addItem("noncausal_pop_eegfiltnew_13");
    }
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTextArea_montage_list1()
    {
        String print = new String("");
        for (int i = 0; i < project.preproc.montage_list[0].length; i++) 
        {
            if (project.preproc.montage_list[0][i]!=null)
            {
            if (i==0)
            {print = print + project.preproc.montage_list[0][0];}
            else
            {print = print + "," + project.preproc.montage_list[0][i];}
            }
        }
        jTextArea_montage_list1.setText(print);
        jTextArea_montage_list1.setLineWrap(true);
        jTextArea_montage_list1.setWrapStyleWord(true);
    }
    
    private void setTextArea_montage_list2()
    {
        String print = new String("");
        for (int i = 0; i < project.preproc.montage_list[1].length; i++) 
        {
            if (project.preproc.montage_list[1][i]!=null)
            {
            if (i==0)
            {print = print + project.preproc.montage_list[1][0];}
            else
            {print = print + "," + project.preproc.montage_list[1][i];}
            }
        }
        jTextArea_montage_list2.setText(print);
        jTextArea_montage_list2.setLineWrap(true);
        jTextArea_montage_list2.setWrapStyleWord(true);
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPpreproc = new javax.swing.JPanel();
        jLabel_ff_global = new javax.swing.JLabel();
        jLabel_filter_algorithm = new javax.swing.JLabel();
        JComboBox_filter_algorithm = new javax.swing.JComboBox();
        jLabel_ff1_global = new javax.swing.JLabel();
        jTextField_ff1_global = new javax.swing.JTextField();
        jLabel_ff2_global = new javax.swing.JLabel();
        jTextField_ff2_global = new javax.swing.JTextField();
        jLabel_output_folder = new javax.swing.JLabel();
        jTextField_output_folder = new javax.swing.JTextField();
        jLabel_notch_fcenter = new javax.swing.JLabel();
        jTextField_notch_fcenter = new javax.swing.JTextField();
        jLabel_notch = new javax.swing.JLabel();
        jCheckBox_do_notch = new javax.swing.JCheckBox();
        jLabel_notch_fspan = new javax.swing.JLabel();
        jTextField_notch_fspan = new javax.swing.JTextField();
        jLabel_notch_remove_armonics = new javax.swing.JLabel();
        jComboBox_notch_remove_armonics = new javax.swing.JComboBox();
        jLabel_EEGFilter = new javax.swing.JLabel();
        jLabel_ff1_eeg = new javax.swing.JLabel();
        jTextField_ff1_eeg = new javax.swing.JTextField();
        jLabel_ff2_eeg = new javax.swing.JLabel();
        jTextField_ff2_eeg = new javax.swing.JTextField();
        jLabel_EOGFilter = new javax.swing.JLabel();
        jLabel_ff1_eog = new javax.swing.JLabel();
        jTextField_ff1_eog = new javax.swing.JTextField();
        jLabel_ff2_eog = new javax.swing.JLabel();
        jTextField_ff2_eog = new javax.swing.JTextField();
        jLabel_EMGFilter = new javax.swing.JLabel();
        jLabel_ff1_emg = new javax.swing.JLabel();
        jTextField_ff1_emg = new javax.swing.JTextField();
        jLabel_ff2_emg = new javax.swing.JLabel();
        jTextField_ff2_emg = new javax.swing.JTextField();
        jLabel_rt = new javax.swing.JLabel();
        jLabel_rt_eve1_type = new javax.swing.JLabel();
        jTextField_rt_eve1_type = new javax.swing.JTextField();
        jLabel_rt_eve2_type = new javax.swing.JLabel();
        jTextField_rt_eve2_type = new javax.swing.JTextField();
        jLabel_rt_allowed_tw_ms_min = new javax.swing.JLabel();
        jTextField_rt_allowed_tw_ms_min = new javax.swing.JTextField();
        jLabel_rt_allowed_tw_ms_max = new javax.swing.JLabel();
        jTextField_rt_allowed_tw_ms_max = new javax.swing.JTextField();
        jLabel_rt_output_folder = new javax.swing.JLabel();
        jTextField_rt_output_folder = new javax.swing.JTextField();
        jLabel_insert_baseline_trial = new javax.swing.JLabel();
        jLabel_insert_begin_trial = new javax.swing.JLabel();
        jLabel_marker_type_begin_baseline = new javax.swing.JLabel();
        jTextField_marker_type_begin_baseline = new javax.swing.JTextField();
        jTextField_insert_begin_trial_target_event_types = new javax.swing.JTextField();
        jLabel_insert_trial = new javax.swing.JLabel();
        jLabell_insert_baseline = new javax.swing.JLabel();
        jLabel_insert_begin_trial_delay = new javax.swing.JLabel();
        jTextField_insert_begin_trial_delay = new javax.swing.JTextField();
        jLabel_insert_begin_trial_target_event_types = new javax.swing.JLabel();
        jLabel_insert_block = new javax.swing.JLabel();
        jTextField_insert_block_trials_per_block = new javax.swing.JTextField();
        jLabel_montage_list = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTextArea_montage_list2 = new javax.swing.JTextArea();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTextArea_montage_list1 = new javax.swing.JTextArea();
        jLabel_insert_end_trial = new javax.swing.JLabel();
        jLabel_marker_type_end_baseline = new javax.swing.JLabel();
        jTextField_marker_type_end_baseline = new javax.swing.JTextField();
        jLabel_insert_end_trial_delay = new javax.swing.JLabel();
        jTextField_insert_end_trial_delay = new javax.swing.JTextField();
        jLabel_insert_end_trial_target_event_types = new javax.swing.JLabel();
        jLabel_insert_begin_baseline = new javax.swing.JLabel();
        jLabel_insert_end_baseline = new javax.swing.JLabel();
        jTextField_insert_end_baseline_target_event_types = new javax.swing.JTextField();
        jTextField_insert_begin_baseline_target_event_types = new javax.swing.JTextField();
        jLabel_insert_end_baseline_delay = new javax.swing.JLabel();
        jTextField_insert_end_baseline_delay = new javax.swing.JTextField();
        jLabel_insert_end_baseline_target_event_types = new javax.swing.JLabel();
        jLabel_insert_begin_baseline_delay = new javax.swing.JLabel();
        jTextField_insert_begin_baseline_delay = new javax.swing.JTextField();
        jLabel_insert_begin_baseline_target_event_types = new javax.swing.JLabel();
        jTextField_marker_type_begin_trial = new javax.swing.JTextField();
        jLabel_marker_type_begin_trial = new javax.swing.JLabel();
        jLabel_marker_type_end_trial = new javax.swing.JLabel();
        jTextField_marker_type_end_trial = new javax.swing.JTextField();
        jLabel_preproc = new javax.swing.JLabel();
        jTextField_insert_end_trial_target_event_types = new javax.swing.JTextField();

        setPreferredSize(new java.awt.Dimension(1143, 779));

        jPpreproc.setName("preproc"); // NOI18N
        jPpreproc.setPreferredSize(new java.awt.Dimension(1150, 750));

        jLabel_ff_global.setText("GLOBAL FILTER");

        jLabel_filter_algorithm.setText("filter algorythm");

        JComboBox_filter_algorithm.setName("filter_algorithm"); // NOI18N

        jLabel_ff1_global.setText("low");

        jTextField_ff1_global.setName("ff1_global"); // NOI18N

        jLabel_ff2_global.setText("high");

        jTextField_ff2_global.setName("ff2_global"); // NOI18N
        jTextField_ff2_global.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField_ff2_globalActionPerformed(evt);
            }
        });

        jLabel_output_folder.setText("output folder");

        jTextField_output_folder.setName("jTextField_output_folder"); // NOI18N

        jLabel_notch_fcenter.setText("center");

        jTextField_notch_fcenter.setName("notch_fcenter"); // NOI18N

        jLabel_notch.setText("NOTCH FILTER");

        jCheckBox_do_notch.setName("do_notch"); // NOI18N

        jLabel_notch_fspan.setText("span");

        jTextField_notch_fspan.setName("notch_fspan"); // NOI18N

        jLabel_notch_remove_armonics.setText("remove armonics");

        jComboBox_notch_remove_armonics.setName("notch_remove_armonics"); // NOI18N

        jLabel_EEGFilter.setText("EEG FILTER");

        jLabel_ff1_eeg.setText("low");

        jTextField_ff1_eeg.setName("ff1_eeg"); // NOI18N

        jLabel_ff2_eeg.setText("high");

        jTextField_ff2_eeg.setName("ff2_eeg"); // NOI18N

        jLabel_EOGFilter.setText("EOG FILTER");

        jLabel_ff1_eog.setText("low");

        jTextField_ff1_eog.setName("ff1_eog"); // NOI18N

        jLabel_ff2_eog.setText("high");

        jTextField_ff2_eog.setName("ff2_eog"); // NOI18N

        jLabel_EMGFilter.setText("EMG FILTER");

        jLabel_ff1_emg.setText("low");

        jTextField_ff1_emg.setName("ff1_emg"); // NOI18N

        jLabel_ff2_emg.setText("high");

        jTextField_ff2_emg.setName("ff2_emg"); // NOI18N

        jLabel_rt.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_rt.setText("Reaction Times");

        jLabel_rt_eve1_type.setText("eve1 type");

        jTextField_rt_eve1_type.setName("eve1_type"); // NOI18N

        jLabel_rt_eve2_type.setText("eve 2 type");

        jTextField_rt_eve2_type.setName("eve2_type"); // NOI18N

        jLabel_rt_allowed_tw_ms_min.setText("allowed tw MIN [ms]");

        jTextField_rt_allowed_tw_ms_min.setName("allowed_tw_ms_min"); // NOI18N

        jLabel_rt_allowed_tw_ms_max.setText("allowed tw MAX [ms]");

        jTextField_rt_allowed_tw_ms_max.setName("allowed_tw_ms_max"); // NOI18N

        jLabel_rt_output_folder.setText("output folder");

        jTextField_rt_output_folder.setName("output_folder"); // NOI18N

        jLabel_insert_baseline_trial.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_insert_baseline_trial.setText("Baseline and Trials Markers");

        jLabel_insert_begin_trial.setText("begin");

        jLabel_marker_type_begin_baseline.setText("type");

        jLabel_insert_trial.setText("Trial");

        jLabell_insert_baseline.setText("Baseline");

        jLabel_insert_begin_trial_delay.setText("delay");

        jLabel_insert_begin_trial_target_event_types.setText("event types");

        jLabel_insert_block.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_insert_block.setText("Block markers");

        jLabel_montage_list.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_montage_list.setText("Montages");

        jTextArea_montage_list2.setColumns(20);
        jTextArea_montage_list2.setRows(5);
        jTextArea_montage_list2.setEnabled(false);
        jScrollPane4.setViewportView(jTextArea_montage_list2);

        jTextArea_montage_list1.setColumns(20);
        jTextArea_montage_list1.setRows(5);
        jTextArea_montage_list1.setEnabled(false);
        jScrollPane5.setViewportView(jTextArea_montage_list1);

        jLabel_insert_end_trial.setText("end");

        jLabel_marker_type_end_baseline.setText("type");

        jLabel_insert_end_trial_delay.setText("delay");

        jLabel_insert_end_trial_target_event_types.setText("event types");

        jLabel_insert_begin_baseline.setText("begin");

        jLabel_insert_end_baseline.setText("end");

        jLabel_insert_end_baseline_delay.setText("delay");

        jLabel_insert_end_baseline_target_event_types.setText("event types");

        jLabel_insert_begin_baseline_delay.setText("delay");

        jLabel_insert_begin_baseline_target_event_types.setText("event types");

        jLabel_marker_type_begin_trial.setText("type");

        jLabel_marker_type_end_trial.setText("type");

        jLabel_preproc.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_preproc.setText("Preprocessing");

        javax.swing.GroupLayout jPpreprocLayout = new javax.swing.GroupLayout(jPpreproc);
        jPpreproc.setLayout(jPpreprocLayout);
        jPpreprocLayout.setHorizontalGroup(
            jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPpreprocLayout.createSequentialGroup()
                .addComponent(jLabel_montage_list, javax.swing.GroupLayout.PREFERRED_SIZE, 98, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 979, Short.MAX_VALUE)
                    .addComponent(jScrollPane5))
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(jPpreprocLayout.createSequentialGroup()
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel_rt, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_insert_baseline_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addComponent(jLabel_insert_block, javax.swing.GroupLayout.PREFERRED_SIZE, 98, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jTextField_insert_block_trials_per_block, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_ff_global, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addComponent(jLabel_notch, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox_do_notch)))
                        .addGap(21, 21, 21)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_notch_fcenter, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGap(4, 4, 4)
                                .addComponent(jLabel_ff1_global, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField_ff1_global, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jLabel_ff2_global, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField_ff2_global, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGap(2, 2, 2)
                                .addComponent(jLabel_output_folder)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(62, 62, 62)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_notch_remove_armonics, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addComponent(jLabel_filter_algorithm, javax.swing.GroupLayout.PREFERRED_SIZE, 82, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(JComboBox_filter_algorithm, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE))))))
                    .addComponent(jLabel_preproc, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPpreprocLayout.createSequentialGroup()
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel_insert_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabell_insert_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(26, 26, 26)
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_rt_eve1_type, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_insert_end_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_insert_begin_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_insert_end_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPpreprocLayout.createSequentialGroup()
                                            .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                                .addGroup(jPpreprocLayout.createSequentialGroup()
                                                    .addComponent(jLabel_marker_type_begin_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                    .addComponent(jTextField_marker_type_begin_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                .addGroup(jPpreprocLayout.createSequentialGroup()
                                                    .addComponent(jLabel_marker_type_end_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                    .addComponent(jTextField_marker_type_end_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                .addGroup(jPpreprocLayout.createSequentialGroup()
                                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                                        .addComponent(jLabel_marker_type_begin_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                        .addComponent(jLabel_marker_type_end_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                                        .addComponent(jTextField_marker_type_end_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                        .addComponent(jTextField_marker_type_begin_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))))
                                            .addGap(32, 32, 32)
                                            .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                                .addComponent(jLabel_insert_end_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addComponent(jLabel_insert_begin_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                            .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                                .addGroup(jPpreprocLayout.createSequentialGroup()
                                                    .addComponent(jTextField_insert_end_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addGap(52, 52, 52)
                                                    .addComponent(jLabel_insert_end_baseline_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                    .addComponent(jTextField_insert_end_baseline_target_event_types))
                                                .addGroup(jPpreprocLayout.createSequentialGroup()
                                                    .addComponent(jTextField_insert_begin_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addGap(52, 52, 52)
                                                    .addComponent(jLabel_insert_begin_baseline_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                    .addComponent(jTextField_insert_begin_baseline_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))))
                                        .addGroup(jPpreprocLayout.createSequentialGroup()
                                            .addGap(139, 139, 139)
                                            .addComponent(jLabel_insert_end_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                            .addComponent(jTextField_insert_end_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addGap(52, 52, 52)
                                            .addComponent(jLabel_insert_end_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                            .addComponent(jTextField_insert_end_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addGap(139, 139, 139)
                                        .addComponent(jLabel_insert_begin_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextField_insert_begin_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(51, 51, 51)
                                        .addComponent(jLabel_insert_begin_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextField_insert_begin_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addComponent(jTextField_notch_fcenter, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(18, 18, 18)
                                        .addComponent(jLabel_notch_fspan, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextField_notch_fspan, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addComponent(jTextField_rt_eve1_type, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(18, 18, 18)
                                        .addComponent(jLabel_rt_eve2_type, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextField_rt_eve2_type, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(47, 47, 47)
                                        .addComponent(jLabel_rt_allowed_tw_ms_min, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(2, 2, 2)
                                        .addComponent(jTextField_rt_allowed_tw_ms_min, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(18, 18, 18)
                                        .addComponent(jLabel_rt_allowed_tw_ms_max, javax.swing.GroupLayout.PREFERRED_SIZE, 106, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jTextField_rt_allowed_tw_ms_max, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(28, 28, 28)
                                        .addComponent(jLabel_rt_output_folder)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField_rt_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addGap(55, 55, 55)
                                        .addComponent(jComboBox_notch_remove_armonics, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                                .addComponent(jLabel_EEGFilter, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jLabel_ff1_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(2, 2, 2)
                                                .addComponent(jTextField_ff1_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jLabel_ff2_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_ff2_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                                .addComponent(jLabel_EOGFilter, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jLabel_ff1_eog, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(2, 2, 2)
                                                .addComponent(jTextField_ff1_eog, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jLabel_ff2_eog, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_ff2_eog, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                                .addComponent(jLabel_EMGFilter, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jLabel_ff1_emg, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(2, 2, 2)
                                                .addComponent(jTextField_ff1_emg, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jLabel_ff2_emg, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_ff2_emg, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                                .addGap(388, 388, 388))))
                    .addComponent(jLabel_insert_begin_trial, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPpreprocLayout.setVerticalGroup(
            jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPpreprocLayout.createSequentialGroup()
                .addComponent(jLabel_preproc)
                .addGap(12, 12, 12)
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_filter_algorithm)
                                    .addComponent(JComboBox_filter_algorithm, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_output_folder)
                                    .addComponent(jTextField_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(18, 18, 18)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_ff1_global)
                                    .addComponent(jTextField_ff1_global, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_ff2_global)
                                    .addComponent(jTextField_ff2_global, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_ff_global))
                                .addGap(18, 18, 18)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jComboBox_notch_remove_armonics, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel_notch_fcenter)
                                        .addComponent(jTextField_notch_fcenter, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_notch)
                                        .addComponent(jLabel_notch_fspan)
                                        .addComponent(jTextField_notch_fspan, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addComponent(jCheckBox_do_notch, javax.swing.GroupLayout.Alignment.TRAILING))
                        .addGap(49, 49, 49)
                        .addComponent(jLabel_rt)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_rt_eve1_type)
                            .addComponent(jTextField_rt_eve1_type, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_rt_eve2_type)
                            .addComponent(jTextField_rt_eve2_type, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_rt_allowed_tw_ms_min)
                            .addComponent(jTextField_rt_allowed_tw_ms_min, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_rt_allowed_tw_ms_max)
                            .addComponent(jTextField_rt_allowed_tw_ms_max, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_ff1_eeg)
                            .addComponent(jTextField_ff1_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_ff2_eeg)
                            .addComponent(jTextField_ff2_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_EEGFilter))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_ff1_eog)
                            .addComponent(jTextField_ff1_eog, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_ff2_eog)
                            .addComponent(jTextField_ff2_eog, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_EOGFilter)
                            .addComponent(jLabel_notch_remove_armonics))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_ff1_emg)
                            .addComponent(jTextField_ff1_emg, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_ff2_emg)
                            .addComponent(jTextField_ff2_emg, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_EMGFilter))
                        .addGap(77, 77, 77)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_rt_output_folder)
                            .addComponent(jTextField_rt_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGap(84, 84, 84)
                        .addComponent(jLabel_insert_trial)
                        .addGap(43, 43, 43)
                        .addComponent(jLabell_insert_baseline))
                    .addGroup(jPpreprocLayout.createSequentialGroup()
                        .addGap(45, 45, 45)
                        .addComponent(jLabel_insert_baseline_trial)
                        .addGap(20, 20, 20)
                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGap(1, 1, 1)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_marker_type_begin_trial)
                                    .addComponent(jTextField_marker_type_begin_trial, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_insert_begin_trial))
                                .addGap(5, 5, 5)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_marker_type_end_trial)
                                    .addComponent(jTextField_marker_type_end_trial, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_insert_end_trial)))
                            .addGroup(jPpreprocLayout.createSequentialGroup()
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPpreprocLayout.createSequentialGroup()
                                        .addGap(1, 1, 1)
                                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jTextField_insert_begin_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jLabel_insert_begin_trial_delay))
                                        .addGap(5, 5, 5))
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPpreprocLayout.createSequentialGroup()
                                        .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jTextField_insert_begin_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jLabel_insert_begin_trial_target_event_types))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel_insert_end_trial_delay)
                                        .addComponent(jTextField_insert_end_trial_delay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel_insert_end_trial_target_event_types)
                                        .addComponent(jTextField_insert_end_trial_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(18, 18, 18)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel_insert_begin_baseline_delay)
                                        .addComponent(jTextField_insert_begin_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_marker_type_begin_baseline)
                                        .addComponent(jTextField_marker_type_begin_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_insert_begin_baseline))
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jTextField_insert_begin_baseline_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_insert_begin_baseline_target_event_types)))
                                .addGap(5, 5, 5)
                                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel_insert_end_baseline_delay)
                                        .addComponent(jTextField_insert_end_baseline_delay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jTextField_marker_type_end_baseline, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_marker_type_end_baseline)
                                        .addComponent(jLabel_insert_end_baseline))
                                    .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jTextField_insert_end_baseline_target_event_types, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel_insert_end_baseline_target_event_types)))))))
                .addGap(22, 22, 22)
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_insert_block)
                    .addComponent(jTextField_insert_block_trials_per_block, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPpreprocLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel_montage_list)
                    .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(131, 131, 131))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jPpreproc, javax.swing.GroupLayout.PREFERRED_SIZE, 1151, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPpreproc, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTextField_ff2_globalActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField_ff2_globalActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField_ff2_globalActionPerformed
    
    private JTPMain controller;
    private Project project;
    private Preproc preproc;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox JComboBox_filter_algorithm;
    private javax.swing.JCheckBox jCheckBox_do_notch;
    private javax.swing.JComboBox jComboBox_notch_remove_armonics;
    private javax.swing.JLabel jLabel_EEGFilter;
    private javax.swing.JLabel jLabel_EMGFilter;
    private javax.swing.JLabel jLabel_EOGFilter;
    private javax.swing.JLabel jLabel_ff1_eeg;
    private javax.swing.JLabel jLabel_ff1_emg;
    private javax.swing.JLabel jLabel_ff1_eog;
    private javax.swing.JLabel jLabel_ff1_global;
    private javax.swing.JLabel jLabel_ff2_eeg;
    private javax.swing.JLabel jLabel_ff2_emg;
    private javax.swing.JLabel jLabel_ff2_eog;
    private javax.swing.JLabel jLabel_ff2_global;
    private javax.swing.JLabel jLabel_ff_global;
    private javax.swing.JLabel jLabel_filter_algorithm;
    private javax.swing.JLabel jLabel_insert_baseline_trial;
    private javax.swing.JLabel jLabel_insert_begin_baseline;
    private javax.swing.JLabel jLabel_insert_begin_baseline_delay;
    private javax.swing.JLabel jLabel_insert_begin_baseline_target_event_types;
    private javax.swing.JLabel jLabel_insert_begin_trial;
    private javax.swing.JLabel jLabel_insert_begin_trial_delay;
    private javax.swing.JLabel jLabel_insert_begin_trial_target_event_types;
    private javax.swing.JLabel jLabel_insert_block;
    private javax.swing.JLabel jLabel_insert_end_baseline;
    private javax.swing.JLabel jLabel_insert_end_baseline_delay;
    private javax.swing.JLabel jLabel_insert_end_baseline_target_event_types;
    private javax.swing.JLabel jLabel_insert_end_trial;
    private javax.swing.JLabel jLabel_insert_end_trial_delay;
    private javax.swing.JLabel jLabel_insert_end_trial_target_event_types;
    private javax.swing.JLabel jLabel_insert_trial;
    private javax.swing.JLabel jLabel_marker_type_begin_baseline;
    private javax.swing.JLabel jLabel_marker_type_begin_trial;
    private javax.swing.JLabel jLabel_marker_type_end_baseline;
    private javax.swing.JLabel jLabel_marker_type_end_trial;
    private javax.swing.JLabel jLabel_montage_list;
    private javax.swing.JLabel jLabel_notch;
    private javax.swing.JLabel jLabel_notch_fcenter;
    private javax.swing.JLabel jLabel_notch_fspan;
    private javax.swing.JLabel jLabel_notch_remove_armonics;
    private javax.swing.JLabel jLabel_output_folder;
    private javax.swing.JLabel jLabel_preproc;
    private javax.swing.JLabel jLabel_rt;
    private javax.swing.JLabel jLabel_rt_allowed_tw_ms_max;
    private javax.swing.JLabel jLabel_rt_allowed_tw_ms_min;
    private javax.swing.JLabel jLabel_rt_eve1_type;
    private javax.swing.JLabel jLabel_rt_eve2_type;
    private javax.swing.JLabel jLabel_rt_output_folder;
    private javax.swing.JLabel jLabell_insert_baseline;
    private javax.swing.JPanel jPpreproc;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JTextArea jTextArea_montage_list1;
    private javax.swing.JTextArea jTextArea_montage_list2;
    private javax.swing.JTextField jTextField_ff1_eeg;
    private javax.swing.JTextField jTextField_ff1_emg;
    private javax.swing.JTextField jTextField_ff1_eog;
    private javax.swing.JTextField jTextField_ff1_global;
    private javax.swing.JTextField jTextField_ff2_eeg;
    private javax.swing.JTextField jTextField_ff2_emg;
    private javax.swing.JTextField jTextField_ff2_eog;
    private javax.swing.JTextField jTextField_ff2_global;
    private javax.swing.JTextField jTextField_insert_begin_baseline_delay;
    private javax.swing.JTextField jTextField_insert_begin_baseline_target_event_types;
    private javax.swing.JTextField jTextField_insert_begin_trial_delay;
    private javax.swing.JTextField jTextField_insert_begin_trial_target_event_types;
    private javax.swing.JTextField jTextField_insert_block_trials_per_block;
    private javax.swing.JTextField jTextField_insert_end_baseline_delay;
    private javax.swing.JTextField jTextField_insert_end_baseline_target_event_types;
    private javax.swing.JTextField jTextField_insert_end_trial_delay;
    private javax.swing.JTextField jTextField_insert_end_trial_target_event_types;
    private javax.swing.JTextField jTextField_marker_type_begin_baseline;
    private javax.swing.JTextField jTextField_marker_type_begin_trial;
    private javax.swing.JTextField jTextField_marker_type_end_baseline;
    private javax.swing.JTextField jTextField_marker_type_end_trial;
    private javax.swing.JTextField jTextField_notch_fcenter;
    private javax.swing.JTextField jTextField_notch_fspan;
    private javax.swing.JTextField jTextField_output_folder;
    private javax.swing.JTextField jTextField_rt_allowed_tw_ms_max;
    private javax.swing.JTextField jTextField_rt_allowed_tw_ms_min;
    private javax.swing.JTextField jTextField_rt_eve1_type;
    private javax.swing.JTextField jTextField_rt_eve2_type;
    private javax.swing.JTextField jTextField_rt_output_folder;
    // End of variables declaration//GEN-END:variables
}
