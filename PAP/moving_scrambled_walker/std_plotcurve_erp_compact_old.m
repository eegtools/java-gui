function [] = std_plotcurve_erp_compact(times, erp, plot_dir, roi_name, study_ls, name_f1, name_f2, levels_f1,levels_f2, pgroup,  pcond, pinter, titles ,tr,filter)      
    nn=2; 
    % total levels of factor 1 (e.g conditions) and 2 (e.g groups)     
    [tlf1 tlf2]=size(erp);
    if tlf2 > 1
        for nlf1=1%:tlf1 
            erp_plot=erp(nlf1,:);
            
            
            
            pgroup_plot=pgroup(nlf1);            
            std_plotcurve(times,erp_plot,'plotgroups','together','threshold',NaN)
            h=gcf(figure(2))
            set(h,'LineStyle',2)
            title(['Within ',levels_f1{nlf1}]);
            yl1=get(gca,'ylim');
            extend=abs(diff(yl1))*2;
            yylim=[(yl1(1)-extend) (yl1(2)+extend)];
            ylim(yylim); 
            yl1=get(gca,'ylim');
            delta=abs(diff(yl1))*0.1;
            yylim=[(yl1(1)-delta) yl1(2)];
            ylim(yylim);
            legend(levels_f2)
            hold on  
            ss=pgroup_plot{1}>study_ls;
             if ~isempty(ss)
                 ss2=times(ss);
                 hold on
                 plot(ss2,ones(1,length(ss2))*(yl1(1)+delta/2),'gs','LineWidth',2,'MarkerEdgeColor','black','MarkerSize', 5,'MarkerFaceColor', 'black')
%                  plot(ss2,ones(1,length(ss2))*(yl1(1)+delta/2),'-','LineWidth',5,'col','black')
             end

        end
    end
    
%     if tlf1 > 1
%         for nlf2=1:tlf2 
%             erp_plot=erp(:,nlf2);
%             pcond_plot=pcond(nlf1);
%             std_plotcurve(times,erp_plot,'plotconditions','together','condstats',pcond_plot,'threshold',tr)
%             title(['Within ',levels_f2{nlf2}])
%         end
%     end
%     
end