%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.cfg_mkdir.parent = {'/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/stats/wmne_fixed_surf/MOTIONwithinScrambled'};
matlabbatch{1}.cfg_basicio.cfg_mkdir.name = 'N600';
matlabbatch{2}.spm.stats.factorial_design.dir(1) = cfg_dep;
matlabbatch{2}.spm.stats.factorial_design.dir(1).tname = 'Directory';
matlabbatch{2}.spm.stats.factorial_design.dir(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.factorial_design.dir(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{2}.spm.stats.factorial_design.dir(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.factorial_design.dir(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.factorial_design.dir(1).sname = 'Make Directory: Make Directory ''OUTPUT_STAT_DIR_NAME''';
matlabbatch{2}.spm.stats.factorial_design.dir(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.factorial_design.dir(1).src_output = substruct('.','dir');
matlabbatch{2}.spm.stats.factorial_design.des.t2.scans1 = {'/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/alessandra_finisguerra_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/alessia_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/amedeo_schipani_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/antonio2_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/augusta2_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/claudio2_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/denis_giambarrasi_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/eleonora_bartoli_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/giada_fix2_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/jorhabib_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/martina2_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/stefano_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/yannis3_OCICA_250_cleanica_cscrambled_wmne_fixed_surf_N600.nii,1'};
matlabbatch{2}.spm.stats.factorial_design.des.t2.scans2 = {'/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/alessandra_finisguerra_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/alessia_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/amedeo_schipani_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/antonio2_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/augusta2_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/claudio2_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/denis_giambarrasi_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/eleonora_bartoli_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/giada_fix2_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/jorhabib_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/martina2_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/stefano_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1''/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/yannis3_OCICA_250_cleanica_tscrambled_wmne_fixed_surf_N600.nii,1'};
matlabbatch{2}.spm.stats.factorial_design.des.t2.dept = 1;
matlabbatch{2}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{2}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{2}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{2}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{2}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{2}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{2}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{2}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{2}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{2}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{4}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{4}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'A>B';
matlabbatch{4}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'B>A';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.delete = 0;
matlabbatch{5}.spm.stats.results.spmmat(1) = cfg_dep;
matlabbatch{5}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
matlabbatch{5}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{5}.spm.stats.results.conspec(1).titlestr = 'cscrambled > tscrambled';
matlabbatch{5}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{5}.spm.stats.results.conspec(1).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
matlabbatch{5}.spm.stats.results.conspec(2).titlestr = 'tscrambled > cscrambled';
matlabbatch{5}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{5}.spm.stats.results.conspec(2).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(2).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
matlabbatch{5}.spm.stats.results.units = 1;
matlabbatch{5}.spm.stats.results.print = true;
%matlabbatch{6}.cfg_basicio.file_move.files = '*.ps';
%matlabbatch{6}.cfg_basicio.file_move.action.copyren.copyto = {'/data/projects/moving_scrambled_walker/spm_sources/4mm/OCICA_250_cleanica/stats'};
%matlabbatch{6}.cfg_basicio.file_move.action.copyren.patrep.pattern = 'spm';
%matlabbatch{6}.cfg_basicio.file_move.action.copyren.patrep.repl = 'spm_MOTIONwithinScrambled_wmne_fixed_surf_N600';
%matlabbatch{6}.cfg_basicio.file_move.action.copyren.unique = false;

