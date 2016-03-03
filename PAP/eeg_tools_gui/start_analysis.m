function start_analysis(varargin)

	if nargin > 2
	    handles = varargin{3};
    end
    
    load(get(handles.project_path,'Text'))
	%load(handles.project_path.getText());
	disp(['loading ' project_mat_file ' file' ]);

end

