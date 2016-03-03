function gg = gui()

    % MATLAB_JAVA

    ...javaj_jar_path = '/data/behavior_lab_svn/behaviourPlatform/PAP/eeg_tools_gui/eeggui/dist/eeggui.jar';
    ...javaj_jar_path = '/home/inuggi/NetBeansProjects/eeg_tools2/dist/eeg_tools2.jar';
    ...javaj_jar_path = '\\VBOXSVR\data\behavior_lab_svn\behaviourPlatform\PAP\eeg_tools_gui\eeggui\dist\eeggui.jar';
    ...javaj_jar_path = '/data/behavior_lab_svn/behaviourPlatform/CommonScript/eeg/eeg_tools/gui/eeggui/dist/eeggui.jar';
    javaj_jar_path = 'C:\Users\PHilt\Desktop\behaviour_platform\PAP\eeg_tools_gui\eeggui\dist\eeggui.jar';
    
    
    javaaddpath(javaj_jar_path);

    fig = figure('visible', 'on', 'units','normalized','outerposition',[0 0 1 1]);
    ...drawnow
    
    frame = GXJFrame( fig, 'EEG TOOLS'); ..., gui.JTPMain()) ;
    gg = GImport(frame, gui.JTPMain(), false); ..., 'nolayout');

    handles = gg.getHandles();
    StartButton = handles.Start;  % this is the NAME in Properties, not VARIABLE NAME in code
    gg.setCallback(StartButton, 'ActionPerformedCallback', @start_analysis, handles)
    ...handles.main_tab.stats.stats_pane.stats_pane.setLayout(java.awt.FlowLayout);
    ...handles.main_tab.stats.stats_pane.stats_pane.setLayout(javax.swing.SpringLayout);
    ...handles.main_tab.JPPreprocessing.preproc.preproc.setLayout(java.awt.FlowLayout);
    
%      if exist('gg', 'var')
%         javarmpath(javaj_jar_path)
%     end
    a=1;

end
