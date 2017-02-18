function [OS, open_set, fscore, parent, parent_action] =  add2open(OS, open_set, closed_set, fscore, neighbours, current, parent, parent_action)
X = get_com(current);
xc = X(1);
yc = X(2);
OS_com = get_com(OS);
for k=1:size(neighbours,1)
    this = neighbours(k,:);
    Xthis = get_com(this);
    x = Xthis(1);
    y = Xthis(2);
    if closed_set(x,y)==0
        if open_set(x,y)==0
            OS(end+1,:) = this;
            OS_com(end+1,:) = get_com(this);
            open_set(x,y)=1;
            fscore(x,y) = this(end);
            parent(x,y) = sub2ind(size(open_set),xc,yc);
            parent_action(x,y,1) = this(13);
            parent_action(x,y,2) = this(14);
            parent_action(x,y,3) = this(15);
        elseif fscore(x,y)>this(end)
            [m,~] = find(OS_com(:,1)==x & OS_com(:,2)==y);
            OS(m,:) = [];
            OS_com(m,:) = [];
            OS(end,:) = this;
            OS_com(end,:) = get_com(this);
            fscore(x,y) = this(end);
            parent(x,y) = sub2ind(size(open_set),xc,yc);
            parent_action(x,y,1) = this(13);
            parent_action(x,y,2) = this(14);
            parent_action(x,y,3) = this(15);
        end
    end
end
end