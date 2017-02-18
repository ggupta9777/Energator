function out = frac_trans(f)

        f1xta = 0.5+0.25 + 0.5*(f(:,1)-0.5);      %fraction of total step length by swing foot at half time step
        f1xtb = 0.75 + 0.5*(f(:,2)-0.5);      %fraction of maximum allowable step height at half time step
        f1xtb = 1.5 - f1xtb;
        f2xta = f(:,3);               	    %fraction of total x-distance by mid hip
        f2xtb = f(:,4);               	    %fraction of total x-distance by mid hip
        f2ztm = 0.5 + 0.4*(f(:,5)-0.5);             %fraction of height permissible above the max(z_mh_initial,z_mh_final)
        f2ytd1 = 0.2+0.2*(f(:,7)-0.5);        %fraction of total step-width at halftime step
        f2ytm = 0.3+0.2*(f(:,6)-0.5);         %fraction of total step-width at halftime step
        f2ytd2 = 0.2+0.2*(f(:,8)-0.5);        %fraction of total step-width at halftime step
        out = [f1xta, f1xtb, f2xta, f2xtb, f2ztm, f2ytm, f2ytd1, f2ytd2];

end
