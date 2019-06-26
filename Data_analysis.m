clear all
close all
clc

i=1
listing = dir ('**/*.txt');
for i=1:size(listing,1)
filename=(listing(i).name)
Data_tab{i} = readtable(filename);
end;

GCP = readtable('Data.xlsx','Sheet','GCPs');

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,2,[1 3])
%point density plots
for i=1:size(listing,1)
X(:,i)=Data_tab{1,i}.ETRS89_X;
Y(:,i)=Data_tab{1,i}.ETRS89_Y;
Z(:,i)=Data_tab{1,i}.diff;
end;
X1=X(:,1);
Y1=Y(:,1);
Z1=mean(Z,2);
hold on
scatter(X1,Y1,10,Z1,'filled')
scatter(GCP.ETRS89_X,GCP.ETRS89_Y,50,'filled','MarkerEdgeColor','w','MarkerFaceColor','k'); %plots GCPs
colormap (gca,jet);
xlabel('X coordinate [m]')
ylabel('Y coordinate [m]')
c=colorbar;
caxis([min(Z1) max(Z1)])
c.Location = 'southoutside';
c.Label.String='Average DEM - CP elevation between all surveys [m]';
hold off

subplot(2,2,2)

minXlim=min(Z(:))
maxXlim=max(Z(:))

for i=1:size(listing,1)
pd = fitdist(Z(:,i),'Normal');
x_values = minXlim:abs(minXlim-maxXlim)/1000:maxXlim;
y = pdf(pd,x_values);
hold on
plot(x_values,y,'LineWidth',2);
listing(i).legend=listing(i).name(1:end-4)
end;
lgd=legend (listing.legend,'Location','southoutside');
lgd.NumColumns = 2;
hold off

subplot(2,2,4)
for i=1:size(listing,1)
prompt = strcat('What is the overlap of',{' '},listing(i).legend,'?');
answ = input(char(prompt));
comp(i,1) = answ
comp(i,2) = mean(Z(:,i));
comp(i,3) = std(Z(:,i));

hold on
errorbar(comp(i,1),comp(i,2),comp(i,3), 'LineStyle','none','LineWidth',2);
listing(i).legend=listing(i).name(1:end-4)
end;
lgd=legend (listing.legend,'Location','southoutside');
lgd.NumColumns = 2;
xlabel('Effective overlap (number of overlapping photos)')
ylabel('DEM - CP elevation [m]')
hold off

outname=strcat('Results/sumplots.png')
saveas(gcf,outname);


