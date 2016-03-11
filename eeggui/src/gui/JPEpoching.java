/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import javax.swing.JLabel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import structures.Epoching;
import structures.Project;

/**
 *
 * @author alba
 */
public class JPEpoching extends javax.swing.JPanel {

    private JTPMain controller;
    public Epoching epoching;
    public Project project;
    ModelTable_mrkcode_cond jTableDM_mrkcode_cond;
    
    
    public JPEpoching(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        epoching = project.epoching;
        
        initGUI();
        
        jComboBox_baseline_replace_mode.setSelectedItem(epoching.baseline_replace.mode);
        jComboBox_replace_baseline_originalposition.setSelectedItem(epoching.baseline_replace.baseline_originalposition);
        jComboBox_replace_baseline_finalposition.setSelectedItem(epoching.baseline_replace.baseline_finalposition);
        jComboBox_replace_baseline_replace.setSelectedItem(epoching.baseline_replace.replace);
        
        jTextField_input_suffix.setText(epoching.input_suffix);
        jTextField_input_folder.setText(epoching.input_folder);
        
        jComboBox_bc_type.setSelectedItem(epoching.bc_type);
        
        if (epoching.epo_st.s!=null)
        {jTextField_epo_st.setText(String.valueOf(epoching.epo_st.s[0]));}
        if (epoching.epo_end.s!=null)
        {jTextField_epo_end.setText(String.valueOf(epoching.epo_end.s[0]));}
        if (epoching.bc_st.s!=null)
        {jTextField_bc_st.setText(String.valueOf(epoching.bc_st.s[0]));}
        if (epoching.bc_end.s!=null)
        {jTextField_bc_end.setText(String.valueOf(epoching.bc_end.s[0]));}
        
        if (epoching.baseline_duration.s!=null)
        {jTextField_baseline_duration.setText(String.valueOf(epoching.baseline_duration.s[0]));}
        
        if (epoching.bc_st_point!=null)
        {jTextField_bc_st_point.setText(String.valueOf(epoching.bc_st_point[0]));}
        if (epoching.bc_end_point!=null)
        {jTextField_bc_end_point.setText(String.valueOf(epoching.bc_end_point[0]));}
        
        if (epoching.emg_epo_st.s!=null)
        {jTextField_emg_epo_st.setText(String.valueOf(epoching.emg_epo_st.s[0]));}
        if (epoching.emg_epo_end.s!=null)
        {jTextField_emg_epo_end.setText(String.valueOf(epoching.emg_epo_end.s[0]));}
        if (epoching.emg_bc_st.s!=null)
        {jTextField_emg_bc_st.setText(String.valueOf(epoching.emg_bc_st.s[0]));}
        if (epoching.emg_bc_end.s!=null)
        {jTextField_emg_bc_end.setText(String.valueOf(epoching.emg_bc_end.s[0]));}
        
        if (epoching.bc_st_point!=null)
        {jTextField_bc_st_point.setText(String.valueOf(epoching.bc_st_point[0]));}
        if (epoching.bc_end_point!=null)
        {jTextField_bc_end_point.setText(String.valueOf(epoching.bc_end_point[0]));}
        if (epoching.emg_bc_st_point!=null)
        {jTextField_emg_bc_st_point.setText(String.valueOf(epoching.emg_bc_st_point[0]));}
        if (epoching.emg_bc_end_point!=null)
        {jTextField_emg_bc_end_point.setText(String.valueOf(epoching.emg_bc_end_point[0]));}
        
        setTable_mrkcode_cond();
    }
    
    public void initGUI()
    {
        initTable_mrkcode_cond(1);
        
        initComboBox_baseline_replace_mode();
        initComboBox_replace_baseline_originalposition();
        initComboBox_replace_baseline_finalposition();
        initComboBox_replace_baseline_replace();
        initComboBox_bc_type();
    }
    
