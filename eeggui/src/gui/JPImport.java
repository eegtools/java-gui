/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import javax.swing.DefaultCellEditor;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import structures.Import;
import structures.Project;

/**
 *
 * @author alba
 */
public class JPImport extends javax.swing.JPanel {

    private Import imp;
    private Project project;
    private JTPMain controller;
    ModelTable_ch2transform jTableDM_ch2transform;
    ModelTable_final_channels_list jTableDM_final_channels_list;
    
    public JPImport(JTPMain ctrl) 
    {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI()
    {
        initTable_ch2transform(1);
        initTable_final_channels_list(1);
        initComboBox_acquisition_system();
        initComboBox_reference_channels();
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        imp = project.imp;
        
        initGUI();
        
        setTable_ch2transform();
        setTable_final_channels_list();
        setTextField_valid_marker();
        
        if (imp.acquisition_system.equals("BIOSEMI"))
        {jComboBox_acquisition_system.setSelectedIndex(0);
        jTextField_original_data_extension.setText(".bdf");}
        else if (imp.acquisition_system.equals("BRAINVISION"))
        {jComboBox_acquisition_system.setSelectedIndex(1);
        jTextField_original_data_extension.setText(".vhdr");}
        
        imp.reference_channels[0] = "test";
        if (imp.reference_channels[0].equals("CAR"))
        {jComboBox_reference_channels.setSelectedIndex(0);}
        else if (imp.reference_channels[0].equals("none"))
        {jComboBox_reference_channels.setSelectedIndex(1);}
        else
        {jComboBox_reference_channels.setSelectedIndex(2);
        jTextField_reference_channels.enable(true);
        jTextField_reference_channels.setText(imp.reference_channels[0]);}
        
        jTextField_original_data_folder.setText(imp.original_data_folder);
        jTextField_original_data_prefix.setText(imp.original_data_prefix);
        jTextField_original_data_suffix.setText(imp.original_data_suffix);
        
        jTextField_output_folder.setText(imp.output_folder);
        jTextField_output_suffix.setText(imp.output_suffix);
        
        jTextField_example_input.setText(imp.original_data_folder+imp.original_data_prefix+imp.original_data_suffix);
        jTextField_example_output.setText(imp.output_folder+imp.output_suffix);
        
        jTextField_nch.setText(String.valueOf((int)imp.nch[0]));
        jTextField_nch_eeg.setText(String.valueOf((int)imp.nch_eeg[0]));
        jTextField_fs.setText(String.valueOf((int)imp.fs[0]));
        
        jTextField_eeglab_channels_file_name.setText(imp.eeglab_channels_file_name);
        jTextField_eeglab_channels_file_path.setText(imp.eeglab_channels_file_path);
    }
    
    public Import getGUI()
    {
        imp.acquisition_system          = (String) jComboBox_acquisition_system.getSelectedItem();
        
        imp.original_data_extension     = jTextField_original_data_extension.getText();
        imp.original_data_folder        = jTextField_original_data_folder.getText();
        imp.original_data_suffix        = jTextField_original_data_suffix.getText();
        imp.original_data_prefix        = jTextField_original_data_prefix.getText();
        imp.output_folder               = jTextField_output_folder.getText();
        imp.output_suffix               = jTextField_output_suffix.getText();
        
        imp.nch[0]                      = Double.parseDouble(jTextField_nch.getText());
        imp.nch_eeg[0]                  = Double.parseDouble(jTextField_nch_eeg.getText());
        
        int c_emg = 0; int c_eog = 0; 
        for (int i = 0; i < jTable_ch2transform.getRowCount(); i++) 
        {
            if (jTable_ch2transform.getValueAt(i,1) != null)
            {
            String type_channel = (String) jTable_ch2transform.getValueAt(i,1);
            if (type_channel.equals("emg"))
                {c_emg++;}
            else if (type_channel.equals("eog"))
                {c_eog++;}
            }
            
            if (jTable_ch2transform.getModel().getValueAt(i,0)!=null)
            {imp.ch2transform[i].new_label  = (String) jTable_ch2transform.getModel().getValueAt(i,0);}
            else {imp.ch2transform[i].new_label = "";}
            if (jTable_ch2transform.getModel().getValueAt(i,1)!=null)
            {imp.ch2transform[i].type  = (String) jTable_ch2transform.getModel().getValueAt(i,1);}
            else {imp.ch2transform[i].type = "";}
            if (jTable_ch2transform.getModel().getValueAt(i,2)!=null)
            {imp.ch2transform[i].ch1[0]  = (Double) jTable_ch2transform.getModel().getValueAt(i,2);}
            else {imp.ch2transform[i].ch1 = null;}
            if (jTable_ch2transform.getModel().getValueAt(i,3)!=null)
            {imp.ch2transform[i].ch2[0]  = (Double) jTable_ch2transform.getModel().getValueAt(i,3);}
            else {imp.ch2transform[i].ch2 = null;}
        }
        
                
        imp.eeg_channels_list = new double[(int) imp.nch_eeg[0]];
        for (int i = 0; i < imp.nch_eeg[0] ; i++) 
        {imp.eeg_channels_list[i]=i;}
        
        imp.emg_channels_list = new double[c_emg];
        imp.emg_channels_list_labels = new String[c_emg];
        imp.eog_channels_list = new double[c_eog];
        imp.eog_channels_list_labels = new String[c_eog];
        imp.no_eeg_channels_list = new double[c_emg+c_eog];
        int i_eeg = 0; int i_no_eeg = 0; int i_emg = 0; int i_eog = 0;
        for (int i = 0; i < jTable_final_channels_list.getRowCount(); i++) 
        {
            if (jTable_final_channels_list.getValueAt(i,2)!=null)
            {
            String type_channel = (String) jTable_final_channels_list.getValueAt(i,2);
            if (type_channel.equals("eeg"))
            {
                imp.eeg_channels_list[i_eeg] = Double.parseDouble((String) jTable_final_channels_list.getValueAt(i, 0));
                i_eeg++;
            }
            else if (type_channel.equals("emg"))
            {
                imp.no_eeg_channels_list[i_no_eeg] = Double.parseDouble((String) jTable_final_channels_list.getValueAt(i, 0));
                i_no_eeg++;
                
                imp.emg_channels_list[i_emg] = Double.parseDouble((String) jTable_final_channels_list.getValueAt(i, 0));
                imp.emg_channels_list_labels[i_emg] = (String) jTable_final_channels_list.getValueAt(i, 1);
                i_emg++;
            }
            else if (type_channel.equals("eog"))
            {
                imp.no_eeg_channels_list[i_no_eeg] = Double.parseDouble((String) jTable_final_channels_list.getValueAt(i, 0));
                i_no_eeg++;
                
                imp.eog_channels_list[i_eog] = Double.parseDouble((String) jTable_final_channels_list.getValueAt(i, 0));
                imp.eog_channels_list_labels[i_eog] = (String) jTable_final_channels_list.getValueAt(i, 1);
                i_eog++;
            }
            }
        }
        
        if (jComboBox_reference_channels.getSelectedItem() == "other")
        {imp.reference_channels[0] = jTextField_reference_channels.getText();}
        else if (jComboBox_reference_channels.getSelectedItem() == "none")
        {imp.reference_channels[0] = "";}
        else
        {imp.reference_channels[0] = (String) jComboBox_reference_channels.getSelectedItem();}

        imp.valid_marker = jTextField_valid_marker.getText().split(",");
        
        return imp;
    }
 
    // ---------------------------------------------------------------------------
    // INIT GUI
    private void initTable_ch2transform(int nb_row)
    {
        Object[] columnNames = {"new_label","type","ch1","ch2",};    
        Object[][] data = new Object[nb_row][columnNames.length];
        jTableDM_ch2transform = new ModelTable_ch2transform(data,columnNames);
        jTable_ch2transform.setModel(jTableDM_ch2transform);        
        
        Object[] cmbinitvalues = {"eeg", "emg", "eog", "others"};
        JComboBox comboBox = new JComboBox(cmbinitvalues);
        comboBox.setMaximumRowCount(4);
        TableCellEditor editor = new DefaultCellEditor(comboBox);        
        jTable_ch2transform.getColumnModel().getColumn(1).setCellEditor(editor);
    }
    
    class ModelTable_ch2transform extends DefaultTableModel {
 
    public ModelTable_ch2transform(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
        }
    
    @Override
      public Class getColumnClass(int col) {
          if ((col == 0) || (col == 1))
          {return String.class;}
          else
          {return Double.class;}  
        }
    }
    
    private void initTable_final_channels_list(int nb_row)
    {
        Object[] columnNames = {"id","label","type"}; 
        Object[][] data = new Object[nb_row][columnNames.length];  
        jTableDM_final_channels_list = new ModelTable_final_channels_list(data,columnNames);   
        jTable_final_channels_list.setModel(jTableDM_final_channels_list);
    }
    
    class ModelTable_final_channels_list extends DefaultTableModel {
 
    public ModelTable_final_channels_list(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
        }
    
    @Override
      public Class getColumnClass(int col) {
            return String.class;  
        }
 
    @Override
      public boolean isCellEditable(int row, int col) {
            return false;
        }
    }
    
    private void initComboBox_acquisition_system()
    {
        jComboBox_acquisition_system.addItem("BIOSEMI");
        jComboBox_acquisition_system.addItem("BRAINVISION");
    }
    
    private void initComboBox_reference_channels()
    {
        //  ref channel :  "CAR", empty, "other"  -> enable text field....
        jComboBox_reference_channels.addItem("CAR");
        jComboBox_reference_channels.addItem("none");
        jComboBox_reference_channels.addItem("other");
    }
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_ch2transform()
    {
        initTable_ch2transform(project.imp.ch2transform.length);
        
        if(project.imp.ch2transform!=null)
        {
        for (int i = 0; i < project.imp.ch2transform.length; i++) 
        {
            jTable_ch2transform.setValueAt(project.imp.ch2transform[i].new_label, i, 0);
            jTable_ch2transform.setValueAt(project.imp.ch2transform[i].type, i, 1);
            if (project.imp.ch2transform[i].ch1!=null)
            {jTable_ch2transform.setValueAt(project.imp.ch2transform[i].ch1[0], i, 2);}
            if (project.imp.ch2transform[i].ch2!=null)
            {jTable_ch2transform.setValueAt(project.imp.ch2transform[i].ch2[0], i, 3);}
        }
        }
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int j = 0; j < jTable_ch2transform.getColumnCount(); j++) 
        {jTable_ch2transform.getColumnModel().getColumn(j).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_ch2transform.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    private void setTable_final_channels_list()
    {     
        int nch_eeg = (int) project.imp.nch_eeg[0];
        int l_ch2transf = project.imp.ch2transform.length;
        
        int c_no_eeg_chan = 0;
        for (int i = 0; i < l_ch2transf; i++)
        {
            if (project.imp.ch2transform[i].new_label!=null)
            {c_no_eeg_chan++;}
        }
        
        initTable_final_channels_list(nch_eeg+c_no_eeg_chan);
         
        int compt = 0;
        for (int i = 0; i < (nch_eeg+l_ch2transf); i++) 
        {
            if (i < nch_eeg)
            {
                jTable_final_channels_list.setValueAt(String.valueOf(i+1), i, 0);
                jTable_final_channels_list.setValueAt(String.valueOf(i+1), i, 1);
                jTable_final_channels_list.setValueAt("eeg", i, 2);
            }  
            else
            {
                if (project.imp.ch2transform[i-(nch_eeg)].new_label != null)
                {
                jTable_final_channels_list.setValueAt(String.valueOf((nch_eeg)+compt+1),(nch_eeg)+compt, 0);
                String label_ch = project.imp.ch2transform[i-(nch_eeg)].new_label;
                String type_ch = project.imp.ch2transform[i-(nch_eeg)].type;
                jTable_final_channels_list.setValueAt(label_ch, nch_eeg+compt, 1);
                jTable_final_channels_list.setValueAt(type_ch, nch_eeg+compt, 2);
                compt++;
                }
            }
        }
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int j = 0; j < jTable_final_channels_list.getColumnCount(); j++) 
        {jTable_final_channels_list.getColumnModel().getColumn(j).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_final_channels_list.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    private void setTextField_valid_marker()
    {
        String print = new String("");
        for (int i = 0; i < project.task.events.valid_marker.length; i++) 
        {
            if (i==0)
            {print = print + project.task.events.valid_marker[0];}
            else
            {print = print + "," + project.task.events.valid_marker[i];}
        }
        jTextField_valid_marker.setText(print);
    }
    
    private void setTextField_nch_eeg()
    {
        int nch = Integer.parseInt(jTextField_nch.getText());
        int l_ch2 = 0;
        if (jTable_ch2transform.getRowCount()<2)
        {l_ch2 = imp.ch2transform.length;}
        else
        {l_ch2 = jTable_ch2transform.getRowCount();}
        String nch_eeg = String.valueOf(nch-l_ch2);
        jTextField_nch_eeg.setText(nch_eeg);
    }
    
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPimport_data = new javax.swing.JPanel();
        jLabel_acquisition_system = new javax.swing.JLabel();
        jLabel_original_data_extension = new javax.swing.JLabel();
        jLabel_original_data_folder = new javax.swing.JLabel();
        jLabel_original_data = new javax.swing.JLabel();
        jTextField_original_data_folder = new javax.swing.JTextField();
        jLabel_original_data_prefix = new javax.swing.JLabel();
        jTextField_original_data_prefix = new javax.swing.JTextField();
        jLabel_original_data_suffix = new javax.swing.JLabel();
        jTextField_original_data_suffix = new javax.swing.JTextField();
        jLabel_example = new javax.swing.JLabel();
        jTextField_example_input = new javax.swing.JTextField();
        jLabel_output_data = new javax.swing.JLabel();
        jLabel_output_folder = new javax.swing.JLabel();
        jLabel_output_suffix = new javax.swing.JLabel();
        jLabel_example_input = new javax.swing.JLabel();
        jTextField_output_suffix = new javax.swing.JTextField();
        jButton_ch2transform_clear = new javax.swing.JButton();
        jButton_ch2transform_remove = new javax.swing.JButton();
        jLabel_ch2transform = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable_ch2transform = new javax.swing.JTable();
        jTextField_output_folder = new javax.swing.JTextField();
        jTextField_original_data_extension = new javax.swing.JTextField();
        jLabel_reference_channels = new javax.swing.JLabel();
        jTextField_reference_channels = new javax.swing.JTextField();
        jComboBox_acquisition_system = new javax.swing.JComboBox();
        jTextField_fs = new javax.swing.JTextField();
        jLabel_eeglab_channels_file_name = new javax.swing.JLabel();
        jTextField_eeglab_channels_file_name = new javax.swing.JTextField();
        jLabel_final_channels_list = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable_final_channels_list = new javax.swing.JTable();
        jLabel_nch = new javax.swing.JLabel();
        jTextField_nch = new javax.swing.JTextField();
        jLabel_eeglab_channels_file_path = new javax.swing.JLabel();
        jLabel_nch_eeg = new javax.swing.JLabel();
        jTextField_eeglab_channels_file_path = new javax.swing.JTextField();
        jTextField_nch_eeg = new javax.swing.JTextField();
        jButton_eeglab_channels_file_path = new javax.swing.JButton();
        jLabel_fs = new javax.swing.JLabel();
        jComboBox_reference_channels = new javax.swing.JComboBox();
        jLabel_example_output = new javax.swing.JLabel();
        jTextField_example_output = new javax.swing.JTextField();
        jButton_ch2transform_apply = new javax.swing.JButton();
        jButton_ch2transform_new = new javax.swing.JButton();
        jLabel_valid_marker = new javax.swing.JLabel();
        jTextField_valid_marker = new javax.swing.JTextField();
        jLabel_import = new javax.swing.JLabel();

        setPreferredSize(new java.awt.Dimension(1150, 750));

        jPimport_data.setName("import_data"); // NOI18N
        jPimport_data.setPreferredSize(new java.awt.Dimension(1150, 750));

        jLabel_acquisition_system.setText("system");

        jLabel_original_data_extension.setText("data extension");

        jLabel_original_data_folder.setText("data folder");

        jLabel_original_data.setText("ORIGINAL DATA INFO");

        jTextField_original_data_folder.setName("original_data_folder"); // NOI18N
        jTextField_original_data_folder.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField_original_data_folderKeyTyped(evt);
            }
        });

