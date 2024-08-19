function wind_rose(wind_direction,wind_speed)
%WIND_ROSE Plot a wind rose
%   this plots a wind rose
figure
pax = polaraxes;
polarhistogram(deg2rad(wind_direction(wind_speed<25)),deg2rad(0:10:360),'displayname','20 - 25 m/s')
hold on
polarhistogram(deg2rad(wind_direction(wind_speed<20)),deg2rad(0:10:360),'FaceColor','red','displayname','15 - 20 m/s')
polarhistogram(deg2rad(wind_direction(wind_speed<15)),deg2rad(0:10:360),'FaceColor','yellow','displayname','10 - 15 m/s')
polarhistogram(deg2rad(wind_direction(wind_speed<10)),deg2rad(0:10:360),'FaceColor','green','displayname','5 - 10 m/s')
polarhistogram(deg2rad(wind_direction(wind_speed<5)),deg2rad(0:10:360),'FaceColor','blue','displayname','0 - 5 m/s')
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
legend('Show')
title('Wind Rose')

indx=find(wind_speed==0);
calm=(length(indx)./length(wind_speed)).*100;

annotation('textbox',[.7 .6 .1 .2],'String',['Porcentaje de calma: ', num2str(calm)],'EdgeColor','none');

end