    public Epoching getGUI()
    {
        epoching.baseline_replace.mode                         = (String) jComboBox_baseline_replace_mode.getSelectedItem();
        epoching.baseline_replace.baseline_originalposition    = (String) jComboBox_replace_baseline_originalposition.getSelectedItem();
        epoching.baseline_replace.baseline_finalposition       = (String) jComboBox_replace_baseline_finalposition.getSelectedItem();
        epoching.baseline_replace.replace                      = (String) jComboBox_replace_baseline_replace.getSelectedItem();
        
        epoching.input_suffix             = jTextField_input_suffix.getText();
        epoching.input_folder             = jTextField_input_folder.getText();
        
        epoching.bc_type                  = (String) jComboBox_bc_type.getSelectedItem();
        
        epoching.epo_st.s[0]              = Double.parseDouble((String) jTextField_epo_st.getText());
        epoching.epo_st.ms[0]             = epoching.epo_st.s[0]*1000;
        epoching.epo_end.s[0]             = Double.parseDouble((String) jTextField_epo_end.getText());
        epoching.epo_end.ms[0]            = epoching.epo_end.s[0]*1000;
        epoching.bc_st.s[0]               = Double.parseDouble((String) jTextField_bc_st.getText());
        epoching.bc_st.ms[0]              = epoching.bc_st.s[0]*1000;
        epoching.bc_end.s[0]              = Double.parseDouble((String) jTextField_bc_end.getText());
        epoching.bc_end.ms[0]             = epoching.bc_end.s[0]*1000;
        epoching.baseline_duration.s[0]   = Double.parseDouble((String) jTextField_baseline_duration.getText());
        epoching.baseline_duration.ms[0]  = epoching.baseline_duration.s[0]*1000;
        
        epoching.bc_st_point[0]           = Double.parseDouble((String) jTextField_bc_st_point.getText());
        epoching.bc_end_point[0]          = Double.parseDouble((String) jTextField_bc_end_point.getText());
        
        epoching.emg_epo_st.s[0]          = Double.parseDouble((String) jTextField_emg_epo_st.getText());
        epoching.emg_epo_st.ms[0]         = epoching.emg_epo_st.s[0]*1000;
        epoching.emg_epo_end.s[0]         = Double.parseDouble((String) jTextField_emg_epo_end.getText());
        epoching.emg_epo_end.ms[0]        = epoching.emg_epo_end.s[0]*1000;
        epoching.emg_bc_st.s[0]           = Double.parseDouble((String) jTextField_emg_bc_st.getText());
        epoching.emg_bc_st.ms[0]          = epoching.emg_bc_st.s[0]*1000;
        epoching.emg_bc_end.s[0]          = Double.parseDouble((String) jTextField_emg_bc_end.getText());
        epoching.emg_bc_end.ms[0]         = epoching.emg_bc_end.s[0]*1000;
        
        epoching.bc_st_point[0]           = Double.parseDouble((String) jTextField_emg_bc_st_point.getText());
        epoching.bc_end_point[0]          = Double.parseDouble((String) jTextField_emg_bc_end_point.getText());

        epoching.numcond[0]               = jTable_mrkcode_cond.getRowCount();
        
        getTable_mrkcode_cond();

        return epoching;
    }
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    
    private void initTable_mrkcode_cond(int nb_row)
    {
        String[] columnNames = {"Name","Triggers codes"};  
        Object[][] data = new Object[nb_row][columnNames.length];
        jTableDM_mrkcode_cond = new ModelTable_mrkcode_cond(data,columnNames);
        jTable_mrkcode_cond.setModel(jTableDM_mrkcode_cond);     
    }
    
    class ModelTable_mrkcode_cond extends DefaultTableModel {
 
    public ModelTable_mrkcode_cond(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
        return String.class;
    }
 
    @Override
      public boolean isCellEditable(int row, int col) {
        if (col == 1)   
            return false;
        else return true;
      }
    }
    
