function start_analysis(varargin)

	if nargin > 2
	    project_mat_file = varargin{3};
	end

	load(project_mat_file);
	disp(['loading ' project_mat_file ' file' ]);

end

