clear all
close all
clc

mkdir Results

%Reads GPS data
GCP = readtable('Data.xlsx','Sheet','GCPs');
CP = readtable('Data.xlsx','Sheet','CPs');
listing = dir ('**/*.tif');

for i=1:size(listing,1)
%plots the DEM from drone data
filename=(listing(i).name)
[DEM,R] = geotiffread(filename);
DEM=double(DEM);
DEM(DEM==-32767) = NaN; %Sets NaN

%Figures
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,3,[1 4])
title(filename(1:end-4))
hold on
mapshow(DEM,R,'DisplayType','surface'); %plots the DEM
scatter3(GCP.ETRS89_X,GCP.ETRS89_Y,GCP.ETRS89_Z,...
        'MarkerEdgeColor','w',...
        'MarkerFaceColor','k'); %plots GCPs
colormap parula;
c=colorbar ('southoutside');
c.Label.String = 'Elevation [m]';
caxis([(min(CP.ElevMSL)-0.5) (max(CP.ElevMSL)+0.5)])
set(gca,'XLim', R.XWorldLimits, 'YLim', R.YWorldLimits);
xlabel('X coordinate [m]')
ylabel('Y coordinate [m]')

CP.DEMval= mapinterp(DEM,R,CP.ETRS89_X,CP.ETRS89_Y);
CP.diff=(CP.DEMval-CP.ElevMSL);
scatter3(CP.ETRS89_X,CP.ETRS89_Y,CP.ETRS89_Z,10,'filled','MarkerfaceColor','w'); %plots CPs

cntr=[mean(GCP.ETRS89_X) mean(GCP.ETRS89_Y)];
scatter(mean(GCP.ETRS89_X),mean(GCP.ETRS89_Y),30,'o')
CP.cntrdist(:)=pdist2([cntr(1,1) cntr(1,2)],[CP.ETRS89_X(:) CP.ETRS89_Y(:)],'euclidean');

for k=1:size(CP,1)
for j=1:size(GCP,1)
 GCPdist(k,j)=(pdist2([GCP.ETRS89_X(j) GCP.ETRS89_Y(j)],[CP.ETRS89_X(k) CP.ETRS89_Y(k)],'euclidean'));
end;
CP.GCPdist(k)=min(GCPdist(k,:));
CP.GCPavgdist(k)=mean(GCPdist(k,:));
end;

subplot(2,3,2)
histfit(CP.diff)
xlabel('DEM - CP elevation [m]')
diff=rmmissing(CP.diff);
rmse = sqrt(immse(CP.DEMval,CP.ElevMSL));
title ((strcat('Average=',sprintf('%.3f',mean(diff)),'m',{' '},'Stdev=',sprintf('%.3f',std(diff)),'m',{' '},'RMSE=',sprintf('%.3f',rmse),'m')))
subplot(2,3,3)
x=CP.cntrdist;
y=CP.diff;
[p,S] = polyfit(x,y,1); 
[y_fit,delta] = polyval(p,x,S);
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+delta,'m--',x,y_fit-delta,'m--')
scatter(CP.cntrdist,CP.diff,10,'filled','k')
legend('Observations','Linear Fit','67% Prediction Interval')
xlabel('Distance to the GCP centroid [m]')
ylabel('DEM - CP elevation [m]')

subplot(2,3,5)
scatter(CP.ElevMSL,CP.diff,10,'filled','k')
x=CP.ElevMSL;
y=CP.diff;
[p,S] = polyfit(x,y,1); 
[y_fit,delta] = polyval(p,x,S);
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+delta,'m--',x,y_fit-delta,'m--')
legend('Observations','Linear Fit','67% Prediction Interval')
xlabel('Elevation of CP [m]')
ylabel('DEM - CP elevation [m]')

subplot(2,3,6)
scatter(CP.GCPdist,CP.diff,10,'filled','k')
x=CP.GCPdist;
y=CP.diff;
[p,S] = polyfit(x,y,1); 
[y_fit,delta] = polyval(p,x,S);
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+delta,'m--',x,y_fit-delta,'m--')
legend('Observations','Linear Fit','67% Prediction Interval')
xlabel('Distance of CP from nearest GCP [m]')
ylabel('DEM - CP elevation [m]')

%Saves figures
outname=strcat('Results/',filename(1:end-4),'.png')
saveas(gcf,outname);
%writes result table for each DEM
writetable(CP,strcat('Results/',filename(1:end-4)));
end;