    private void initComboBox_baseline_replace_mode()
    {
        jComboBox_baseline_replace_mode.addItem("trial");
        jComboBox_baseline_replace_mode.addItem("external");
        jComboBox_baseline_replace_mode.addItem("none");
    }
    
    private void initComboBox_replace_baseline_originalposition()
    {
        jComboBox_replace_baseline_originalposition.addItem("before");
        jComboBox_replace_baseline_originalposition.addItem("after");
    }
    
    private void initComboBox_replace_baseline_finalposition()
    {
        jComboBox_replace_baseline_finalposition.addItem("before");
        jComboBox_replace_baseline_finalposition.addItem("after");
    }
    
    private void initComboBox_replace_baseline_replace()
    {
        jComboBox_replace_baseline_replace.addItem("all");
        jComboBox_replace_baseline_replace.addItem("part");
    }
    
    private void initComboBox_bc_type()
    {
        jComboBox_bc_type.addItem("global");
        jComboBox_bc_type.addItem("condition");
        jComboBox_bc_type.addItem("trial");
    }
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_mrkcode_cond()
    {  
        int l_mrkcode = project.task.events.mrkcode_cond.length;
        initTable_mrkcode_cond(l_mrkcode);       

        for (int i = 0; i < project.task.events.mrkcode_cond.length; i++) 
        {
            String str_mrkcode = new String("");
            for (int j = 0; j < project.task.events.mrkcode_cond[0].length; j++) 
            {
                if (j==0)
                {str_mrkcode = str_mrkcode + project.task.events.mrkcode_cond[i][j];}
                else
                {str_mrkcode = str_mrkcode + "," + project.task.events.mrkcode_cond[i][j];}
            }
            jTable_mrkcode_cond.setValueAt(str_mrkcode, i, 1);
            jTable_mrkcode_cond.setValueAt(project.epoching.condition_names[i], i, 0);
        } 
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int j = 0; j < jTable_mrkcode_cond.getColumnCount(); j++) 
        {jTable_mrkcode_cond.getColumnModel().getColumn(j).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_mrkcode_cond.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    // ---------------------------------------------------------------------------
    // GET GUI
    
    private void getTable_mrkcode_cond()
    {    
        int l_row = jTable_mrkcode_cond.getRowCount();
        
        int max_l_mrkcode = 0; int l_mrkcode = 0;
        for (int i = 0; i < l_row; i++) 
        {
            String str_to_cut = (String) jTable_mrkcode_cond.getModel().getValueAt(i,1);
            String[] str_cut  = str_to_cut.split(",");
            if (str_cut.length>max_l_mrkcode)
            {
                max_l_mrkcode = str_cut.length;
            }
        }
        
        epoching.condition_names = new String[l_row];
        epoching.mrkcode_cond = new String[l_row][max_l_mrkcode];
        epoching.valid_marker = new String[l_row*max_l_mrkcode];
        
        int compt = 0;
        for (int i2 = 0; i2 < l_row; i2++) 
        {
            epoching.condition_names[i2] = (String) jTable_mrkcode_cond.getModel().getValueAt(i2,0);
            String str_to_cut = (String) jTable_mrkcode_cond.getModel().getValueAt(i2,1);
            String[] str_cut  = str_to_cut.split(",");
            for (int j = 0; j < str_cut.length; j++) 
            {
                epoching.mrkcode_cond[i2][j] = str_cut[j];
                epoching.valid_marker[compt] = str_cut[j];
                compt++;
            }
        } 
    }
    

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPepoching = new javax.swing.JPanel();
        jLabel_baseline_replace_mode = new javax.swing.JLabel();
        jComboBox_baseline_replace_mode = new javax.swing.JComboBox();
        jLabel_baseline_replace = new javax.swing.JLabel();
        jLabel_baseline_replace_baseline_originalposition = new javax.swing.JLabel();
        jComboBox_replace_baseline_originalposition = new javax.swing.JComboBox();
        jLabel_replace_baseline_finalposition = new javax.swing.JLabel();
        jComboBox_replace_baseline_finalposition = new javax.swing.JComboBox();
        jScrollPane10 = new javax.swing.JScrollPane();
        jTable_mrkcode_cond = new javax.swing.JTable();
        jLabel_replace_baseline_replace = new javax.swing.JLabel();
        jComboBox_replace_baseline_replace = new javax.swing.JComboBox();
        jLabel_epo_eeg = new javax.swing.JLabel();
        jLabel_input_suffix = new javax.swing.JLabel();
        jLabel_input_folder = new javax.swing.JLabel();
        jTextField_input_suffix = new javax.swing.JTextField();
        jTextField_input_folder = new javax.swing.JTextField();
        jLabel_bc_type = new javax.swing.JLabel();
        jComboBox_bc_type = new javax.swing.JComboBox();
        jLabel_eeg_bc = new javax.swing.JLabel();
        jLabel_epo_st = new javax.swing.JLabel();
        jTextField_epo_st = new javax.swing.JTextField();
        jLabel_epo_end = new javax.swing.JLabel();
        jTextField_epo_end = new javax.swing.JTextField();
        jLabel_bc_st = new javax.swing.JLabel();
        jTextField_bc_st = new javax.swing.JTextField();
        jLabel_bc_end = new javax.swing.JLabel();
        jTextField_bc_end = new javax.swing.JTextField();
        jLabel_EEGBaselineDurationLatency = new javax.swing.JLabel();
        jTextField_baseline_duration = new javax.swing.JTextField();
        jLabel_emg_epo = new javax.swing.JLabel();
        jLabel_emg_epo_st = new javax.swing.JLabel();
        jLabel_emg_epo_end = new javax.swing.JLabel();
        jTextField_emg_epo_st = new javax.swing.JTextField();
        jTextField_emg_epo_end = new javax.swing.JTextField();
        jLabel_emg_bc = new javax.swing.JLabel();
        jLabel_emg_bc_st = new javax.swing.JLabel();
        jTextField_emg_bc_st = new javax.swing.JTextField();
        jLabel_emg_bc_end = new javax.swing.JLabel();
        jTextField_emg_bc_end = new javax.swing.JTextField();
        jLabel_emg_bc_st_point = new javax.swing.JLabel();
        jTextField_emg_bc_st_point = new javax.swing.JTextField();
        jLabel_emg_bc_end_point = new javax.swing.JLabel();
        jTextField_emg_bc_end_point = new javax.swing.JTextField();
        jLabel_bc_st_point = new javax.swing.JLabel();
        jTextField_bc_st_point = new javax.swing.JTextField();
        jLabel_EEGBaselineEndPoint = new javax.swing.JLabel();
        jTextField_bc_end_point = new javax.swing.JTextField();
        jLabel_mrkcode_cond = new javax.swing.JLabel();
        jLabel_epoching = new javax.swing.JLabel();

        jPepoching.setName("epoching"); // NOI18N

        jLabel_baseline_replace_mode.setText("mode");

        jComboBox_baseline_replace_mode.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        jComboBox_baseline_replace_mode.setName(""); // NOI18N

        jLabel_baseline_replace.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_baseline_replace.setText("Baseline Replace");

        jLabel_baseline_replace_baseline_originalposition.setText("original position");

        jLabel_replace_baseline_finalposition.setText("final position");

        jTable_mrkcode_cond.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Name", "triggers codes"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTable_mrkcode_cond.getTableHeader().setReorderingAllowed(false);
        jScrollPane10.setViewportView(jTable_mrkcode_cond);

        jLabel_replace_baseline_replace.setText("replace");

        jLabel_epo_eeg.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_epo_eeg.setText("EEG Epochs");

        jLabel_input_suffix.setText("input suffix");

        jLabel_input_folder.setText("input folder");

        jLabel_bc_type.setText("baseline correction type");

        jLabel_eeg_bc.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_eeg_bc.setText("EEG Baseline Correction");

        jLabel_epo_st.setText("start latency (s)");

        jLabel_epo_end.setText("end latency (s)");

        jLabel_bc_st.setText("start latency (s)");

        jLabel_bc_end.setText("end latency (s)");

        jLabel_EEGBaselineDurationLatency.setText("baseline duration");

        jTextField_baseline_duration.setEnabled(false);

        jLabel_emg_epo.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_emg_epo.setText("EMG Epochs");

        jLabel_emg_epo_st.setText("start latency (s)");

        jLabel_emg_epo_end.setText("end latency (s)");

        jLabel_emg_bc.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_emg_bc.setText("EMG Baseline Correction");

        jLabel_emg_bc_st.setText("start latency (s)");

        jLabel_emg_bc_end.setText("end latency (s)");

        jLabel_emg_bc_st_point.setText("start point");

        jTextField_emg_bc_st_point.setEnabled(false);

        jLabel_emg_bc_end_point.setText("end point");

        jTextField_emg_bc_end_point.setEnabled(false);

        jLabel_bc_st_point.setText("start point");

        jTextField_bc_st_point.setEnabled(false);

        jLabel_EEGBaselineEndPoint.setText("end point");

        jTextField_bc_end_point.setEnabled(false);

        jLabel_mrkcode_cond.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_mrkcode_cond.setText("Markers code");

        jLabel_epoching.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_epoching.setText("Epoching");

        javax.swing.GroupLayout jPepochingLayout = new javax.swing.GroupLayout(jPepoching);
        jPepoching.setLayout(jPepochingLayout);
        jPepochingLayout.setHorizontalGroup(
            jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPepochingLayout.createSequentialGroup()
                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPepochingLayout.createSequentialGroup()
                        .addGap(67, 67, 67)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPepochingLayout.createSequentialGroup()
                                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addGroup(jPepochingLayout.createSequentialGroup()
                                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                                .addGroup(jPepochingLayout.createSequentialGroup()
                                                    .addComponent(jLabel_emg_epo_st)
                                                    .addGap(13, 13, 13)
                                                    .addComponent(jTextField_emg_epo_st, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                .addGroup(jPepochingLayout.createSequentialGroup()
                                                    .addComponent(jLabel_emg_epo_end)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                    .addComponent(jTextField_emg_epo_end, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                            .addGap(54, 54, 54))
                                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPepochingLayout.createSequentialGroup()
                                            .addComponent(jLabel_input_suffix)
                                            .addGap(18, 18, 18)
                                            .addComponent(jTextField_input_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addComponent(jLabel_input_folder)
                                        .addGap(18, 18, 18)
                                        .addComponent(jTextField_input_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addGap(30, 30, 30)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_emg_bc, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                                .addGroup(jPepochingLayout.createSequentialGroup()
                                                    .addComponent(jLabel_epo_end)
                                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                    .addComponent(jTextField_epo_end, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                .addGroup(jPepochingLayout.createSequentialGroup()
                                                    .addComponent(jLabel_epo_st)
                                                    .addGap(13, 13, 13)
                                                    .addComponent(jTextField_epo_st, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addGap(116, 116, 116)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_emg_bc_end)
                                            .addComponent(jLabel_emg_bc_st))
                                        .addGap(16, 16, 16)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField_emg_bc_st, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField_emg_bc_end, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE))))
                                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addGap(56, 56, 56)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_emg_bc_end_point)
                                            .addComponent(jLabel_emg_bc_st_point))
                                        .addGap(16, 16, 16)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                            .addComponent(jTextField_emg_bc_st_point, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField_emg_bc_end_point, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addGap(271, 271, 271)
                                        .addComponent(jLabel_bc_end))
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addGap(271, 271, 271)
                                        .addComponent(jLabel_EEGBaselineDurationLatency))))
                            .addGroup(jPepochingLayout.createSequentialGroup()
                                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addComponent(jScrollPane10, javax.swing.GroupLayout.PREFERRED_SIZE, 696, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(40, 40, 40))
                                    .addGroup(jPepochingLayout.createSequentialGroup()
                                        .addComponent(jLabel_baseline_replace_mode, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jComboBox_baseline_replace_mode, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(52, 52, 52)
                                        .addComponent(jLabel_baseline_replace_baseline_originalposition, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jComboBox_replace_baseline_originalposition, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(55, 55, 55)
                                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel_eeg_bc, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addGroup(jPepochingLayout.createSequentialGroup()
                                                .addComponent(jLabel_replace_baseline_finalposition, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jComboBox_replace_baseline_finalposition, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(58, 58, 58)
                                                .addComponent(jLabel_replace_baseline_replace, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(jPepochingLayout.createSequentialGroup()
                                                .addGap(10, 10, 10)
                                                .addComponent(jLabel_bc_type)
                                                .addGap(18, 18, 18)
                                                .addComponent(jComboBox_bc_type, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jComboBox_replace_baseline_replace, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_bc_st))))
                        .addGap(18, 18, 18)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField_bc_end, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField_bc_st, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField_baseline_duration, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(33, 33, 33)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_EEGBaselineEndPoint, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_bc_st_point, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField_bc_st_point, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField_bc_end_point, javax.swing.GroupLayout.PREFERRED_SIZE, 60, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPepochingLayout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_baseline_replace, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_emg_epo, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_mrkcode_cond, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_epo_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_epoching))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPepochingLayout.setVerticalGroup(
            jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPepochingLayout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jLabel_epoching)
                .addGap(15, 15, 15)
                .addComponent(jLabel_baseline_replace)
                .addGap(18, 18, 18)
                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPepochingLayout.createSequentialGroup()
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_baseline_replace_mode)
                            .addComponent(jComboBox_baseline_replace_mode, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(33, 33, 33)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_epo_eeg)
                            .addComponent(jLabel_eeg_bc)))
                    .addGroup(jPepochingLayout.createSequentialGroup()
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_replace_baseline_finalposition)
                                .addComponent(jComboBox_replace_baseline_finalposition, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel_baseline_replace_baseline_originalposition)
                                .addComponent(jComboBox_replace_baseline_originalposition, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_replace_baseline_replace)
                                .addComponent(jComboBox_replace_baseline_replace, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(50, 50, 50)))
                .addGap(12, 12, 12)
                .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPepochingLayout.createSequentialGroup()
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_input_suffix)
                            .addComponent(jTextField_input_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_epo_st)
                            .addComponent(jTextField_epo_st, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_bc_type)
                            .addComponent(jComboBox_bc_type, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_bc_st)
                            .addComponent(jTextField_bc_st, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_bc_st_point)
                            .addComponent(jTextField_bc_st_point, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_input_folder)
                            .addComponent(jTextField_input_folder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_epo_end)
                            .addComponent(jTextField_epo_end, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_bc_end)
                            .addComponent(jTextField_bc_end, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_EEGBaselineEndPoint)
                            .addComponent(jTextField_bc_end_point, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_EEGBaselineDurationLatency)
                            .addComponent(jTextField_baseline_duration, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(17, 17, 17)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_emg_epo)
                            .addComponent(jLabel_emg_bc))
                        .addGap(18, 18, 18)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_emg_epo_st)
                            .addComponent(jTextField_emg_epo_st, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_emg_epo_end)
                            .addComponent(jTextField_emg_epo_end, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPepochingLayout.createSequentialGroup()
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_emg_bc_st_point)
                                .addComponent(jTextField_emg_bc_st_point, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGap(17, 17, 17)
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_emg_bc_end_point)
                                .addComponent(jTextField_emg_bc_end_point, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(jPepochingLayout.createSequentialGroup()
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_emg_bc_st)
                                .addComponent(jTextField_emg_bc_st, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGap(17, 17, 17)
                            .addGroup(jPepochingLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_emg_bc_end)
                                .addComponent(jTextField_emg_bc_end, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addGap(49, 49, 49)
                .addComponent(jLabel_mrkcode_cond)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane10, javax.swing.GroupLayout.PREFERRED_SIZE, 213, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(108, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPepoching, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 7, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPepoching, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox jComboBox_baseline_replace_mode;
    private javax.swing.JComboBox jComboBox_bc_type;
    private javax.swing.JComboBox jComboBox_replace_baseline_finalposition;
    private javax.swing.JComboBox jComboBox_replace_baseline_originalposition;
    private javax.swing.JComboBox jComboBox_replace_baseline_replace;
    private javax.swing.JLabel jLabel_EEGBaselineDurationLatency;
    private javax.swing.JLabel jLabel_EEGBaselineEndPoint;
    private javax.swing.JLabel jLabel_baseline_replace;
    private javax.swing.JLabel jLabel_baseline_replace_baseline_originalposition;
    private javax.swing.JLabel jLabel_baseline_replace_mode;
    private javax.swing.JLabel jLabel_bc_end;
    private javax.swing.JLabel jLabel_bc_st;
    private javax.swing.JLabel jLabel_bc_st_point;
    private javax.swing.JLabel jLabel_bc_type;
    private javax.swing.JLabel jLabel_eeg_bc;
    private javax.swing.JLabel jLabel_emg_bc;
    private javax.swing.JLabel jLabel_emg_bc_end;
    private javax.swing.JLabel jLabel_emg_bc_end_point;
    private javax.swing.JLabel jLabel_emg_bc_st;
    private javax.swing.JLabel jLabel_emg_bc_st_point;
    private javax.swing.JLabel jLabel_emg_epo;
    private javax.swing.JLabel jLabel_emg_epo_end;
    private javax.swing.JLabel jLabel_emg_epo_st;
    private javax.swing.JLabel jLabel_epo_eeg;
    private javax.swing.JLabel jLabel_epo_end;
    private javax.swing.JLabel jLabel_epo_st;
    private javax.swing.JLabel jLabel_epoching;
    private javax.swing.JLabel jLabel_input_folder;
    private javax.swing.JLabel jLabel_input_suffix;
    private javax.swing.JLabel jLabel_mrkcode_cond;
    private javax.swing.JLabel jLabel_replace_baseline_finalposition;
    private javax.swing.JLabel jLabel_replace_baseline_replace;
    private javax.swing.JPanel jPepoching;
    private javax.swing.JScrollPane jScrollPane10;
    private javax.swing.JTable jTable_mrkcode_cond;
    private javax.swing.JTextField jTextField_baseline_duration;
    private javax.swing.JTextField jTextField_bc_end;
    private javax.swing.JTextField jTextField_bc_end_point;
    private javax.swing.JTextField jTextField_bc_st;
    private javax.swing.JTextField jTextField_bc_st_point;
    private javax.swing.JTextField jTextField_emg_bc_end;
    private javax.swing.JTextField jTextField_emg_bc_end_point;
    private javax.swing.JTextField jTextField_emg_bc_st;
    private javax.swing.JTextField jTextField_emg_bc_st_point;
    private javax.swing.JTextField jTextField_emg_epo_end;
    private javax.swing.JTextField jTextField_emg_epo_st;
    private javax.swing.JTextField jTextField_epo_end;
    private javax.swing.JTextField jTextField_epo_st;
    private javax.swing.JTextField jTextField_input_folder;
    private javax.swing.JTextField jTextField_input_suffix;
    // End of variables declaration//GEN-END:variables
}
