function plot_all(X, X_lfoot, X_rfoot, X_com, X_zmp,fg,fh,n)
global writerObj

[mass,~] = params;
com = zeros(3,size(X_com,3));
M = diag(mass);
for i=1:size(X_com,3)
    temp = (X_com(:,:,i)*M)';
    temp = sum(temp)/trace(M);
    temp = temp';
    temp = temp(:);
    com(:,i) = temp;
end
if n>=1
% figure(fg);
% view(0,90);
% %plot3(X_zmp(1,[1:end]),X_zmp(2,[1:end]),0.002+X_zmp(3,[1:end]),'color','k');
% plot3(com(1,[1:end]),com(2,[1:end]),com(3,[1:end]),'color','b');
% %plot3(X_zmp(1,12:end-12),X_zmp(2,12:end-12),0.002+X_zmp(3,12:end-12),'color','r','linewidth',1.2);
% %plot3(com(1,12:end-12),com(2,12:end-12),com(3,12:end-12),'color','r','linewidth',1.5);
% plot3([X_lfoot(1,2:5) X_lfoot(1,2)],[X_lfoot(2,2:5) X_lfoot(2,2)],0.002+[X_lfoot(3,2:5) X_lfoot(3,2)],'color','b','linewidth',1);
% plot3([X_rfoot(1,2:5) X_rfoot(1,2)],[X_rfoot(2,2:5) X_rfoot(2,2)],0.002+[X_rfoot(3,2:5) X_rfoot(3,2)],'color','b','linewidth',1);
% end
% 
%figure(fh);

set(gcf,'units','normalized','outerposition',[0 0 1 1]);
its = size(X,3);
j=1;
aj_left = X(:,1,j);
kj_left = X(:,2,j);
hj_left = X(:,3,j);
aj_right = X(:,6,j);
kj_right = X(:,5,j);
hj_right = X(:,4,j);
f_left = X_lfoot(:,:,j);
f_right = X_rfoot(:,:,j);
Xd = [aj_left(1) kj_left(1) hj_left(1) hj_right(1) kj_right(1) aj_right(1)];
Yd = [aj_left(2) kj_left(2) hj_left(2) hj_right(2) kj_right(2) aj_right(2)];
Zd = [aj_left(3) kj_left(3) hj_left(3) hj_right(3) kj_right(3) aj_right(3)];
h1 = plot3(Xd,Yd,Zd,'color','r','linewidth',1.5);
h2 = plot3([f_left(1,2:end) f_left(1,2)],[f_left(2,2:end) f_left(2,2)],[f_left(3,2:end), f_left(3,2)],'linewidth',1.5,'color','b');
h3 = plot3([f_right(1,2:end) f_right(1,2)],[f_right(2,2:end) f_right(2,2)],[f_right(3,2:end), f_right(3,2)],'linewidth',1.5,'color','b');
h4 = plot3([f_left(1,2) aj_left(1) f_left(1,4) aj_left(1) f_left(1,3) aj_left(1) f_left(1,5)], [f_left(2,2) aj_left(2) f_left(2,4) aj_left(2) f_left(2,3) aj_left(2) f_left(2,5)], [f_left(3,2) aj_left(3) f_left(3,4) aj_left(3) f_left(3,3) aj_left(3) f_left(3,5)],'color','b','linewidth',1.5);
h5 = plot3([f_right(1,2) aj_right(1) f_right(1,4) aj_right(1) f_right(1,3) aj_right(1) f_right(1,5)], [f_right(2,2) aj_right(2) f_right(2,4) aj_right(2) f_right(2,3) aj_right(2) f_right(2,5)], [f_right(3,2) aj_right(3) f_right(3,4) aj_right(3) f_right(3,3) aj_right(3) f_right(3,5)],'color','b','linewidth',1.5);
tic
for j=[1:5:its-1,its]
    hold all;
    aj_left = X(:,1,j);
    kj_left = X(:,2,j);
    hj_left = X(:,3,j);
    aj_right = X(:,6,j);
    kj_right = X(:,5,j);
    hj_right = X(:,4,j);
    f_left = X_lfoot(:,:,j);
    f_right = X_rfoot(:,:,j);
    Xd = [aj_left(1) kj_left(1) hj_left(1) hj_right(1) kj_right(1) aj_right(1)];
    Yd = [aj_left(2) kj_left(2) hj_left(2) hj_right(2) kj_right(2) aj_right(2)];
    Zd = [aj_left(3) kj_left(3) hj_left(3) hj_right(3) kj_right(3) aj_right(3)];
    h1.XData = Xd;
    h1.YData = Yd;
    h1.ZData = Zd;
    h2.XData = [f_left(1,2:end) f_left(1,2)];
    h2.YData = [f_left(2,2:end) f_left(2,2)];
    h2.ZData = 0.001+[f_left(3,2:end) f_left(3,2)];
    h3.XData = [f_right(1,2:end) f_right(1,2)];
    h3.YData = [f_right(2,2:end) f_right(2,2)];
    h3.ZData = 0.001+[f_right(3,2:end) f_right(3,2)];
    h4.XData = [f_left(1,2) aj_left(1) f_left(1,4) aj_left(1) f_left(1,3) aj_left(1) f_left(1,5)];
    h4.YData = [f_left(2,2) aj_left(2) f_left(2,4) aj_left(2) f_left(2,3) aj_left(2) f_left(2,5)];
    h4.ZData = [f_left(3,2) aj_left(3) f_left(3,4) aj_left(3) f_left(3,3) aj_left(3) f_left(3,5)];
    h5.XData = [f_right(1,2) aj_right(1) f_right(1,4) aj_right(1) f_right(1,3) aj_right(1) f_right(1,5)];
    h5.YData = [f_right(2,2) aj_right(2) f_right(2,4) aj_right(2) f_right(2,3) aj_right(2) f_right(2,5)];
    h5.ZData = [f_right(3,2) aj_right(3) f_right(3,4) aj_right(3) f_right(3,3) aj_right(3) f_right(3,5)];
    pause(0.02)
    if j<its
        drawnow;
        Frame = getframe(gcf);
        writeVideo(writerObj,Frame);
    else
        delete(h1);
        delete(h2);
        delete(h3);
        delete(h4);
        delete(h5);
    end    
end
% toc
% plot3([X_lfoot(1,2:5,end) X_lfoot(1,2,end)],[X_lfoot(2,2:5,end) X_lfoot(2,2,end)],[X_lfoot(3,2:5,end) X_lfoot(3,2,end)],'linewidth',1.0,'color','r');
% plot3([X_rfoot(1,2:5,end) X_rfoot(1,2,end)],[X_rfoot(2,2:5,end) X_rfoot(2,2,end)],[X_rfoot(3,2:5,end) X_rfoot(3,2,end)],'linewidth',1.0,'color','r');
% plot3([X_rfoot(1,2:5,1) X_rfoot(1,2,1)],[X_rfoot(2,2:5,1) X_rfoot(2,2,1)],[X_rfoot(3,2:5,1) X_rfoot(3,2,1)],'linewidth',1.5,'color','r');
% plot3(X_zmp(1,:),X_zmp(2,:),X_zmp(3,:),'color','g');
% plot3(com(1,:),com(2,:),com(3,:),'color','r');
% plot3(X_zmp(1,12:end-12),X_zmp(2,12:end-12),X_zmp(3,12:end-12),'color','b','linewidth',1);
%
end
