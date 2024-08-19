
%% obtenemos y arreglamos los datos
clc
clear all
datos= readmatrix("chillan.xlsx"); %son del año 2022

t1= datetime(2022,01,01,'Format','dd-MMM-uuuu');
t2= datetime(2022,12,31,'Format','dd-MMM-uuuu');
tiempo= t1:t2;
tiempo= tiempo';

vel= datos(:,2)*1000/3600; %pasamos a m/s
dir= datos(:,3);

clear datos t1 t2

%% extraemos datos para verano que seria enero febrero y diciembre

time= datevec(tiempo); %año, mes, dia, etc
index1= find(time(:,2)==3 & time(:,3)== 20); %20 de marzo
index2= find(time(:,2)==12 & time(:,3)==21); % 21 de dic
vel_verano(:,1)= [vel(1:index1);vel(index2:end)];
dir_verano(:,1)= [dir(1:index1);dir(index2:end)];

%% extraemos datos para invierno que seria junio, julio y agosto

index3= find(time(:,2)==6 & time(:,3)==21); %21 de junio inicio invierno
index4= find(time(:,2)==9 & time(:,3)==20); %20 de sept fin invierno
vel_inv(:,1)= vel(index3:index4);
dir_inv(:,1)= dir(index3:index4);

%% rosa de los vientos

[rosa_verano,~,~,~,~,~] = WindRose(dir_verano,vel_verano);
[rosa_invierno,~,~,~,~,~] = WindRose(dir_inv,vel_inv);
[rosa,~,~,~,~,~] = WindRose(dir,vel);

%% histograma
figure
subplot 121
histogram(vel_verano,20)
legend('verano')
grid minor

subplot 122
histogram(vel_inv,20)
legend('invierno')
grid minor

figure
subplot 121
histogram(dir_verano,20)
legend('verano')
grid minor

subplot 122
histogram(dir_inv,20)
legend('invierno')
grid minor

%% grafico de vector progresivo

Vx=-vel.*sin(dir*pi/180);
Vy=-vel.*cos(dir*pi/180);

x=cumsum([0; Vx*86400]); %multiplicamos por la cantidad de segundos que tiene un dia
y=cumsum([0; Vy*86400]);
%clear Vy Vx

figure
plot(x/1000,y/1000,'LineWidth',2,'Color','blue')
title('Vector progresivo')
xlabel('Distancia zonal [km]')
ylabel('Distancia meridional [km]')
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