        jLabel_original_data_prefix.setText("name prefix");

        jTextField_original_data_prefix.setName("original_data_prefix"); // NOI18N
        jTextField_original_data_prefix.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField_original_data_folderKeyTyped(evt);
            }
        });

        jLabel_original_data_suffix.setText("name suffix");

        jTextField_original_data_suffix.setName("original_data_suffix"); // NOI18N
        jTextField_original_data_suffix.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField_original_data_folderKeyTyped(evt);
            }
        });

        jLabel_example.setText("example S_01");

        jTextField_example_input.setEnabled(false);
        jTextField_example_input.setName("input_example_name"); // NOI18N

        jLabel_output_data.setText("OUTPUT DATA INFO");

        jLabel_output_folder.setText("data folder");

        jLabel_output_suffix.setText("output suffix");
        jLabel_output_suffix.setToolTipText("");

        jLabel_example_input.setText("INPUT");

        jTextField_output_suffix.setName("output_suffix"); // NOI18N
        jTextField_output_suffix.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField_output_suffixKeyTyped(evt);
            }
        });

        jButton_ch2transform_clear.setText("clear");
        jButton_ch2transform_clear.setName("ch2transform_btNew"); // NOI18N
        jButton_ch2transform_clear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_ch2transform_clearActionPerformed(evt);
            }
        });

        jButton_ch2transform_remove.setText("remove");
        jButton_ch2transform_remove.setName("ch2transform_btRemove"); // NOI18N
        jButton_ch2transform_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_ch2transform_removeActionPerformed(evt);
            }
        });

        jLabel_ch2transform.setText("Channels Transformation");

        jTable_ch2transform.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {

            }
        ));
        jTable_ch2transform.setName("ch2transform"); // NOI18N
        jTable_ch2transform.getTableHeader().setReorderingAllowed(false);
        jScrollPane3.setViewportView(jTable_ch2transform);

        jTextField_output_folder.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField_output_folderKeyTyped(evt);
            }
        });

        jTextField_original_data_extension.setEditable(false);
        jTextField_original_data_extension.setText("jTextField1");
        jTextField_original_data_extension.setEnabled(false);

        jLabel_reference_channels.setText("Reference Channel");

        jTextField_reference_channels.setEnabled(false);

        jComboBox_acquisition_system.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jComboBox_acquisition_systemFocusLost(evt);
            }
        });

        jTextField_fs.setName("fs"); // NOI18N

        jLabel_eeglab_channels_file_name.setText("channels file name");

        jTextField_eeglab_channels_file_name.setName("eeglab_channels_file_name"); // NOI18N

        jLabel_final_channels_list.setText("Final Channels ");

        jTable_final_channels_list.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null}
            },
            new String [] {
                "Id", "Label", "Type"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTable_final_channels_list.setColumnSelectionAllowed(true);
        jTable_final_channels_list.setName("final_channels_list"); // NOI18N
        jTable_final_channels_list.getTableHeader().setReorderingAllowed(false);
        jScrollPane1.setViewportView(jTable_final_channels_list);

        jLabel_nch.setText("tot channels");

        jTextField_nch.setName("nch"); // NOI18N
        jTextField_nch.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField_nchFocusLost(evt);
            }
        });

        jLabel_eeglab_channels_file_path.setText("channels file path");

        jLabel_nch_eeg.setText("eeg channels");

        jTextField_eeglab_channels_file_path.setEnabled(false);
        jTextField_eeglab_channels_file_path.setName("eeglab_channels_file_name"); // NOI18N

        jTextField_nch_eeg.setEditable(false);
        jTextField_nch_eeg.setEnabled(false);
        jTextField_nch_eeg.setName("nch_eeg"); // NOI18N

        jButton_eeglab_channels_file_path.setText("Select");
        jButton_eeglab_channels_file_path.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_eeglab_channels_file_pathActionPerformed(evt);
            }
        });

        jLabel_fs.setText("fs");

        jComboBox_reference_channels.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jComboBox_reference_channelsFocusLost(evt);
            }
        });

        jLabel_example_output.setText("OUTPUT");

        jTextField_example_output.setEnabled(false);
        jTextField_example_output.setName("input_example_name"); // NOI18N

        jButton_ch2transform_apply.setText("apply");
        jButton_ch2transform_apply.setName("ch2transform_btNew"); // NOI18N
        jButton_ch2transform_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_ch2transform_applyActionPerformed(evt);
            }
        });

        jButton_ch2transform_new.setText("new");
        jButton_ch2transform_new.setName("ch2transform_btNew"); // NOI18N
        jButton_ch2transform_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_ch2transform_newActionPerformed(evt);
            }
        });

        jLabel_valid_marker.setText("Valid marker");

        jTextField_valid_marker.setEnabled(false);

        jLabel_import.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_import.setText("Import");

        javax.swing.GroupLayout jPimport_dataLayout = new javax.swing.GroupLayout(jPimport_data);
        jPimport_data.setLayout(jPimport_dataLayout);
        jPimport_dataLayout.setHorizontalGroup(
            jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPimport_dataLayout.createSequentialGroup()
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                        .addComponent(jLabel_valid_marker, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField_valid_marker))
                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPimport_dataLayout.createSequentialGroup()
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                                        .addGap(590, 590, 590)
                                        .addComponent(jLabel_eeglab_channels_file_path, javax.swing.GroupLayout.PREFERRED_SIZE, 124, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                                .addComponent(jLabel_reference_channels)
                                                .addGap(28, 28, 28)
                                                .addComponent(jComboBox_reference_channels, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jTextField_reference_channels))
                                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                                .addComponent(jLabel_nch, javax.swing.GroupLayout.PREFERRED_SIZE, 79, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_nch, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jLabel_nch_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_nch_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(29, 29, 29)
                                                .addComponent(jLabel_fs, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                .addComponent(jTextField_fs, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jLabel_eeglab_channels_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, 124, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED))
                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPimport_dataLayout.createSequentialGroup()
                                        .addGap(0, 0, Short.MAX_VALUE)
                                        .addComponent(jLabel_final_channels_list, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                                .addComponent(jLabel_ch2transform, javax.swing.GroupLayout.PREFERRED_SIZE, 129, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(18, 18, 18)
                                                .addComponent(jButton_ch2transform_new, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jButton_ch2transform_remove)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jButton_ch2transform_apply, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                .addComponent(jButton_ch2transform_clear, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 528, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addGap(0, 0, Short.MAX_VALUE)))
                                .addGap(42, 42, 42)))
                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPimport_dataLayout.createSequentialGroup()
                                .addComponent(jTextField_eeglab_channels_file_path, javax.swing.GroupLayout.PREFERRED_SIZE, 331, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_eeglab_channels_file_path))
                            .addComponent(jTextField_eeglab_channels_file_name, javax.swing.GroupLayout.Alignment.LEADING))))
                .addGap(1001, 1001, 1001))
            .addGroup(jPimport_dataLayout.createSequentialGroup()
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                .addComponent(jLabel_example, javax.swing.GroupLayout.PREFERRED_SIZE, 82, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(30, 30, 30)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_example_input, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_example_output, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextField_example_output, javax.swing.GroupLayout.PREFERRED_SIZE, 770, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField_example_input, javax.swing.GroupLayout.PREFERRED_SIZE, 770, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPimport_dataLayout.createSequentialGroup()
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jLabel_original_data, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jLabel_output_data, javax.swing.GroupLayout.PREFERRED_SIZE, 128, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(18, 18, 18)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_acquisition_system, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextField_output_folder)
                                    .addComponent(jComboBox_acquisition_system, 0, 80, Short.MAX_VALUE))
                                .addGap(31, 31, 31)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jLabel_original_data_extension, javax.swing.GroupLayout.DEFAULT_SIZE, 81, Short.MAX_VALUE)
                                    .addComponent(jLabel_output_suffix, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextField_output_suffix)
                                    .addComponent(jTextField_original_data_extension, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE))
                                .addGap(54, 54, 54)
                                .addComponent(jLabel_original_data_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField_original_data_folder, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(36, 36, 36)
                                .addComponent(jLabel_original_data_prefix, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_original_data_prefix, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(36, 36, 36)
                                .addComponent(jLabel_original_data_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextField_original_data_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jLabel_import))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPimport_dataLayout.setVerticalGroup(
            jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPimport_dataLayout.createSequentialGroup()
                .addComponent(jLabel_import)
                .addGap(15, 15, 15)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_original_data)
                    .addComponent(jLabel_acquisition_system)
                    .addComponent(jLabel_original_data_extension)
                    .addComponent(jLabel_original_data_folder)
                    .addComponent(jTextField_original_data_folder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_original_data_prefix)
                    .addComponent(jTextField_original_data_prefix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_original_data_suffix)
                    .addComponent(jTextField_original_data_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField_original_data_extension, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBox_acquisition_system, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_output_data)
                    .addComponent(jLabel_output_folder)
                    .addComponent(jLabel_output_suffix)
                    .addComponent(jTextField_output_suffix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField_output_folder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(26, 26, 26)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_example)
                    .addComponent(jTextField_example_input, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_example_input))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_example_output)
                    .addComponent(jTextField_example_output, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(40, 40, 40)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_nch)
                    .addComponent(jTextField_nch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_nch_eeg)
                    .addComponent(jTextField_nch_eeg, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_fs)
                    .addComponent(jTextField_fs, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel_eeglab_channels_file_name)
                    .addComponent(jTextField_eeglab_channels_file_name, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_eeglab_channels_file_path)
                    .addComponent(jTextField_eeglab_channels_file_path, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton_eeglab_channels_file_path))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 359, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel_final_channels_list))
                    .addGroup(jPimport_dataLayout.createSequentialGroup()
                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_reference_channels)
                            .addComponent(jComboBox_reference_channels, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField_reference_channels, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(20, 20, 20)
                        .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton_ch2transform_clear)
                            .addComponent(jLabel_ch2transform)
                            .addComponent(jButton_ch2transform_remove)
                            .addComponent(jButton_ch2transform_apply)
                            .addComponent(jButton_ch2transform_new))
                        .addGap(2, 2, 2)
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 290, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(21, 21, 21)
                .addGroup(jPimport_dataLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_valid_marker)
                    .addComponent(jTextField_valid_marker, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        jLabel_reference_channels.getAccessibleContext().setAccessibleName("Reference Channels");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPimport_data, javax.swing.GroupLayout.PREFERRED_SIZE, 1140, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPimport_data, javax.swing.GroupLayout.DEFAULT_SIZE, 728, Short.MAX_VALUE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTextField_output_suffixKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField_output_suffixKeyTyped
        String text = jTextField_output_folder.getText()+jTextField_output_suffix.getText();
        jTextField_example_output.setText(text);
    }//GEN-LAST:event_jTextField_output_suffixKeyTyped

    private void jButton_ch2transform_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_ch2transform_removeActionPerformed
        jTableDM_ch2transform.removeRow(jTable_ch2transform.getSelectedRow());
        setTextField_nch_eeg();
    }//GEN-LAST:event_jButton_ch2transform_removeActionPerformed

    private void jButton_ch2transform_clearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_ch2transform_clearActionPerformed
        initTable_ch2transform(1);
        setTextField_nch_eeg();
    }//GEN-LAST:event_jButton_ch2transform_clearActionPerformed

    private void jComboBox_acquisition_systemFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jComboBox_acquisition_systemFocusLost
        if (jComboBox_acquisition_system.getSelectedItem() == "BIOSEMI")
        //if (jComboBox_acquisition_system.getSelectedIndex() == 1)
        {jTextField_original_data_extension.setText(".bdf");}
        else if (jComboBox_acquisition_system.getSelectedItem() == "BRAINVISION")
        {jTextField_original_data_extension.setText(".vhdr");}
    }//GEN-LAST:event_jComboBox_acquisition_systemFocusLost

    private void jComboBox_reference_channelsFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jComboBox_reference_channelsFocusLost

        String select_string = (String) jComboBox_reference_channels.getSelectedItem();
        if (select_string.equals("CAR"))
        {jTextField_reference_channels.setEnabled(false);}
        else if (select_string.equals("none"))
        {jTextField_reference_channels.setEnabled(false);}
        else if (select_string.equals("other"))
        {jTextField_reference_channels.setEnabled(true);}

    }//GEN-LAST:event_jComboBox_reference_channelsFocusLost

    private void jTextField_output_folderKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField_output_folderKeyTyped
        String text = jTextField_output_folder.getText()+"S_01"+jTextField_output_suffix.getText();
        jTextField_example_output.setText(text);
    }//GEN-LAST:event_jTextField_output_folderKeyTyped

    private void jButton_eeglab_channels_file_pathActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_eeglab_channels_file_pathActionPerformed
        JFileChooser fc = new JFileChooser(); 
        fc.showOpenDialog(null);
        //String paths = fc.getSelectedFile().getAbsolutePath();
        String paths = fc.getSelectedFile().getPath();
        String filename = fc.getSelectedFile().getName();
        jTextField_eeglab_channels_file_path.setText(paths.substring(0,paths.length()-filename.length()));
    }//GEN-LAST:event_jButton_eeglab_channels_file_pathActionPerformed

    private void jButton_ch2transform_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_ch2transform_applyActionPerformed
        
        int nch_eeg = 0;
        if (jTextField_nch_eeg != null)
        {nch_eeg = (int) Double.parseDouble(jTextField_nch_eeg.getText());}
        else {nch_eeg = 0;}
        
        int l_ch2transf = jTable_ch2transform.getRowCount();
        int c_no_eeg_chan = 0;
        for (int i = 0; i < l_ch2transf; i++)
        {
            if (jTable_ch2transform.getValueAt(i, 0)!=null)
            {c_no_eeg_chan++;}
        }
        
        initTable_final_channels_list(nch_eeg+c_no_eeg_chan);
        
        int compt = 0;
        for (int i = 0; i < (nch_eeg+l_ch2transf); i++) 
        {
            if (i < nch_eeg)
            {
                jTable_final_channels_list.setValueAt(String.valueOf(i+1), i, 0);
                jTable_final_channels_list.setValueAt(String.valueOf(i+1), i, 1);
                jTable_final_channels_list.setValueAt("eeg", i, 2);
            }  
            else
            {
                if (jTable_ch2transform.getValueAt(i-(nch_eeg), 0) != null)
                {
                jTable_final_channels_list.setValueAt(String.valueOf((nch_eeg)+compt+1),(nch_eeg)+compt, 0);
                String label_ch = (String) jTable_ch2transform.getValueAt(i-(nch_eeg), 0);
                String type_ch = (String) jTable_ch2transform.getValueAt(i-(nch_eeg), 1);
                jTable_final_channels_list.setValueAt(label_ch, nch_eeg+compt, 1);
                jTable_final_channels_list.setValueAt(type_ch, nch_eeg+compt, 2);
                compt++;
                }
            }
        }
    }//GEN-LAST:event_jButton_ch2transform_applyActionPerformed


    
    private void jButton_ch2transform_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_ch2transform_newActionPerformed
        Object[] obj=null;
        jTableDM_ch2transform.addRow(obj);
        jTable_ch2transform.setModel(jTableDM_ch2transform);
        setTextField_nch_eeg();
    }//GEN-LAST:event_jButton_ch2transform_newActionPerformed

    private void jTextField_original_data_folderKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField_original_data_folderKeyTyped
        String text = jTextField_original_data_folder.getText()+jTextField_original_data_prefix.getText()+"S_01"+jTextField_original_data_suffix.getText();
        jTextField_example_input.setText(text);
    }//GEN-LAST:event_jTextField_original_data_folderKeyTyped

    private void jTextField_nchFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField_nchFocusLost
        setTextField_nch_eeg();
    }//GEN-LAST:event_jTextField_nchFocusLost

    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton_ch2transform_apply;
    private javax.swing.JButton jButton_ch2transform_clear;
    private javax.swing.JButton jButton_ch2transform_new;
    private javax.swing.JButton jButton_ch2transform_remove;
    private javax.swing.JButton jButton_eeglab_channels_file_path;
    private javax.swing.JComboBox jComboBox_acquisition_system;
    private javax.swing.JComboBox jComboBox_reference_channels;
    private javax.swing.JLabel jLabel_acquisition_system;
    private javax.swing.JLabel jLabel_ch2transform;
    private javax.swing.JLabel jLabel_eeglab_channels_file_name;
    private javax.swing.JLabel jLabel_eeglab_channels_file_path;
    private javax.swing.JLabel jLabel_example;
    private javax.swing.JLabel jLabel_example_input;
    private javax.swing.JLabel jLabel_example_output;
    private javax.swing.JLabel jLabel_final_channels_list;
    private javax.swing.JLabel jLabel_fs;
    private javax.swing.JLabel jLabel_import;
    private javax.swing.JLabel jLabel_nch;
    private javax.swing.JLabel jLabel_nch_eeg;
    private javax.swing.JLabel jLabel_original_data;
    private javax.swing.JLabel jLabel_original_data_extension;
    private javax.swing.JLabel jLabel_original_data_folder;
    private javax.swing.JLabel jLabel_original_data_prefix;
    private javax.swing.JLabel jLabel_original_data_suffix;
    private javax.swing.JLabel jLabel_output_data;
    private javax.swing.JLabel jLabel_output_folder;
    private javax.swing.JLabel jLabel_output_suffix;
    private javax.swing.JLabel jLabel_reference_channels;
    private javax.swing.JLabel jLabel_valid_marker;
    private javax.swing.JPanel jPimport_data;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTable jTable_ch2transform;
    private javax.swing.JTable jTable_final_channels_list;
    private javax.swing.JTextField jTextField_eeglab_channels_file_name;
    private javax.swing.JTextField jTextField_eeglab_channels_file_path;
    private javax.swing.JTextField jTextField_example_input;
    private javax.swing.JTextField jTextField_example_output;
    private javax.swing.JTextField jTextField_fs;
    private javax.swing.JTextField jTextField_nch;
    private javax.swing.JTextField jTextField_nch_eeg;
    private javax.swing.JTextField jTextField_original_data_extension;
    private javax.swing.JTextField jTextField_original_data_folder;
    private javax.swing.JTextField jTextField_original_data_prefix;
    private javax.swing.JTextField jTextField_original_data_suffix;
    private javax.swing.JTextField jTextField_output_folder;
    private javax.swing.JTextField jTextField_output_suffix;
    private javax.swing.JTextField jTextField_reference_channels;
    private javax.swing.JTextField jTextField_valid_marker;
    // End of variables declaration//GEN-END:variables
}
