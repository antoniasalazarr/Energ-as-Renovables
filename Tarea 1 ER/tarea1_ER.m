clc
clear all
%% obtenemos y arreglamos los datos
datos= readmatrix("chillan.xlsx"); %son del año 2022

t1= datetime(2022,01,01,'Format','dd-MMM-uuuu');
t2= datetime(2022,12,31,'Format','dd-MMM-uuuu');
tiempo= t1:t2;
time= tiempo';

vel= datos(:,2)*1000/3600; %pasamos a m/s
dir= datos(:,3);

clear datos tiempo t1 t2

%% extraemos datos para verano que seria enero febrero y diciembre

verano_vel(:,1)= [vel(1:59);vel(335:end)]; %enero, feb y dic de 2022
verano_dir(:,1)= [dir(1:59);dir(335:end)]; %enero, feb y dic de 2022

%% extraemos datos para invierno que seria junio, julio y agosto

invierno_vel(:,1)= vel(152:243); %junio, jilio y agosto de 2022
invierno_dir(:,1)= dir(152:243); %junio, jilio y agosto de 2022

%% rosa de los vientos
wind_rose(verano_dir,verano_vel)
title('Rosa de los vientos Verano en Chillán año 2022')

wind_rose(invierno_dir,invierno_vel)
title('Rosa de los vientos Invierno Chillan 2022')

%% grafico de vector progresivo

Vx=-vel.*sin(dir*pi/180);
Vy=-vel.*cos(dir*pi/180);

x=cumsum([0; Vx]);
y=cumsum([0; Vy]);
clear Vy Vx

figure
plot(x,y,'LineWidth',2,'Color','blue')
title('Gráfico de vector progresivo Chillán año 2022')
xlabel('Distancia zonal [m]')
ylabel('Distancia meridional [m]')
grid minor
axis tight

%% distribución de Weibull datos en m/s

desv= std(vel);
media= mean(vel);
k=(desv/media)^-1.086;

vel_ordenarda= sort(vel);
c= media/gamma(1+(1/k));
A= k/c;
B= (vel_ordenarda./c).^(k-1) ;
C= exp(-vel_ordenarda./c).^k;

weibull= A.*B.*C;


%% distribucion de weibull datos normalizados
v_norm= vel_ordenarda/media;
c2= 1/gamma(1+(1/k));
A2= k/c2;
B2= (v_norm./c2).^(k-1) ;
C2= exp(-v_norm./c2).^k;

weibull_norm= A2.*B2.*C2;


%% graficos
figure
subplot(1,2,1)
plot(vel_ordenarda,weibull,'LineWidth',2,'Color','blue')
%hold on
%histogram(vel_ordenarda,'Normalization','probability')
title('Distribución de Weibull ')
xlabel('Velocidad del viento [m/s]')
ylabel('Probabilidad')
xlim tight
grid minor

subplot(1,2,2)
plot(v_norm,weibull_norm,'r-','LineWidth',2)
title('Distribución de Weibull')
xlabel('v/v_{media}')
ylabel('Probabilidad de v/v_{media}')
grid minor
xlim tight


